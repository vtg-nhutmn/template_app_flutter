import 'package:flutter/foundation.dart';
import 'package:vsa_model/core/network/token_storage.dart';
import 'login_model.dart';
import 'login_repository.dart';
import 'login_state.dart';

class LoginNotifier extends ChangeNotifier {
  final LoginRepository _repository;

  LoginNotifier({LoginRepository? repository})
    : _repository = repository ?? LoginRepository();

  LoginState _state = const LoginState();
  LoginState get state => _state;

  Future<void> login({
    required String username,
    required String password,
  }) async {
    _state = _state.copyWith(status: LoginStatus.loading);
    notifyListeners();

    try {
      final token = await _repository.login(
        LoginModel(username: username, password: password),
      );
      TokenStorage.save(token);
      _state = _state.copyWith(status: LoginStatus.success, accessToken: token);
    } on Exception catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      _state = _state.copyWith(
        status: LoginStatus.failure,
        errorMessage: message,
      );
    }
    notifyListeners();
  }
}
