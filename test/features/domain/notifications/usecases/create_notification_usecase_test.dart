import 'package:demo/core/errors/failures.dart';
import 'package:demo/features/domain/notifications/repositories/notification_repository.dart';
import 'package:demo/features/domain/notifications/usecases/create_notification_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationRepository extends Mock
    implements NotificationRepository {}

void main() {
  late MockNotificationRepository mockRepository;
  late CreateNotificationUseCase useCase;

  setUp(() {
    mockRepository = MockNotificationRepository();
    useCase = CreateNotificationUseCase(mockRepository);
  });

  const tParams = CreateNotificationParams(
    title: 'New Product',
    body: 'A new product has been added',
    type: 'product',
    isGlobal: true,
  );

  group('CreateNotificationUseCase', () {
    test('returns void on success', () async {
      when(
        () => mockRepository.createNotification(
          title: any(named: 'title'),
          body: any(named: 'body'),
          type: any(named: 'type'),
          relatedId: any(named: 'relatedId'),
          isGlobal: any(named: 'isGlobal'),
          targetUserId: any(named: 'targetUserId'),
        ),
      ).thenAnswer((_) async => const Right(null));

      final result = await useCase(tParams);

      expect(result.isRight(), isTrue);
    });

    test('returns ServerFailure when creation fails', () async {
      const failure = ServerFailure(message: 'Tạo thông báo thất bại');
      when(
        () => mockRepository.createNotification(
          title: any(named: 'title'),
          body: any(named: 'body'),
          type: any(named: 'type'),
          relatedId: any(named: 'relatedId'),
          isGlobal: any(named: 'isGlobal'),
          targetUserId: any(named: 'targetUserId'),
        ),
      ).thenAnswer((_) async => left(failure));

      final result = await useCase(tParams);

      expect(result, left(failure));
    });

    test('delegates all params to repository', () async {
      when(
        () => mockRepository.createNotification(
          title: tParams.title,
          body: tParams.body,
          type: tParams.type,
          relatedId: tParams.relatedId,
          isGlobal: tParams.isGlobal,
          targetUserId: tParams.targetUserId,
        ),
      ).thenAnswer((_) async => const Right(null));

      await useCase(tParams);

      verify(
        () => mockRepository.createNotification(
          title: tParams.title,
          body: tParams.body,
          type: tParams.type,
          relatedId: tParams.relatedId,
          isGlobal: tParams.isGlobal,
          targetUserId: tParams.targetUserId,
        ),
      ).called(1);
    });

    test('supports targeted notification (non-global)', () async {
      const targeted = CreateNotificationParams(
        title: 'Personal',
        body: 'Just for you',
        type: 'personal',
        isGlobal: false,
        targetUserId: 'user999',
      );
      when(
        () => mockRepository.createNotification(
          title: any(named: 'title'),
          body: any(named: 'body'),
          type: any(named: 'type'),
          relatedId: any(named: 'relatedId'),
          isGlobal: false,
          targetUserId: 'user999',
        ),
      ).thenAnswer((_) async => const Right(null));

      final result = await useCase(targeted);

      expect(result.isRight(), isTrue);
    });
  });
}
