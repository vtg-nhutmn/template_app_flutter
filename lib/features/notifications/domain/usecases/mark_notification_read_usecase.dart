import 'package:demo/core/errors/failures.dart';
import 'package:demo/core/usecases/usecase.dart';
import 'package:demo/features/notifications/domain/repositories/notification_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

class MarkNotificationReadParams extends Equatable {
  final String notifId;

  const MarkNotificationReadParams({required this.notifId});

  @override
  List<Object?> get props => [notifId];
}

class MarkNotificationReadUseCase
    implements UseCase<void, MarkNotificationReadParams> {
  final NotificationRepository _repository;

  MarkNotificationReadUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(MarkNotificationReadParams params) =>
      _repository.markAsRead(params.notifId);
}
