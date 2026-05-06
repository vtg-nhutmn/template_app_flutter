import 'package:demo/core/errors/exceptions.dart';
import 'package:demo/core/errors/failures.dart';
import 'package:demo/core/network/network_info.dart';
import 'package:demo/features/data/auth/datasources/auth_remote_data_source.dart';
import 'package:demo/features/data/auth/models/user_model.dart';
import 'package:demo/features/data/auth/repositories/auth_repository_impl.dart';
import 'package:demo/features/domain/auth/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late MockAuthRemoteDataSource mockDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late MockFirebaseAuth mockFirebaseAuth;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockAuthRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockFirebaseAuth = MockFirebaseAuth();
    repository = AuthRepositoryImpl(
      mockDataSource,
      mockNetworkInfo,
      mockFirebaseAuth,
    );
  });

  const tUserModel = UserModel(uid: 'uid1', email: 'test@example.com');
  const tUserEntity = UserEntity(uid: 'uid1', email: 'test@example.com');

  group('login', () {
    test(
      'returns UserEntity when network is connected and data source succeeds',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockDataSource.login(username: 'user', password: 'pass'),
        ).thenAnswer((_) async => tUserModel);

        final result = await repository.login(
          username: 'user',
          password: 'pass',
        );

        expect(result, right(tUserEntity));
      },
    );

    test('returns NetworkFailure when not connected', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.login(username: 'user', password: 'pass');

      expect(result, left(const NetworkFailure()));
      verifyNever(
        () => mockDataSource.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      );
    });

    test(
      'returns ServerFailure when data source throws ServerException',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockDataSource.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenThrow(const ServerException(message: 'Sai mật khẩu'));

        final result = await repository.login(
          username: 'user',
          password: 'wrong',
        );

        expect(result.isLeft(), isTrue);
        result.fold(
          (f) => expect(f, isA<ServerFailure>()),
          (_) => fail('Expected left'),
        );
      },
    );
  });

  group('logout', () {
    test('returns Unit on successful signOut', () async {
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

      final result = await repository.logout();

      expect(result, right(unit));
      verify(() => mockFirebaseAuth.signOut()).called(1);
    });

    test('returns ServerFailure when signOut throws', () async {
      when(
        () => mockFirebaseAuth.signOut(),
      ).thenThrow(Exception('signOut failed'));

      final result = await repository.logout();

      expect(result.isLeft(), isTrue);
    });
  });

  group('isLoggedIn', () {
    test('returns true when currentUser is not null', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(MockFirebaseUser());

      final result = await repository.isLoggedIn();

      expect(result, right(true));
    });

    test('returns false when currentUser is null', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);

      final result = await repository.isLoggedIn();

      expect(result, right(false));
    });
  });
  group('register', () {
    test(
      'returns Unit when network is connected and data source succeeds',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockDataSource.register(
            username: any(named: 'username'),
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
            phone: any(named: 'phone'),
          ),
        ).thenAnswer((_) async => tUserModel);

        final result = await repository.register(
          username: 'newuser',
          email: 'new@example.com',
          password: 'password123',
          displayName: 'New User',
          phone: '0901234567',
        );

        expect(result, right(unit));
      },
    );

    test('returns NetworkFailure when not connected', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.register(
        username: 'newuser',
        email: 'new@example.com',
        password: 'password123',
        displayName: 'New User',
        phone: '0901234567',
      );

      expect(result, left(const NetworkFailure()));
    });

    test(
      'returns ServerFailure when data source throws ServerException',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockDataSource.register(
            username: any(named: 'username'),
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
            phone: any(named: 'phone'),
          ),
        ).thenThrow(const ServerException(message: 'Email đã tồn tại'));

        final result = await repository.register(
          username: 'newuser',
          email: 'existing@example.com',
          password: 'password123',
          displayName: 'New User',
          phone: '0901234567',
        );

        expect(result.isLeft(), isTrue);
        result.fold(
          (f) => expect((f as ServerFailure).message, 'Email đã tồn tại'),
          (_) => fail('Expected left'),
        );
      },
    );
  });
}
