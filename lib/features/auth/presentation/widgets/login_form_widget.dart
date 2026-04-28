import 'package:demo/core/utils/validators.dart';
import 'package:demo/core/widgets/app_password_field.dart';
import 'package:demo/core/widgets/app_text_field.dart';
import 'package:demo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:demo/features/auth/presentation/bloc/auth_event.dart';
import 'package:demo/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demo/core/widgets/primary_button.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _usernameController,
                labelText: 'Tên đăng nhập',
                prefixIcon: const Icon(Icons.person_outline),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                enabled: !isLoading,
                validator: Validators.validateUsername,
              ),
              const SizedBox(height: 16),
              AppPasswordField(
                controller: _passwordController,
                labelText: 'Mật khẩu',
                textInputAction: TextInputAction.done,
                enabled: !isLoading,
                validator: Validators.validatePassword,
                onFieldSubmitted: (_) => _onSubmit(),
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                label: 'Đăng nhập',
                onPressed: _onSubmit,
                isLoading: isLoading,
              ),
              if (state is AuthError) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    state.message,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
