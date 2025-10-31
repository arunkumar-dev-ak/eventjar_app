import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  // Common base method
  static void _show({
    required String title,
    required String message,
    required Color backgroundColor,
    IconData? icon,
    Color? iconColor,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      icon: Icon(icon, color: iconColor ?? Colors.white),
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
    );
  }

  // ✅ Success Snackbar
  static void success({required String title, required String message}) {
    _show(
      title: title,
      message: message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
    );
  }

  // ⚠️ Warning Snackbar
  static void warning({required String title, required String message}) {
    _show(
      title: title,
      message: message,
      backgroundColor: Colors.orange,
      icon: Icons.warning_amber_rounded,
    );
  }

  // ❌ Error Snackbar
  static void error({required String title, required String message}) {
    _show(
      title: title,
      message: message,
      backgroundColor: Colors.red,
      icon: Icons.error_outline,
    );
  }
}
