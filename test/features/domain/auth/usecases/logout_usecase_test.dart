import 'package:demo/core/errors/failures.dart';
import 'package:demo/core/usecases/usecase.dart';
import 'package:demo/features/domain/auth/repositories/auth_repository.dart';
import 'package:demo/features/domain/auth/usecases/logout_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late LogoutUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LogoutUseCase(mockRepository);
  });

  group('LogoutUseCase', () {
    test('returns Unit on successful logout', () async {
      when(() => mockRepository.logout()).thenAnswer((_) async => right(unit));

      final result = await useCase(NoParams());

      expect(result, right(unit));
      verify(() => mockRepository.logout()).called(1);
    });

    test('returns ServerFailure when logout fails', () async {
      const failure = ServerFailure(message: 'Đăng xuất thất bại');
      when(
        () => mockRepository.logout(),
      ).thenAnswer((_) async => left(failure));

      final result = await useCase(NoParams());

      expect(result, left(failure));
    });

    test('calls repository logout exactly once', () async {
      when(() => mockRepository.logout()).thenAnswer((_) async => right(unit));

      await useCase(NoParams());

      verify(() => mockRepository.logout()).called(1);
    });
  });
}
