enum LoginStatus { initial, loading, success, failure }

class LoginState {
  final LoginStatus status;
  final String? accessToken;
  final String? errorMessage;

  const LoginState({
    this.status = LoginStatus.initial,
    this.accessToken,
    this.errorMessage,
  });

  LoginState copyWith({
    LoginStatus? status,
    String? accessToken,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      accessToken: accessToken ?? this.accessToken,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
