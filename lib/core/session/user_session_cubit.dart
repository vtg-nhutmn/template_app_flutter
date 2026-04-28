import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_session_state.dart';

class UserSessionCubit extends Cubit<UserSessionState> {
  UserSessionCubit() : super(const UserSessionState());

  void updateSession({required bool isAdmin}) {
    emit(UserSessionState(isAdmin: isAdmin));
  }

  void clearSession() {
    emit(const UserSessionState());
  }
}
