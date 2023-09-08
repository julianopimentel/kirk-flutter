import 'package:flutter/material.dart';

enum NotificationType { warning, success, error }

class NotificationService {
  static void showNotification(String message, NotificationType type, BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (type) {
      case NotificationType.warning:
        backgroundColor = Colors.amber;
        textColor = Colors.black;
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
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
