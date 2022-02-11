// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';

class RegistrationOneController extends GetxController {
  static RegistrationOneController instance = Get.find();

  Map data = {};

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneNumTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPwdTextEditingController = TextEditingController();

  String? countryCode;
  String? phoneNumber;
  RxString userType = RxString('');
  RxString generatedPwd = RxString('');
  RxBool obscureText = RxBool(true);

  void togglePassword() {
    obscureText.value = !obscureText.value;
  }

  void onPressed(String pwdValue) {
    passwordTextEditingController = TextEditingController(text: pwdValue);
    confirmPwdTextEditingController = TextEditingController(text: "");
  }

  String getRandomPwd(int length)
  => String.fromCharCodes(
      Iterable.generate(
          length,
              (_) =>
                  randomChars.codeUnitAt(rnd.nextInt(randomChars.length))
      ));

  displaySnackBar(String message, BuildContext context) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(message,
              style: TextStyle(
                  fontSize: 18
              ),),
            duration: const Duration(seconds: 2),
            action: message == kInvalidPassError
                ?
            SnackBarAction(
              label: "Generate",
              onPressed: () {
                print(getRandomPwd(12));
                generatedPwd.value = getRandomPwd(12);
                passwordTextEditingController.text = generatedPwd.value;
              },
            ) : null
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void onInit() {
    print("USER_TYPE: ${onBoardingController.userType.value}");
    super.onInit();
  }

}