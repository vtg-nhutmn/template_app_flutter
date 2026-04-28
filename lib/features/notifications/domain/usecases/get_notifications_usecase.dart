import 'package:demo/core/errors/failures.dart';
import 'package:demo/core/usecases/usecase.dart';
import 'package:demo/features/notifications/domain/entities/notification_entity.dart';
import 'package:demo/features/notifications/domain/repositories/notification_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetNotificationsUseCase
    implements StreamUseCase<List<NotificationEntity>, NoParams> {
  final NotificationRepository _repository;

  GetNotificationsUseCase(this._repository);

  @override
  Stream<Either<Failure, List<NotificationEntity>>> call(NoParams params) =>
      _repository.watchNotifications();
}
