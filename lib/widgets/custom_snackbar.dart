import 'package:flutter/material.dart';

displaySnackBar(String message, BuildContext context) {
  try {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2)
      ),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}