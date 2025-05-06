import 'package:flutter/material.dart';

class NotificationService {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showInfo(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackBar(
      message,
      backgroundColor: Colors.blueAccent,
      icon: Icons.info,
    );
  }

  static void showSuccess(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackBar(
      message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
    );
  }

  static void showError(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackBar(message, backgroundColor: Colors.red, icon: Icons.error);
  }

  static void _showSnackBar(
    String message, {
    Color backgroundColor = Colors.black87,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = messengerKey.currentState;
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}