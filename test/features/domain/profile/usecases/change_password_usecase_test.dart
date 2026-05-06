import 'package:demo/core/errors/failures.dart';
import 'package:demo/features/domain/profile/repositories/profile_repository.dart';
import 'package:demo/features/domain/profile/usecases/change_password_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository mockRepository;
  late ChangePasswordUseCase useCase;

  setUp(() {
    mockRepository = MockProfileRepository();
    useCase = ChangePasswordUseCase(mockRepository);
  });

  const tParams = ChangePasswordParams(
    currentPassword: 'oldPassword123',
    newPassword: 'newPassword456',
  );

  group('ChangePasswordUseCase', () {
    test('returns Unit on successful password change', () async {
      when(
        () => mockRepository.changePassword(
          currentPassword: any(named: 'currentPassword'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenAnswer((_) async => right(unit));

      final result = await useCase(tParams);

      expect(result, right(unit));
    });

    test('returns ServerFailure when password change fails', () async {
      const failure = ServerFailure(message: 'Mật khẩu hiện tại không đúng');
      when(
        () => mockRepository.changePassword(
          currentPassword: any(named: 'currentPassword'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenAnswer((_) async => left(failure));

      final result = await useCase(tParams);

      expect(result, left(failure));
    });

    test('delegates currentPassword and newPassword correctly', () async {
      when(
        () => mockRepository.changePassword(
          currentPassword: tParams.currentPassword,
          newPassword: tParams.newPassword,
        ),
      ).thenAnswer((_) async => right(unit));

      await useCase(tParams);

      verify(
        () => mockRepository.changePassword(
          currentPassword: tParams.currentPassword,
          newPassword: tParams.newPassword,
        ),
      ).called(1);
    });
  });
}
