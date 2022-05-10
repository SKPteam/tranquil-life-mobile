// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';

import '../helpers/flush_bar_helper.dart';
import '../routes/app_pages.dart';
import '../services/http_services.dart';

class RegistrationOneController extends GetxController {
  static RegistrationOneController instance = Get.find();

  Map data = {};

  TextEditingController emailTextEditingController = TextEditingController(text:"tundednut@gmail.com");
  TextEditingController phoneNumTextEditingController = TextEditingController(text: "08130308873");
  TextEditingController passwordTextEditingController = TextEditingController(text: "passw1@");
  TextEditingController confirmPwdTextEditingController = TextEditingController(text: "passw1@");
  // TextEditingController dobTextEditingController = TextEditingController();
  // TextEditingController firstNameTextEditingController = TextEditingController();
  // TextEditingController lastNameTextEditingController = TextEditingController();
  // TextEditingController userNameTextEditingController = TextEditingController();
  // TextEditingController companyEditingController = TextEditingController();

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

  // //Registration Fields
  // String? email;
  // String? phone;
  // String? password;
  // String? firstname;
  // String? lastname;
  // String? username;
  // String? age;
  // int? dayOfBirth;
  // int? monthOfBirth;
  // int? yearOfBirth;
  // String? companyID;
  //
  //
  // //To register a client
  // register() async {
  //   CustomProgressDialog().show();
  //   final phoneNumber = countryCode! + phone!;
  //   var phoneNum = phoneNumber.startsWith("0") ? "234${phoneNumber.substring(1)}" : phoneNumber;
  //   Map<String, String> header = {
  //     "Content-Type": "application/json",
  //     "Accept": "application/json",
  //   };
  //   Map<String, dynamic> body = {
  //     "email": email,
  //     "phone": phoneNum,
  //     "password": password,
  //     "f_name": firstname,
  //     "l_name": lastname,
  //     "username": username,
  //     "day_of_birth": dayOfBirth!.toInt(),
  //     "month_of_birth": monthOfBirth!.toInt(),
  //     "year_of_birth": yearOfBirth!.toInt(),
  //     "company_id": companyID
  //   };
  //   var url = Uri.parse("http://d138-102-91-4-168.ngrok.io/api/client/register");
  //   await HttpClass().httpPostRequest(header, body, url).then((value) async {
  //     final response = json.decode(value!.body);
  //     if (value.statusCode == 200 || value.statusCode == 201) {
  //       CustomProgressDialog().hide();
  //       Get.offAllNamed(Routes.SIGN_IN);
  //       FlushBarHelper(Get.context!).showFlushBar("Registration SuccessFull!", color: Colors.green);
  //     } else {
  //       CustomProgressDialog().hide();
  //       FlushBarHelper(Get.context!).showFlushBar(response["message"] == ""?"Oops! An Error Occur. Try again": response["message"], color: Colors.red);
  //     }
  //   }).onError((error, stackTrace) {
  //     print(error);
  //     CustomProgressDialog().hide();
  //   }).timeout(const Duration(seconds: 60), onTimeout: () {
  //     CustomProgressDialog().hide();
  //     FlushBarHelper(Get.context!).showFlushBar("Network Timeout!", color: Colors.red);
  //   });
  // }

  }