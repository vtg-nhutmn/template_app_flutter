import 'package:bloc_test/bloc_test.dart';
import 'package:demo/core/errors/failures.dart';
import 'package:demo/core/usecases/usecase.dart';
import 'package:demo/features/domain/auth/entities/user_entity.dart';
import 'package:demo/features/domain/auth/usecases/is_logged_in_usecase.dart';
import 'package:demo/features/domain/auth/usecases/login_usecase.dart';
import 'package:demo/features/domain/auth/usecases/logout_usecase.dart';
import 'package:demo/features/presentation/auth/bloc/auth_bloc.dart';
import 'package:demo/features/presentation/auth/bloc/auth_event.dart';
import 'package:demo/features/presentation/auth/bloc/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockIsLoggedInUseCase extends Mock implements IsLoggedInUseCase {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockIsLoggedInUseCase mockIsLoggedInUseCase;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(const LoginParams(username: '', password: ''));
  });

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockIsLoggedInUseCase = MockIsLoggedInUseCase();
  });

  AuthBloc buildBloc() =>
      AuthBloc(mockLoginUseCase, mockLogoutUseCase, mockIsLoggedInUseCase);

  group('AuthBloc', () {
    test('initial state is AuthInitial', () {
      expect(buildBloc().state, isA<AuthInitial>());
    });

    group('AuthCheckRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] when user is logged in',
        build: buildBloc,
        setUp: () {
          when(
            () => mockIsLoggedInUseCase(any()),
          ).thenAnswer((_) async => right(true));
        },
        act: (bloc) => bloc.add(AuthCheckRequested()),
        expect: () => [isA<AuthLoading>(), const AuthAuthenticated()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when user is not logged in',
        build: buildBloc,
        setUp: () {
          when(
            () => mockIsLoggedInUseCase(any()),
          ).thenAnswer((_) async => right(false));
        },
        act: (bloc) => bloc.add(AuthCheckRequested()),
        expect: () => [isA<AuthLoading>(), isA<AuthUnauthenticated>()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when isLoggedIn returns failure',
        build: buildBloc,
        setUp: () {
          when(() => mockIsLoggedInUseCase(any())).thenAnswer(
            (_) async => left(const ServerFailure(message: 'Error')),
          );
        },
        act: (bloc) => bloc.add(AuthCheckRequested()),
        expect: () => [isA<AuthLoading>(), isA<AuthUnauthenticated>()],
      );
    });

    group('AuthLoginRequested', () {
      final tEvent = AuthLoginRequested(username: 'user', password: 'pass');

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] on successful login',
        build: buildBloc,
        setUp: () {
          when(() => mockLoginUseCase(any())).thenAnswer(
            (_) async => right(const UserEntity(uid: 'u1', email: 'e@e.com')),
          );
        },
        act: (bloc) => bloc.add(tEvent),
        expect: () => [isA<AuthLoading>(), const AuthAuthenticated()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] on failed login',
        build: buildBloc,
        setUp: () {
          when(() => mockLoginUseCase(any())).thenAnswer(
            (_) async => left(const ServerFailure(message: 'Sai mật khẩu')),
          );
        },
        act: (bloc) => bloc.add(tEvent),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthError>().having((s) => s.message, 'message', 'Sai mật khẩu'),
        ],
      );
    });

    group('AuthLogoutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] on successful logout',
        build: buildBloc,
        setUp: () {
          when(
            () => mockLogoutUseCase(any()),
          ).thenAnswer((_) async => right(unit));
        },
        act: (bloc) => bloc.add(AuthLogoutRequested()),
        expect: () => [isA<AuthLoading>(), isA<AuthUnauthenticated>()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when logout fails',
        build: buildBloc,
        setUp: () {
          when(() => mockLogoutUseCase(any())).thenAnswer(
            (_) async =>
                left(const ServerFailure(message: 'Đăng xuất thất bại')),
          );
        },
        act: (bloc) => bloc.add(AuthLogoutRequested()),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthError>().having(
            (s) => s.message,
            'message',
            'Đăng xuất thất bại',
          ),
        ],
      );
    });
  });
}
