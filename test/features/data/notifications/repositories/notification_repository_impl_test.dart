import 'package:demo/core/errors/exceptions.dart';
import 'package:demo/core/errors/failures.dart';
import 'package:demo/features/data/notifications/datasources/notification_remote_data_source.dart';
import 'package:demo/features/data/notifications/models/notification_model.dart';
import 'package:demo/features/data/notifications/repositories/notification_repository_impl.dart';
import 'package:demo/features/domain/notifications/entities/notification_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationRemoteDataSource extends Mock
    implements NotificationRemoteDataSource {}

void main() {
  late MockNotificationRemoteDataSource mockDataSource;
  late NotificationRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockNotificationRemoteDataSource();
    repository = NotificationRepositoryImpl(mockDataSource);
  });

  const tModel = NotificationModel(
    id: 'n1',
    title: 'Hello',
    body: 'World',
    type: 'info',
    isGlobal: true,
    readBy: [],
    createdAt: '2026-01-01',
  );

  const tEntity = NotificationEntity(
    id: 'n1',
    title: 'Hello',
    body: 'World',
    type: 'info',
    isGlobal: true,
    readBy: [],
    createdAt: '2026-01-01',
  );

  group('watchNotifications', () {
    test('returns stream of NotificationEntity list on success', () async {
      when(
        () => mockDataSource.watchNotifications(),
      ).thenAnswer((_) => Stream.value([tModel]));

      final stream = repository.watchNotifications();
      final result = await stream.first;

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected right'),
        (list) => expect(list, [tEntity]),
      );
    });

    test(
      'returns stream with empty list when data source emits empty',
      () async {
        when(
          () => mockDataSource.watchNotifications(),
        ).thenAnswer((_) => Stream.value([]));

        final stream = repository.watchNotifications();
        final result = await stream.first;

        result.fold(
          (_) => fail('Expected right'),
          (list) => expect(list, isEmpty),
        );
      },
    );

    test(
      'stream completes without emitting when data source stream errors',
      () async {
        when(() => mockDataSource.watchNotifications()).thenAnswer(
          (_) => Stream.error(const ServerException(message: 'Lỗi Firestore')),
        );

        final stream = repository.watchNotifications();
        final items = await stream.toList();

        expect(items, isEmpty);
      },
    );
  });

  group('markAsRead', () {
    test('returns void on success', () async {
      when(() => mockDataSource.markAsRead(any())).thenAnswer((_) async {});

      final result = await repository.markAsRead('n1');

      expect(result.isRight(), isTrue);
      verify(() => mockDataSource.markAsRead('n1')).called(1);
    });

    test(
      'returns ServerFailure when data source throws ServerException',
      () async {
        when(
          () => mockDataSource.markAsRead(any()),
        ).thenThrow(const ServerException(message: 'Đánh dấu thất bại'));

        final result = await repository.markAsRead('n1');

        expect(result.isLeft(), isTrue);
        result.fold(
          (f) => expect((f as ServerFailure).message, 'Đánh dấu thất bại'),
          (_) => fail('Expected left'),
        );
      },
    );

    test(
      'returns ServerFailure when data source throws generic Exception',
      () async {
        when(
          () => mockDataSource.markAsRead(any()),
        ).thenThrow(Exception('Network error'));

        final result = await repository.markAsRead('n1');

        expect(result.isLeft(), isTrue);
      },
    );
  });

  group('createNotification', () {
    test('returns void on success', () async {
      when(
        () => mockDataSource.createNotification(
          title: any(named: 'title'),
          body: any(named: 'body'),
          type: any(named: 'type'),
          relatedId: any(named: 'relatedId'),
          isGlobal: any(named: 'isGlobal'),
          targetUserId: any(named: 'targetUserId'),
        ),
      ).thenAnswer((_) async {});

      final result = await repository.createNotification(
        title: 'Title',
        body: 'Body',
        type: 'info',
        isGlobal: true,
      );

      expect(result.isRight(), isTrue);
    });

    test(
      'returns ServerFailure when data source throws ServerException',
      () async {
        when(
          () => mockDataSource.createNotification(
            title: any(named: 'title'),
            body: any(named: 'body'),
            type: any(named: 'type'),
            relatedId: any(named: 'relatedId'),
            isGlobal: any(named: 'isGlobal'),
            targetUserId: any(named: 'targetUserId'),
          ),
        ).thenThrow(const ServerException(message: 'Tạo thông báo thất bại'));

        final result = await repository.createNotification(
          title: 'Title',
          body: 'Body',
          type: 'info',
          isGlobal: true,
        );

        expect(result.isLeft(), isTrue);
        result.fold(
          (f) => expect((f as ServerFailure).message, 'Tạo thông báo thất bại'),
          (_) => fail('Expected left'),
        );
      },
    );

    test('returns ServerFailure on generic exception', () async {
      when(
        () => mockDataSource.createNotification(
          title: any(named: 'title'),
          body: any(named: 'body'),
          type: any(named: 'type'),
          relatedId: any(named: 'relatedId'),
          isGlobal: any(named: 'isGlobal'),
          targetUserId: any(named: 'targetUserId'),
        ),
      ).thenThrow(Exception('Unknown'));

      final result = await repository.createNotification(
        title: 'T',
        body: 'B',
        type: 'x',
        isGlobal: false,
      );

      expect(result.isLeft(), isTrue);
    });
  });
}
