import 'package:demo/core/errors/failures.dart';
import 'package:demo/core/usecases/usecase.dart';
import 'package:demo/features/domain/notifications/entities/notification_entity.dart';
import 'package:demo/features/domain/notifications/repositories/notification_repository.dart';
import 'package:demo/features/domain/notifications/usecases/get_notifications_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationRepository extends Mock
    implements NotificationRepository {}

void main() {
  late MockNotificationRepository mockRepository;
  late GetNotificationsUseCase useCase;

  setUp(() {
    mockRepository = MockNotificationRepository();
    useCase = GetNotificationsUseCase(mockRepository);
  });

  const tNotification = NotificationEntity(
    id: 'n1',
    title: 'Hello',
    body: 'World',
    type: 'info',
    isGlobal: true,
    readBy: [],
    createdAt: '2026-01-01',
  );

  group('GetNotificationsUseCase', () {
    test('returns stream of notifications on success', () async {
      when(
        () => mockRepository.watchNotifications(),
      ).thenAnswer((_) => Stream.value(right([tNotification])));

      final stream = useCase(NoParams());
      final result = await stream.first;

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Should be right'),
        (list) => expect(list, [tNotification]),
      );
    });

    test('returns stream with empty list when no notifications', () async {
      when(
        () => mockRepository.watchNotifications(),
      ).thenAnswer((_) => Stream.value(right([])));

      final stream = useCase(NoParams());
      final result = await stream.first;

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Should be right'),
        (list) => expect(list, isEmpty),
      );
    });

    test('returns stream of Failure on error', () async {
      const failure = ServerFailure(message: 'Lỗi kết nối');
      when(
        () => mockRepository.watchNotifications(),
      ).thenAnswer((_) => Stream.value(left(failure)));

      final stream = useCase(NoParams());
      final result = await stream.first;

      expect(result.isLeft(), isTrue);
    });

    test('delegates to repository watchNotifications', () async {
      when(
        () => mockRepository.watchNotifications(),
      ).thenAnswer((_) => Stream.value(right([])));

      useCase(NoParams());

      verify(() => mockRepository.watchNotifications()).called(1);
    });
  });
}
