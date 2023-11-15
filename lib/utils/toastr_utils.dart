import 'package:flutter/material.dart';

enum NotificationType { warning, success, error }

class NotificationUtils {
  static void showNotification(String message, NotificationType type, BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (type) {
      case NotificationType.warning:
        backgroundColor = Colors.amber.shade500;
        textColor = Colors.white;
        break;
      case NotificationType.success:
        backgroundColor = Colors.green;
        textColor = Colors.white;
        break;
      case NotificationType.error:
        backgroundColor = Colors.red;
        textColor = Colors.white;
        break;
    }

    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showSuccess(BuildContext context, String message) {
    showNotification(message, NotificationType.success, context);
  }

  static void showWarning(BuildContext context, String message) {
    showNotification(message, NotificationType.warning, context);
  }

  static void showError(BuildContext context, String message) {
    showNotification(message, NotificationType.error, context);
  }

  static void showException(BuildContext context) {
    showNotification('Erro interno', NotificationType.error, context);
  }
}
