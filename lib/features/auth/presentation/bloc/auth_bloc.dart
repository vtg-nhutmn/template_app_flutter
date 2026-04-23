import 'package:demo/core/usecases/usecase.dart';
import 'package:demo/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:demo/features/auth/domain/usecases/login_usecase.dart';
import 'package:demo/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final IsLoggedInUseCase _isLoggedInUseCase;

  AuthBloc(this._loginUseCase, this._logoutUseCase, this._isLoggedInUseCase)
    : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _isLoggedInUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (isLoggedIn) =>
          emit(isLoggedIn ? const AuthAuthenticated() : AuthUnauthenticated()),
    );
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _loginUseCase(
      LoginParams(username: event.username, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const AuthAuthenticated()),
    );
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _logoutUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }
}
