part of 'user_session_cubit.dart';

class UserSessionState extends Equatable {
  final bool isAdmin;
  final int unreadNotificationCount;

  const UserSessionState({
    this.isAdmin = false,
    this.unreadNotificationCount = 0,
  });

  @override
  List<Object?> get props => [isAdmin, unreadNotificationCount];
}
