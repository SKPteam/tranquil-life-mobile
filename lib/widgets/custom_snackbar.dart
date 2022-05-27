import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/style.dart';

class CustomSnackBar {
  static void showSnackBar({
    required BuildContext? context,
    required String title,
    required String message,
    required Color backgroundColor,
  }) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(milliseconds: 2000),
        animationDuration: const Duration(milliseconds: 0),
        backgroundColor: backgroundColor,
        titleText: Text(
          title,
          style: const TextStyle(fontSize: 16, color: light),
        ),
        messageText: Text(
          message,
          style: const TextStyle(fontSize: 16, color: light),
        ),
        colorText: Colors.white,
        borderRadius: 8,
        margin: const EdgeInsets.all(16));
  }
}