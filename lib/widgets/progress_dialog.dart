import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/style.dart';

import 'package:tranquil_life/helpers/constants.dart';

class ProgressDialog{
  static void showProgressbar(message){
    Dialog(
      child: Container(
        margin: const EdgeInsets.all(15.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(6.0)
        ),
        child: Row(
          children: [
            const SizedBox(width: 6.0),
            const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor)
            ),
            const SizedBox(width: 26.0),
            Text(message,
                style: const TextStyle(
                    color: Colors.black
                )
            )
          ],
        ),
      ),
    );
  }

  static void cancelDialog() {
    Get.back();
  }

}