import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/style.dart';

class CustomLoader {
  static get white => null;

  static void showDialog() {
    Get.dialog(
      WillPopScope(
        child: Container(
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(active),
            ),
          ),
        ),
        onWillPop: () => Future.value(false),
      ),
      barrierDismissible: false,
      barrierColor: white.withOpacity(.3),
      useSafeArea: true,
    );
  }

  static void cancelDialog() {
    Get.back();
  }
}