import 'package:demo/core/errors/failures.dart';
import 'package:demo/features/notifications/domain/entities/notification_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class NotificationRepository {
  Stream<Either<Failure, List<NotificationEntity>>> watchNotifications();

  Future<Either<Failure, void>> markAsRead(String notifId);

  Future<Either<Failure, void>> createNotification({
    required String title,
    required String body,
    required String type,
    String? relatedId,
    required bool isGlobal,
    String? targetUserId,
  });
}
