import 'package:demo/core/errors/failures.dart';
import 'package:demo/features/domain/notifications/repositories/notification_repository.dart';
import 'package:demo/features/domain/notifications/usecases/mark_notification_read_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationRepository extends Mock
    implements NotificationRepository {}

void main() {
  late MockNotificationRepository mockRepository;
  late MarkNotificationReadUseCase useCase;

  setUp(() {
    mockRepository = MockNotificationRepository();
    useCase = MarkNotificationReadUseCase(mockRepository);
  });

  const tParams = MarkNotificationReadParams(notifId: 'notif123');

  group('MarkNotificationReadUseCase', () {
    test('returns void on success', () async {
      when(
        () => mockRepository.markAsRead(any()),
      ).thenAnswer((_) async => const Right(null));

      final result = await useCase(tParams);

      expect(result.isRight(), isTrue);
    });

    test('returns ServerFailure when marking fails', () async {
      const failure = ServerFailure(message: 'Đánh dấu thất bại');
      when(
        () => mockRepository.markAsRead(any()),
      ).thenAnswer((_) async => left(failure));

      final result = await useCase(tParams);

      expect(result, left(failure));
    });

    test('passes correct notifId to repository', () async {
      when(
        () => mockRepository.markAsRead('notif123'),
      ).thenAnswer((_) async => const Right(null));

      await useCase(tParams);

      verify(() => mockRepository.markAsRead('notif123')).called(1);
    });
  });
}
