import 'package:flutter/material.dart';
import 'package:vsa_model/core/spacings/app_spacings.dart';
import 'package:vsa_model/shared/widgets/app_button.dart';
import 'package:vsa_model/shared/widgets/app_text_field.dart';
import 'login_notifier.dart';
import 'login_state.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback? onLoginSuccess;

  const LoginPage({super.key, this.onLoginSuccess});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _notifier = LoginNotifier();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _notifier.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    _notifier.login(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập')),
      body: ListenableBuilder(
        listenable: _notifier,
        builder: (context, _) {
          final state = _notifier.state;

          if (state.status == LoginStatus.success) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.onLoginSuccess?.call();
            });
          }

          return Padding(
            padding: const EdgeInsets.all(AppSpacings.h16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextField(
                  controller: _usernameController,
                  label: 'Tên đăng nhập',
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacings.v16),
                AppTextField(
                  controller: _passwordController,
                  label: 'Mật khẩu',
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: _onLogin,
                ),
                const SizedBox(height: AppSpacings.v16),
                if (state.status == LoginStatus.failure)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacings.v8),
                    child: Text(
                      state.errorMessage ?? 'Đăng nhập thất bại',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                AppButton(
                  label: 'Đăng nhập',
                  isLoading: state.status == LoginStatus.loading,
                  onPressed: _onLogin,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
