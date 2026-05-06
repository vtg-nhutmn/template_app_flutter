import 'package:demo/core/errors/failures.dart';
import 'package:demo/features/domain/auth/entities/user_entity.dart';
import 'package:demo/features/domain/auth/repositories/auth_repository.dart';
import 'package:demo/features/domain/auth/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late LoginUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  const tParams = LoginParams(username: 'testuser', password: 'password123');
  const tUser = UserEntity(uid: 'uid1', email: 'test@example.com');

  group('LoginUseCase', () {
    test('returns UserEntity on successful login', () async {
      when(
        () => mockRepository.login(
          username: tParams.username,
          password: tParams.password,
        ),
      ).thenAnswer((_) async => right(tUser));

      final result = await useCase(tParams);

      expect(result, right(tUser));
      verify(
        () => mockRepository.login(
          username: tParams.username,
          password: tParams.password,
        ),
      ).called(1);
    });

    test('returns ServerFailure when repository fails', () async {
      const failure = ServerFailure(message: 'Sai mật khẩu');
      when(
        () => mockRepository.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => left(failure));

      final result = await useCase(tParams);

      expect(result, left(failure));
    });

    test('returns NetworkFailure when no connection', () async {
      const failure = NetworkFailure();
      when(
        () => mockRepository.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => left(failure));

      final result = await useCase(tParams);

      expect(result.isLeft(), isTrue);
    });

    test('delegates to repository with correct params', () async {
      when(
        () => mockRepository.login(username: 'myuser', password: 'mypass'),
      ).thenAnswer((_) async => right(tUser));

      await useCase(const LoginParams(username: 'myuser', password: 'mypass'));

      verify(
        () => mockRepository.login(username: 'myuser', password: 'mypass'),
      ).called(1);
    });
  });
}
