import 'package:demo/app/theme/app_colors.dart';
import 'package:demo/core/utils/validators.dart';
import 'package:demo/core/widgets/app_password_field.dart';
import 'package:demo/core/widgets/primary_button.dart';
import 'package:demo/features/profile/presentation/bloc/change_password_bloc.dart';
import 'package:demo/features/profile/presentation/bloc/change_password_event.dart';
import 'package:demo/features/profile/presentation/bloc/change_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<ChangePasswordBloc>(),
      child: const _ChangePasswordView(),
    );
  }
}

class _ChangePasswordView extends StatelessWidget {
  const _ChangePasswordView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.primary,
            ),
          );
          context.pop();
        } else if (state is ChangePasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Đổi mật khẩu')),
        body: const SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: _ChangePasswordForm(),
          ),
        ),
      ),
    );
  }
}

class _ChangePasswordForm extends StatefulWidget {
  const _ChangePasswordForm();

  @override
  State<_ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<_ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _confirmKey = GlobalKey<FormFieldState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _confirmTouched = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ChangePasswordBloc>().add(
        ChangePasswordSubmitted(
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
        ),
      );
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      builder: (context, state) {
        final isLoading = state is ChangePasswordLoading;
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppPasswordField(
                controller: _currentPasswordController,
                labelText: 'Mật khẩu hiện tại',
                textInputAction: TextInputAction.next,
                enabled: !isLoading,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 16),
              AppPasswordField(
                controller: _newPasswordController,
                labelText: 'Mật khẩu mới',
                textInputAction: TextInputAction.next,
                enabled: !isLoading,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (_) {
                  if (_confirmTouched) _confirmKey.currentState?.validate();
                },
                validator: (value) {
                  final base = Validators.validatePassword(value);
                  if (base != null) return base;
                  if (value == _currentPasswordController.text) {
                    return 'Mật khẩu mới phải khác mật khẩu hiện tại';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppPasswordField(
                formFieldKey: _confirmKey,
                controller: _confirmPasswordController,
                labelText: 'Xác nhận mật khẩu mới',
                textInputAction: TextInputAction.done,
                enabled: !isLoading,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (_) {
                  if (!_confirmTouched) setState(() => _confirmTouched = true);
                },
                validator: (value) => Validators.validateConfirmPassword(
                  _newPasswordController.text,
                )(value),
                onFieldSubmitted: (_) => _onSubmit(),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Đổi mật khẩu',
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
