import 'package:bloc_test/bloc_test.dart';
import 'package:demo/core/errors/failures.dart';
import 'package:demo/features/domain/profile/usecases/change_password_usecase.dart';
import 'package:demo/features/presentation/profile/bloc/change_password/change_password_bloc.dart';
import 'package:demo/features/presentation/profile/bloc/change_password/change_password_event.dart';
import 'package:demo/features/presentation/profile/bloc/change_password/change_password_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockChangePasswordUseCase extends Mock implements ChangePasswordUseCase {}

void main() {
  late MockChangePasswordUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockChangePasswordUseCase();
    registerFallbackValue(
      const ChangePasswordParams(currentPassword: '', newPassword: ''),
    );
  });

  ChangePasswordBloc buildBloc() => ChangePasswordBloc(mockUseCase);

  const tEvent = ChangePasswordSubmitted(
    currentPassword: 'oldPass123',
    newPassword: 'newPass456',
  );

  group('ChangePasswordBloc', () {
    test('initial state is ChangePasswordInitial', () {
      expect(buildBloc().state, isA<ChangePasswordInitial>());
    });

    blocTest<ChangePasswordBloc, ChangePasswordState>(
      'emits [ChangePasswordLoading, ChangePasswordSuccess] on success',
      build: buildBloc,
      setUp: () {
        when(() => mockUseCase(any())).thenAnswer((_) async => right(unit));
      },
      act: (bloc) => bloc.add(tEvent),
      expect: () => [
        isA<ChangePasswordLoading>(),
        isA<ChangePasswordSuccess>().having(
          (s) => s.message,
          'message',
          'Đổi mật khẩu thành công',
        ),
      ],
    );

    blocTest<ChangePasswordBloc, ChangePasswordState>(
      'emits [ChangePasswordLoading, ChangePasswordFailure] when use case fails',
      build: buildBloc,
      setUp: () {
        when(() => mockUseCase(any())).thenAnswer(
          (_) async =>
              left(const ServerFailure(message: 'Mật khẩu không đúng')),
        );
      },
      act: (bloc) => bloc.add(tEvent),
      expect: () => [
        isA<ChangePasswordLoading>(),
        isA<ChangePasswordFailure>().having(
          (s) => s.message,
          'message',
          'Mật khẩu không đúng',
        ),
      ],
    );
  });
}
