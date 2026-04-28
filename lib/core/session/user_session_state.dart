part of 'user_session_cubit.dart';

class UserSessionState extends Equatable {
  final bool isAdmin;

  const UserSessionState({this.isAdmin = false});

  @override
  List<Object?> get props => [isAdmin];
}
