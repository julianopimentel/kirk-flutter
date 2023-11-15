import 'package:flutter/material.dart';

enum NotificationType { warning, success, error }

class NotificationUtils {
  static late GlobalKey<ScaffoldMessengerState> scaffoldKey;
  // Função de inicialização para configurar a chave
  static void init(BuildContext context) {
    scaffoldKey = GlobalKey<ScaffoldMessengerState>();

    // Verifique se o widget que contém a ScaffoldMessenger está montado antes de atribuir a chave
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scaffoldKey = GlobalKey<ScaffoldMessengerState>();
      // Agora, scaffoldKey está inicializado e pronto para uso
    });
  }

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
    Navigator.of(context).pop();
  }

  static void showSuccess(BuildContext context, String message) {
    showNotification(message, NotificationType.success,context);
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
