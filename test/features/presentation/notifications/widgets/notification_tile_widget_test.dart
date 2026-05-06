import 'package:demo/features/domain/notifications/entities/notification_entity.dart';
import 'package:demo/features/presentation/notifications/widgets/notification_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tNotification = NotificationEntity(
    id: 'n1',
    title: 'Test Notification',
    body: 'This is the notification body',
    type: 'info',
    isGlobal: true,
    readBy: [],
    createdAt: '2026-01-01T00:00:00.000Z',
  );

  Widget buildSubject({required bool isRead}) {
    return MaterialApp(
      home: Scaffold(
        body: NotificationTileWidget(
          notification: tNotification,
          isRead: isRead,
          onTap: () {},
        ),
      ),
    );
  }

  group('NotificationTileWidget', () {
    testWidgets('displays notification title', (tester) async {
      await tester.pumpWidget(buildSubject(isRead: false));
      expect(find.text('Test Notification'), findsOneWidget);
    });

    testWidgets('displays notification body', (tester) async {
      await tester.pumpWidget(buildSubject(isRead: false));
      expect(find.text('This is the notification body'), findsOneWidget);
    });

    testWidgets('shows unread indicator dot when isRead is false', (tester) async {
      await tester.pumpWidget(buildSubject(isRead: false));
      expect(
        find.byWidgetPredicate(
          (w) => w is Container && w.decoration is BoxDecoration,
        ),
        findsWidgets,
      );
    });

    testWidgets('has no trailing widget when isRead is true', (tester) async {
      await tester.pumpWidget(buildSubject(isRead: true));
      final listTile = tester.widget<ListTile>(find.byType(ListTile));
      expect(listTile.trailing, isNull);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationTileWidget(
              notification: tNotification,
              isRead: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ListTile));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('renders as a ListTile', (tester) async {
      await tester.pumpWidget(buildSubject(isRead: false));
      expect(find.byType(ListTile), findsOneWidget);
    });
  });
}
