import 'package:bloc_test/bloc_test.dart';
import 'package:demo/core/errors/failures.dart';
import 'package:demo/core/usecases/usecase.dart';
import 'package:demo/features/domain/notifications/entities/notification_entity.dart';
import 'package:demo/features/domain/notifications/usecases/create_notification_usecase.dart';
import 'package:demo/features/domain/notifications/usecases/get_notifications_usecase.dart';
import 'package:demo/features/domain/notifications/usecases/mark_notification_read_usecase.dart';
import 'package:demo/features/presentation/notifications/bloc/notification_bloc.dart';
import 'package:demo/features/presentation/notifications/bloc/notification_event.dart';
import 'package:demo/features/presentation/notifications/bloc/notification_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockGetNotificationsUseCase extends Mock
    implements GetNotificationsUseCase {}

class MockMarkNotificationReadUseCase extends Mock
    implements MarkNotificationReadUseCase {}

class MockCreateNotificationUseCase extends Mock
    implements CreateNotificationUseCase {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

void main() {
  late MockGetNotificationsUseCase mockGetUseCase;
  late MockMarkNotificationReadUseCase mockMarkReadUseCase;
  late MockCreateNotificationUseCase mockCreateUseCase;
  late MockFirebaseAuth mockAuth;
  late MockUser mockUser;

  setUp(() {
    mockGetUseCase = MockGetNotificationsUseCase();
    mockMarkReadUseCase = MockMarkNotificationReadUseCase();
    mockCreateUseCase = MockCreateNotificationUseCase();
    mockAuth = MockFirebaseAuth();
    mockUser = MockUser();

    registerFallbackValue(NoParams());
    registerFallbackValue(const MarkNotificationReadParams(notifId: ''));
    registerFallbackValue(
      const CreateNotificationParams(title: '', body: '', type: ''),
    );
  });

  NotificationBloc buildBloc() => NotificationBloc(
    mockGetUseCase,
    mockMarkReadUseCase,
    mockCreateUseCase,
    mockAuth,
  );

  const tNotification = NotificationEntity(
    id: 'n1',
    title: 'Hello',
    body: 'World',
    type: 'info',
    isGlobal: true,
    readBy: [],
    createdAt: '2026-01-01',
  );

  group('NotificationBloc', () {
    test('initial state is NotificationInitial', () {
      expect(buildBloc().state, isA<NotificationInitial>());
    });

    group('NotificationsSubscribeRequested', () {
      blocTest<NotificationBloc, NotificationState>(
        'emits [NotificationLoading, NotificationsLoaded] on stream data',
        build: buildBloc,
        setUp: () {
          when(() => mockAuth.currentUser).thenReturn(mockUser);
          when(() => mockUser.uid).thenReturn('user1');
          when(
            () => mockGetUseCase(any()),
          ).thenAnswer((_) => Stream.value(right([tNotification])));
        },
        act: (bloc) => bloc.add(const NotificationsSubscribeRequested()),
        expect: () => [
          isA<NotificationLoading>(),
          isA<NotificationsLoaded>()
              .having((s) => s.notifications, 'notifications', [tNotification])
              .having((s) => s.unreadCount, 'unreadCount', 1)
              .having((s) => s.currentUserId, 'currentUserId', 'user1'),
        ],
      );

      blocTest<NotificationBloc, NotificationState>(
        'unreadCount is 0 when all notifications are read by current user',
        build: buildBloc,
        setUp: () {
          when(() => mockAuth.currentUser).thenReturn(mockUser);
          when(() => mockUser.uid).thenReturn('user1');
          const readNotif = NotificationEntity(
            id: 'n2',
            title: 'Read',
            body: 'Already read',
            type: 'info',
            isGlobal: true,
            readBy: ['user1'],
            createdAt: '2026-01-01',
          );
          when(
            () => mockGetUseCase(any()),
          ).thenAnswer((_) => Stream.value(right([readNotif])));
        },
        act: (bloc) => bloc.add(const NotificationsSubscribeRequested()),
        expect: () => [
          isA<NotificationLoading>(),
          isA<NotificationsLoaded>().having(
            (s) => s.unreadCount,
            'unreadCount',
            0,
          ),
        ],
      );

      blocTest<NotificationBloc, NotificationState>(
        'emits [NotificationLoading, NotificationError] on stream failure',
        build: buildBloc,
        setUp: () {
          when(() => mockAuth.currentUser).thenReturn(mockUser);
          when(() => mockUser.uid).thenReturn('user1');
          when(() => mockGetUseCase(any())).thenAnswer(
            (_) =>
                Stream.value(left(const ServerFailure(message: 'Lỗi stream'))),
          );
        },
        act: (bloc) => bloc.add(const NotificationsSubscribeRequested()),
        expect: () => [
          isA<NotificationLoading>(),
          isA<NotificationError>().having(
            (s) => s.message,
            'message',
            'Lỗi stream',
          ),
        ],
      );

      blocTest<NotificationBloc, NotificationState>(
        'uses empty userId when currentUser is null',
        build: buildBloc,
        setUp: () {
          when(() => mockAuth.currentUser).thenReturn(null);
          when(
            () => mockGetUseCase(any()),
          ).thenAnswer((_) => Stream.value(right([])));
        },
        act: (bloc) => bloc.add(const NotificationsSubscribeRequested()),
        expect: () => [
          isA<NotificationLoading>(),
          isA<NotificationsLoaded>().having(
            (s) => s.currentUserId,
            'currentUserId',
            '',
          ),
        ],
      );
    });

    group('NotificationMarkReadRequested', () {
      blocTest<NotificationBloc, NotificationState>(
        'calls markRead use case and emits no new state on success',
        build: buildBloc,
        setUp: () {
          when(
            () => mockMarkReadUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
        },
        act: (bloc) => bloc.add(const NotificationMarkReadRequested('n1')),
        expect: () => [],
        verify: (_) {
          verify(
            () => mockMarkReadUseCase(
              const MarkNotificationReadParams(notifId: 'n1'),
            ),
          ).called(1);
        },
      );
    });

    group('NotificationCreateRequested', () {
      const tParams = CreateNotificationParams(
        title: 'New Product',
        body: 'A product was added',
        type: 'product',
        isGlobal: true,
      );

      blocTest<NotificationBloc, NotificationState>(
        'calls create use case and emits no new state on success',
        build: buildBloc,
        setUp: () {
          when(
            () => mockCreateUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
        },
        act: (bloc) => bloc.add(const NotificationCreateRequested(tParams)),
        expect: () => [],
        verify: (_) {
          verify(() => mockCreateUseCase(tParams)).called(1);
        },
      );
    });
  });
}
