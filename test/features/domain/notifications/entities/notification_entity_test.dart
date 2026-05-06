import 'package:demo/features/domain/notifications/entities/notification_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NotificationEntity', () {
    const entity = NotificationEntity(
      id: 'n1',
      title: 'Test',
      body: 'Body',
      type: 'info',
      isGlobal: false,
      readBy: ['user1', 'user2'],
      createdAt: '2026-01-01T00:00:00.000Z',
    );

    test('isReadBy returns true when userId is in readBy list', () {
      expect(entity.isReadBy('user1'), isTrue);
    });

    test('isReadBy returns true for second user in readBy list', () {
      expect(entity.isReadBy('user2'), isTrue);
    });

    test('isReadBy returns false when userId is not in readBy list', () {
      expect(entity.isReadBy('user3'), isFalse);
    });

    test('isReadBy returns false for empty readBy list', () {
      const emptyEntity = NotificationEntity(
        id: 'n2',
        title: 'Test',
        body: 'Body',
        type: 'info',
        isGlobal: true,
        readBy: [],
        createdAt: '2026-01-01T00:00:00.000Z',
      );
      expect(emptyEntity.isReadBy('user1'), isFalse);
    });

    test('props includes all fields for equality', () {
      const same = NotificationEntity(
        id: 'n1',
        title: 'Test',
        body: 'Body',
        type: 'info',
        isGlobal: false,
        readBy: ['user1', 'user2'],
        createdAt: '2026-01-01T00:00:00.000Z',
      );
      expect(entity, equals(same));
    });

    test('entities with different id are not equal', () {
      const other = NotificationEntity(
        id: 'n99',
        title: 'Test',
        body: 'Body',
        type: 'info',
        isGlobal: false,
        readBy: ['user1', 'user2'],
        createdAt: '2026-01-01T00:00:00.000Z',
      );
      expect(entity, isNot(equals(other)));
    });
  });
}
