import 'package:demo/app/theme/app_colors.dart';
import 'package:demo/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

enum DialogType { success, error, warning, info }

class AppAlertDialog extends StatelessWidget {
  final DialogType type;
  final String title;
  final String message;
  final String buttonText;

  const AppAlertDialog({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    required this.buttonText,
  });

  static Future<void> showSuccess(
    BuildContext context,
    String title,
    String message, {
    String buttonText = 'OK',
  }) => show(
    context,
    type: DialogType.success,
    title: title,
    message: message,
    buttonText: buttonText,
  );

  static Future<void> showError(
    BuildContext context,
    String title,
    String message, {
    String buttonText = 'OK',
  }) => show(
    context,
    type: DialogType.error,
    title: title,
    message: message,
    buttonText: buttonText,
  );

  static Future<void> showWarning(
    BuildContext context,
    String title,
    String message, {
    String buttonText = 'OK',
  }) => show(
    context,
    type: DialogType.warning,
    title: title,
    message: message,
    buttonText: buttonText,
  );

  static Future<void> showInfo(
    BuildContext context,
    String title,
    String message, {
    String buttonText = 'OK',
  }) => show(
    context,
    type: DialogType.info,
    title: title,
    message: message,
    buttonText: buttonText,
  );
  static Future<void> show(
    BuildContext context, {
    required DialogType type,
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AppAlertDialog(
        type: type,
        title: title,
        message: message,
        buttonText: buttonText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = _DialogConfig.fromType(type);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(config.icon, color: config.color, size: 56),
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
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: config.color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(buttonText, style: AppTextStyles.button),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogConfig {
  final IconData icon;
  final Color color;

  const _DialogConfig({required this.icon, required this.color});

  factory _DialogConfig.fromType(DialogType type) {
    switch (type) {
      case DialogType.success:
        return const _DialogConfig(
          icon: Icons.check_circle_outline,
          color: AppColors.primary,
        );
      case DialogType.error:
        return const _DialogConfig(
          icon: Icons.cancel_outlined,
          color: AppColors.error,
        );
      case DialogType.warning:
        return const _DialogConfig(
          icon: Icons.warning_amber_rounded,
          color: AppColors.secondary,
        );
      case DialogType.info:
        return const _DialogConfig(
          icon: Icons.info_outline,
          color: Colors.blue,
        );
    }
  }
}
