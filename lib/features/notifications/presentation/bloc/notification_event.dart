import 'package:demo/features/notifications/domain/usecases/create_notification_usecase.dart';
import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class NotificationsSubscribeRequested extends NotificationEvent {
  const NotificationsSubscribeRequested();
}

class NotificationMarkReadRequested extends NotificationEvent {
  final String notifId;

  const NotificationMarkReadRequested(this.notifId);

  @override
  List<Object?> get props => [notifId];
}

class NotificationCreateRequested extends NotificationEvent {
  final CreateNotificationParams params;

  const NotificationCreateRequested(this.params);

  @override
  List<Object?> get props => [params];
}
