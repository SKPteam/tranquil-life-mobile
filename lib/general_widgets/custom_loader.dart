import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/style.dart';

class CustomLoader {
  static void showDialog() {
    Get.dialog(
      WillPopScope(
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(kPrimaryColor),
          ),
        ),
        onWillPop: () => Future.value(false),
      ),
      barrierDismissible: false,
      barrierColor: light.withOpacity(.3),
      useSafeArea: true,
    );
  }

  static void cancelDialog() => Get.close(1);
}
