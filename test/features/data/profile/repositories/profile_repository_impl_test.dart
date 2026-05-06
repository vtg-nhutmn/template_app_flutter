import 'package:demo/core/errors/exceptions.dart';
import 'package:demo/core/errors/failures.dart';
import 'package:demo/features/data/profile/datasources/profile_remote_data_source.dart';
import 'package:demo/features/data/profile/models/profile_model.dart';
import 'package:demo/features/data/profile/repositories/profile_repository_impl.dart';
import 'package:demo/features/domain/profile/entities/profile_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRemoteDataSource extends Mock
    implements ProfileRemoteDataSource {}

void main() {
  late MockProfileRemoteDataSource mockDataSource;
  late ProfileRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockProfileRemoteDataSource();
    repository = ProfileRepositoryImpl(mockDataSource);
  });

  const tProfileModel = ProfileModel(
    uid: 'uid1',
    username: 'testuser',
    email: 'test@example.com',
    displayName: 'Test User',
    phone: '0901234567',
    isActive: true,
    role: false,
    createdAt: '2026-01-01',
  );

  const tProfileEntity = ProfileEntity(
    uid: 'uid1',
    username: 'testuser',
    email: 'test@example.com',
    displayName: 'Test User',
    phone: '0901234567',
    isActive: true,
    role: false,
    createdAt: '2026-01-01',
  );

  group('getProfile', () {
    test('returns ProfileEntity on success', () async {
      when(
        () => mockDataSource.getProfile(),
      ).thenAnswer((_) async => tProfileModel);

      final result = await repository.getProfile();

      expect(result, right(tProfileEntity));
    });

    test(
      'returns ServerFailure when data source throws ServerException',
      () async {
        when(() => mockDataSource.getProfile()).thenThrow(
          const ServerException(message: 'Không tìm thấy người dùng'),
        );

        final result = await repository.getProfile();

        expect(result.isLeft(), isTrue);
        result.fold(
          (f) =>
              expect((f as ServerFailure).message, 'Không tìm thấy người dùng'),
          (_) => fail('Expected left'),
        );
      },
    );
  });

  group('updateProfile', () {
    test('returns Unit on success', () async {
      when(
        () => mockDataSource.updateProfile(
          displayName: any(named: 'displayName'),
          phone: any(named: 'phone'),
          email: any(named: 'email'),
        ),
      ).thenAnswer((_) async {});

      final result = await repository.updateProfile(
        displayName: 'New Name',
        phone: '0901234567',
        email: 'new@example.com',
      );

      expect(result, right(unit));
    });

    test(
      'returns ServerFailure when data source throws ServerException',
      () async {
        when(
          () => mockDataSource.updateProfile(
            displayName: any(named: 'displayName'),
            phone: any(named: 'phone'),
            email: any(named: 'email'),
          ),
        ).thenThrow(const ServerException(message: 'Cập nhật thất bại'));

        final result = await repository.updateProfile(
          displayName: 'Name',
          phone: '0901234567',
          email: 'e@e.com',
        );

        expect(result.isLeft(), isTrue);
      },
    );
  });

  group('changePassword', () {
    test('returns Unit on success', () async {
      when(
        () => mockDataSource.changePassword(
          currentPassword: any(named: 'currentPassword'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenAnswer((_) async {});

      final result = await repository.changePassword(
        currentPassword: 'oldPass',
        newPassword: 'newPass',
      );

      expect(result, right(unit));
    });

    test(
      'returns ServerFailure when data source throws ServerException',
      () async {
        when(
          () => mockDataSource.changePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
          ),
        ).thenThrow(
          const ServerException(message: 'Mật khẩu hiện tại không đúng'),
        );

        final result = await repository.changePassword(
          currentPassword: 'wrongPass',
          newPassword: 'newPass',
        );

        expect(result.isLeft(), isTrue);
        result.fold(
          (f) => expect(
            (f as ServerFailure).message,
            'Mật khẩu hiện tại không đúng',
          ),
          (_) => fail('Expected left'),
        );
      },
    );
  });
}
