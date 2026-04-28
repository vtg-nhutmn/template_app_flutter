import 'package:demo/core/errors/failures.dart';
import 'package:demo/core/usecases/usecase.dart';
import 'package:demo/features/notifications/domain/repositories/notification_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

class CreateNotificationParams extends Equatable {
  final String title;
  final String body;
  final String type;
  final String? relatedId;
  final bool isGlobal;
  final String? targetUserId;

  const CreateNotificationParams({
    required this.title,
    required this.body,
    required this.type,
    this.relatedId,
    this.isGlobal = true,
    this.targetUserId,
  });

  @override
  List<Object?> get props => [
    title,
    body,
    type,
    relatedId,
    isGlobal,
    targetUserId,
  ];
}

class CreateNotificationUseCase
    implements UseCase<void, CreateNotificationParams> {
  final NotificationRepository _repository;

  CreateNotificationUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(CreateNotificationParams params) =>
      _repository.createNotification(
        title: params.title,
        body: params.body,
        type: params.type,
        relatedId: params.relatedId,
        isGlobal: params.isGlobal,
        targetUserId: params.targetUserId,
      );
}
