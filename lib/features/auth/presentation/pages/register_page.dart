import 'package:demo/app/router/app_routes.dart';
import 'package:demo/app/theme/app_colors.dart';
import 'package:demo/app/theme/app_text_styles.dart';
import 'package:demo/features/auth/presentation/bloc/register_bloc.dart';
import 'package:demo/features/auth/presentation/bloc/register_state.dart';
import 'package:demo/features/auth/presentation/widgets/register_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<RegisterBloc>(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatelessWidget {
  const _RegisterView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đăng ký thành công! Vui lòng đăng nhập.'),
              backgroundColor: Colors.green,
            ),
          );
          context.go(AppRoutes.login);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đăng ký tài khoản'),
          leading: BackButton(onPressed: () => context.go(AppRoutes.login)),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.person_add_outlined,
                    size: 38,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Tạo tài khoản mới', style: AppTextStyles.heading1),
                const SizedBox(height: 6),
                const Text(
                  'Điền đầy đủ thông tin bên dưới',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 36),
                const RegisterFormWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
