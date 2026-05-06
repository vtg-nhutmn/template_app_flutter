import 'package:flutter/material.dart';
import 'dialogs/app_alert_dialog.dart';
import 'dialogs/app_confirm_dialog.dart';
import 'dialogs/app_notice_dialog.dart';

export 'dialogs/app_alert_dialog.dart' show AppAlertDialog, DialogType;
export 'dialogs/app_confirm_dialog.dart' show AppConfirmDialog;
export 'dialogs/app_notice_dialog.dart' show AppNoticeDialog;

class AppDialog {
  AppDialog._();
  static Future<void> showSuccess(
    BuildContext context,
    String title,
    String message, {
    String buttonText = 'OK',
  }) => AppAlertDialog.showSuccess(
    context,
    title,
    message,
    buttonText: buttonText,
  );

  static Future<void> showError(
    BuildContext context,
    String title,
    String message, {
    String buttonText = 'OK',
  }) =>
      AppAlertDialog.showError(context, title, message, buttonText: buttonText);

  static Future<void> showWarning(
    BuildContext context,
    String title,
    String message, {
    String buttonText = 'OK',
  }) => AppAlertDialog.showWarning(
    context,
    title,
    message,
    buttonText: buttonText,
  );

  static Future<void> showInfo(
    BuildContext context,
    String title,
    String message, {
    String buttonText = 'OK',
  }) =>
      AppAlertDialog.showInfo(context, title, message, buttonText: buttonText);

  static Future<void> showAlert(
    BuildContext context, {
    required DialogType type,
    required String title,
    required String message,
    String buttonText = 'OK',
  }) => AppAlertDialog.show(
    context,
    type: type,
    title: title,
    message: message,
    buttonText: buttonText,
  );

  static Future<bool?> showConfirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Xác nhận',
    String cancelText = 'Huỷ',
   IconData icon = Icons.notifications_outlined,
   
  }) => AppConfirmDialog.show(
    context,
    title: title,
    message: message,
    confirmText: confirmText,
    cancelText: cancelText,
    icon: icon,
  );

  static void showNotice(
    BuildContext context, {
    required String title,
    required String message,
    IconData icon = Icons.notifications_outlined,
    Color? iconColor,
  }) => AppNoticeDialog.show(
    context,
    title: title,
    message: message,
    icon: icon,
    iconColor: iconColor,
  );
  static void closeNotice(BuildContext context) =>
      AppNoticeDialog.close(context);
}
