import 'package:demo/app/theme/app_colors.dart';
import 'package:demo/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
class AppNoticeDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;

  const AppNoticeDialog({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
  });
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    IconData icon = Icons.notifications_outlined,
    Color? iconColor,
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AppNoticeDialog(
        title: title,
        message: message,
        icon: icon,
        iconColor: iconColor ?? AppColors.primary,
      ),
    );
  }

  static void close(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: iconColor, size: 56),
              const SizedBox(height: 16),
              Text(
                title,
                style: AppTextStyles.heading2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
