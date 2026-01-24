import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showError(BuildContext context, String message) {
    _show(context, message, Colors.red);
  }

  static void showSuccess(BuildContext context, String message) {
    _show(context, message, Colors.green);
  }

  static void showInfo(BuildContext context, String message) {
    _show(context, message, Colors.blueGrey);
  }

  static void _show(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
