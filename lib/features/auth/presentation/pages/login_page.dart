import 'package:architecture/app/theme/app_colors.dart';
import 'package:architecture/app/theme/app_text_styles.dart';
import 'package:architecture/features/auth/presentation/widgets/login_form_widget.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.eco, size: 48, color: Colors.white),
              ),
              const SizedBox(height: 24),
              const Text('Demo Architecture', style: AppTextStyles.heading1),
              const SizedBox(height: 8),
              const Text(
                'Đăng nhập để tiếp tục',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 48),
              const LoginFormWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
