import 'package:demo/core/errors/failures.dart';
import 'package:demo/core/usecases/usecase.dart';
import 'package:demo/features/notifications/domain/entities/notification_entity.dart';
import 'package:demo/features/notifications/domain/usecases/create_notification_usecase.dart';
import 'package:demo/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:demo/features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkNotificationReadUseCase _markNotificationReadUseCase;
  final CreateNotificationUseCase _createNotificationUseCase;
  final FirebaseAuth _auth;

  NotificationBloc(
    this._getNotificationsUseCase,
    this._markNotificationReadUseCase,
    this._createNotificationUseCase,
    this._auth,
  ) : super(NotificationInitial()) {
    on<NotificationsSubscribeRequested>(_onSubscribeRequested);
    on<NotificationMarkReadRequested>(_onMarkReadRequested);
    on<NotificationCreateRequested>(_onCreateRequested);
  }

  Future<void> _onSubscribeRequested(
    NotificationsSubscribeRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    final userId = _auth.currentUser?.uid ?? '';
    await emit.forEach<Either<Failure, List<NotificationEntity>>>(
      _getNotificationsUseCase(NoParams()),
      onData: (result) => result.fold(
        (failure) => NotificationError(message: failure.message),
        (notifications) {
          final unreadCount = notifications
              .where((n) => !n.readBy.contains(userId))
              .length;
          return NotificationsLoaded(
            notifications: notifications,
            unreadCount: unreadCount,
            currentUserId: userId,
          );
        },
      ),
      onError: (error, _) => NotificationError(message: error.toString()),
    );
  }

  Future<void> _onMarkReadRequested(
    NotificationMarkReadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    await _markNotificationReadUseCase(
      MarkNotificationReadParams(notifId: event.notifId),
    );
  }

  Future<void> _onCreateRequested(
    NotificationCreateRequested event,
    Emitter<NotificationState> emit,
  ) async {
    await _createNotificationUseCase(event.params);
  }
}
