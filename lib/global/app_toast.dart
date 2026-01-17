import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AppToast {
  static void show({
    required String title,
    required String message,
    required Color backgroundColor,
    IconData? icon,
    Color? iconColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    Get.rawSnackbar(
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      backgroundColor: backgroundColor,
      snackPosition: SnackPosition.BOTTOM,
      duration: duration,
      isDismissible: true,
      animationDuration: const Duration(milliseconds: 10000),
      icon: icon != null ? Icon(icon, color: iconColor ?? Colors.white) : null,
      titleText: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      messageText: Text(message, style: const TextStyle(color: Colors.white)),
    );
  }

  // Exit app toast
  static void exitApp() {
    Fluttertoast.showToast(
      msg: "Press back again to exit",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black.withValues(alpha: 0.7),
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}
