import 'package:demo/core/errors/failures.dart';
import 'package:demo/features/domain/auth/repositories/auth_repository.dart';
import 'package:demo/features/domain/auth/usecases/register_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late RegisterUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = RegisterUseCase(mockRepository);
  });

  const tParams = RegisterParams(
    username: 'newuser',
    email: 'new@example.com',
    password: 'password123',
    displayName: 'New User',
    phone: '0901234567',
  );

  group('RegisterUseCase', () {
    test('returns Unit on successful registration', () async {
      when(
        () => mockRepository.register(
          username: any(named: 'username'),
          email: any(named: 'email'),
          password: any(named: 'password'),
          displayName: any(named: 'displayName'),
          phone: any(named: 'phone'),
        ),
      ).thenAnswer((_) async => right(unit));

      final result = await useCase(tParams);

      expect(result, right(unit));
    });

    test('returns ServerFailure when registration fails', () async {
      const failure = ServerFailure(message: 'Email đã tồn tại');
      when(
        () => mockRepository.register(
          username: any(named: 'username'),
          email: any(named: 'email'),
          password: any(named: 'password'),
          displayName: any(named: 'displayName'),
          phone: any(named: 'phone'),
        ),
      ).thenAnswer((_) async => left(failure));

      final result = await useCase(tParams);

      expect(result, left(failure));
    });

    test('returns NetworkFailure when no connection', () async {
      const failure = NetworkFailure();
      when(
        () => mockRepository.register(
          username: any(named: 'username'),
          email: any(named: 'email'),
          password: any(named: 'password'),
          displayName: any(named: 'displayName'),
          phone: any(named: 'phone'),
        ),
      ).thenAnswer((_) async => left(failure));

      final result = await useCase(tParams);

      expect(result.isLeft(), isTrue);
    });

    test('delegates all params correctly to repository', () async {
      when(
        () => mockRepository.register(
          username: tParams.username,
          email: tParams.email,
          password: tParams.password,
          displayName: tParams.displayName,
          phone: tParams.phone,
        ),
      ).thenAnswer((_) async => right(unit));

      await useCase(tParams);

      verify(
        () => mockRepository.register(
          username: tParams.username,
          email: tParams.email,
          password: tParams.password,
          displayName: tParams.displayName,
          phone: tParams.phone,
        ),
      ).called(1);
    });
  });
}
