import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/style.dart';

class CustomSnackBar {
  static void showSnackBar({
    required BuildContext? context,
    required String title,
    required String message,
    required Color backgroundColor,
  }) {
    Get.snackbar(
      title,
      message,
      borderRadius: 12,
      colorText: light,
      backgroundColor: backgroundColor,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      duration: const Duration(milliseconds: 2500),
      animationDuration: const Duration(milliseconds: 400),
      titleText: Text(
        title,
        style: const TextStyle(fontSize: 16.5, color: light),
      ),
      messageText: Text(
        message,
        style: const TextStyle(fontSize: 14, color: light),
      ),
    );
  }
}
