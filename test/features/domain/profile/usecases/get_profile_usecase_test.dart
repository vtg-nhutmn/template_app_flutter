import 'package:demo/core/errors/failures.dart';
import 'package:demo/core/usecases/usecase.dart';
import 'package:demo/features/domain/profile/entities/profile_entity.dart';
import 'package:demo/features/domain/profile/repositories/profile_repository.dart';
import 'package:demo/features/domain/profile/usecases/get_profile_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository mockRepository;
  late GetProfileUseCase useCase;

  setUp(() {
    mockRepository = MockProfileRepository();
    useCase = GetProfileUseCase(mockRepository);
  });

  const tProfile = ProfileEntity(
    uid: 'uid1',
    username: 'testuser',
    email: 'test@example.com',
    displayName: 'Test User',
    phone: '0901234567',
    isActive: true,
    role: false,
    createdAt: '2026-01-01',
  );

  group('GetProfileUseCase', () {
    test('returns ProfileEntity on success', () async {
      when(
        () => mockRepository.getProfile(),
      ).thenAnswer((_) async => right(tProfile));

      final result = await useCase(NoParams());

      expect(result, right(tProfile));
      verify(() => mockRepository.getProfile()).called(1);
    });

    test('returns ServerFailure when repository fails', () async {
      const failure = ServerFailure(message: 'Không tìm thấy hồ sơ');
      when(
        () => mockRepository.getProfile(),
      ).thenAnswer((_) async => left(failure));

      final result = await useCase(NoParams());

      expect(result, left(failure));
    });

    test('calls repository getProfile exactly once', () async {
      when(
        () => mockRepository.getProfile(),
      ).thenAnswer((_) async => right(tProfile));

      await useCase(NoParams());

      verify(() => mockRepository.getProfile()).called(1);
    });
  });
}
