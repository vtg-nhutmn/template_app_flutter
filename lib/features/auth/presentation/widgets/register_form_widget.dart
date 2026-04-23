import 'package:demo/core/utils/validators.dart';
import 'package:demo/core/widgets/app_password_field.dart';
import 'package:demo/core/widgets/app_text_field.dart';
import 'package:demo/features/auth/presentation/bloc/register_bloc.dart';
import 'package:demo/features/auth/presentation/bloc/register_event.dart';
import 'package:demo/features/auth/presentation/bloc/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'primary_button.dart';

class RegisterFormWidget extends StatefulWidget {
  const RegisterFormWidget({super.key});

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _displayNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<RegisterBloc>().add(
        RegisterSubmitted(
          username: _usernameController.text.trim(),
          displayName: _displayNameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        final isLoading = state is RegisterLoading;
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _usernameController,
                labelText: 'Tên đăng nhập',
                prefixIcon: const Icon(Icons.person_outline),
                textInputAction: TextInputAction.next,
                enabled: !isLoading,
                validator: Validators.validateUsername,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _displayNameController,
                labelText: 'Họ và tên',
                prefixIcon: const Icon(Icons.badge_outlined),
                textInputAction: TextInputAction.next,
                enabled: !isLoading,
                validator: Validators.validateFullName,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _emailController,
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                enabled: !isLoading,
                validator: Validators.validateEmail,
              ),
              const SizedBox(height: 16),

              AppTextField(
                controller: _phoneController,
                labelText: 'Số điện thoại',
                prefixIcon: const Icon(Icons.phone_outlined),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                enabled: !isLoading,
                validator: Validators.validatePhone,
              ),
              const SizedBox(height: 16),
              AppPasswordField(
                controller: _passwordController,
                labelText: 'Mật khẩu',
                textInputAction: TextInputAction.next,
                enabled: !isLoading,
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 16),
              AppPasswordField(
                controller: _confirmPasswordController,
                labelText: 'Xác nhận mật khẩu',
                textInputAction: TextInputAction.done,
                enabled: !isLoading,
                validator: (value) => Validators.validateConfirmPassword(
                  _passwordController.text,
                )(value),
                onFieldSubmitted: (_) => _onSubmit(),
              ),
              const SizedBox(height: 8),
              if (state is RegisterFailure)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    state.message,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 8),

              PrimaryButton(
                label: 'Đăng ký',
                onPressed: _onSubmit,
                isLoading: isLoading,
              ),
            ],
          ),
        );
      },
    );
  }
}
