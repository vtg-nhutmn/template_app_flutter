import 'package:demo/core/errors/failures.dart';
import 'package:demo/features/domain/profile/repositories/profile_repository.dart';
import 'package:demo/features/domain/profile/usecases/update_profile_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository mockRepository;
  late UpdateProfileUseCase useCase;

  setUp(() {
    mockRepository = MockProfileRepository();
    useCase = UpdateProfileUseCase(mockRepository);
  });

  const tParams = UpdateProfileParams(
    displayName: 'New Name',
    phone: '0901234567',
    email: 'new@example.com',
  );

  group('UpdateProfileUseCase', () {
    test('returns Unit on successful update', () async {
      when(
        () => mockRepository.updateProfile(
          displayName: any(named: 'displayName'),
          phone: any(named: 'phone'),
          email: any(named: 'email'),
        ),
      ).thenAnswer((_) async => right(unit));

      final result = await useCase(tParams);

      expect(result, right(unit));
    });

    test('returns ServerFailure when update fails', () async {
      const failure = ServerFailure(message: 'Cập nhật thất bại');
      when(
        () => mockRepository.updateProfile(
          displayName: any(named: 'displayName'),
          phone: any(named: 'phone'),
          email: any(named: 'email'),
        ),
      ).thenAnswer((_) async => left(failure));

      final result = await useCase(tParams);

      expect(result, left(failure));
    });

    test('delegates all params correctly to repository', () async {
      when(
        () => mockRepository.updateProfile(
          displayName: tParams.displayName,
          phone: tParams.phone,
          email: tParams.email,
        ),
      ).thenAnswer((_) async => right(unit));

      await useCase(tParams);

      verify(
        () => mockRepository.updateProfile(
          displayName: tParams.displayName,
          phone: tParams.phone,
          email: tParams.email,
        ),
      ).called(1);
    });
  });
}
