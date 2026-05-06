import 'package:demo/core/errors/failures.dart';
import 'package:demo/core/usecases/usecase.dart';
import 'package:demo/features/domain/auth/repositories/auth_repository.dart';
import 'package:demo/features/domain/auth/usecases/is_logged_in_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late IsLoggedInUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = IsLoggedInUseCase(mockRepository);
  });

  group('IsLoggedInUseCase', () {
    test('returns true when user is logged in', () async {
      when(
        () => mockRepository.isLoggedIn(),
      ).thenAnswer((_) async => right(true));

      final result = await useCase(NoParams());

      expect(result, right(true));
    });

    test('returns false when user is not logged in', () async {
      when(
        () => mockRepository.isLoggedIn(),
      ).thenAnswer((_) async => right(false));

      final result = await useCase(NoParams());

      expect(result, right(false));
    });

    test('returns Failure when repository throws error', () async {
      const failure = ServerFailure(
        message: 'Không thể kiểm tra trạng thái đăng nhập',
      );
      when(
        () => mockRepository.isLoggedIn(),
      ).thenAnswer((_) async => left(failure));

      final result = await useCase(NoParams());

      expect(result, left(failure));
    });

    test('calls repository isLoggedIn exactly once', () async {
      when(
        () => mockRepository.isLoggedIn(),
      ).thenAnswer((_) async => right(true));

      await useCase(NoParams());

      verify(() => mockRepository.isLoggedIn()).called(1);
    });
  });
}
