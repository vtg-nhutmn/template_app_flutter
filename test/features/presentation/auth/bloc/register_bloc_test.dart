import 'package:bloc_test/bloc_test.dart';
import 'package:demo/core/errors/failures.dart';
import 'package:demo/features/domain/auth/usecases/register_usecase.dart';
import 'package:demo/features/presentation/auth/bloc/register_bloc.dart';
import 'package:demo/features/presentation/auth/bloc/register_event.dart';
import 'package:demo/features/presentation/auth/bloc/register_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

void main() {
  late MockRegisterUseCase mockRegisterUseCase;

  setUp(() {
    mockRegisterUseCase = MockRegisterUseCase();
    registerFallbackValue(
      const RegisterParams(
        username: '',
        email: '',
        password: '',
        displayName: '',
        phone: '',
      ),
    );
  });

  RegisterBloc buildBloc() => RegisterBloc(mockRegisterUseCase);

  const tEvent = RegisterSubmitted(
    username: 'newuser',
    email: 'new@example.com',
    password: 'password123',
    displayName: 'New User',
    phone: '0901234567',
  );

  group('RegisterBloc', () {
    test('initial state is RegisterInitial', () {
      expect(buildBloc().state, isA<RegisterInitial>());
    });

    blocTest<RegisterBloc, RegisterState>(
      'emits [RegisterLoading, RegisterSuccess] on successful registration',
      build: buildBloc,
      setUp: () {
        when(
          () => mockRegisterUseCase(any()),
        ).thenAnswer((_) async => right(unit));
      },
      act: (bloc) => bloc.add(tEvent),
      expect: () => [isA<RegisterLoading>(), const RegisterSuccess()],
    );

    blocTest<RegisterBloc, RegisterState>(
      'emits [RegisterLoading, RegisterFailure] when registration fails',
      build: buildBloc,
      setUp: () {
        when(() => mockRegisterUseCase(any())).thenAnswer(
          (_) async => left(const ServerFailure(message: 'Email đã tồn tại')),
        );
      },
      act: (bloc) => bloc.add(tEvent),
      expect: () => [
        isA<RegisterLoading>(),
        isA<RegisterFailure>().having(
          (s) => s.message,
          'message',
          'Email đã tồn tại',
        ),
      ],
    );

    blocTest<RegisterBloc, RegisterState>(
      'emits [RegisterLoading, RegisterFailure] on NetworkFailure',
      build: buildBloc,
      setUp: () {
        when(
          () => mockRegisterUseCase(any()),
        ).thenAnswer((_) async => left(const NetworkFailure()));
      },
      act: (bloc) => bloc.add(tEvent),
      expect: () => [isA<RegisterLoading>(), isA<RegisterFailure>()],
    );
  });
}
