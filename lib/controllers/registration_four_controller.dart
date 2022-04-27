import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tranquil_life/constants/app_strings.dart';

import '../constants/controllers.dart';
import '../helpers/flush_bar_helper.dart';
import '../helpers/progress-dialog_helper.dart';
import '../routes/app_pages.dart';

class RegistrationFourController extends GetxController {
  static RegistrationFourController instance = Get.find();

  TextEditingController accountNameTEC = TextEditingController();
  TextEditingController accountNumberTEC = TextEditingController();
  TextEditingController homeAddressTEC = TextEditingController();
  TextEditingController bankNameTEC = TextEditingController();
  TextEditingController bankAddressTEC = TextEditingController();
  TextEditingController ibanTextEditingController = TextEditingController();
  TextEditingController swiftCodeTEC = TextEditingController();

  Future registerConsultant() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    ProgressDialogHelper().showProgressDialog(
        Get.context!, "Registering...");
    String url = baseUrl + consultantRegisterPath;

    var requestBody = {
      "f_name": registrationTwoController.firstNameTextEditingController.text,
      "l_name": registrationTwoController.lastNameTextEditingController.text,
      "email": registrationOneController.emailTextEditingController.text
          .removeAllWhitespace,
      "password": registrationOneController.passwordTextEditingController.text,
      "phone": registrationOneController.phoneNumTextEditingController.text
          .removeAllWhitespace,
      "languages": registrationThreeController.preferredLangTEC.text.split(", "),
      "years": registrationThreeController.yearsOfExpTEC.text,
      "identity_front_url": registrationTwoController.passportPath.value,
      "cv_url": registrationTwoController.cvPath.value,
      "employment_status": registrationThreeController.selectedWorkStatus.value,
      "specialties": registrationThreeController.areaOfExpertiseTEC.text.split(", "),
      "day_of_birth": registrationTwoController.day!,
      "month_of_birth": registrationTwoController.month!,
      "year_of_birth": registrationTwoController.year!,
      "home_address": homeAddressTEC.text,
      "account_number": accountNumberTEC.text,
      "bank_name": bankNameTEC.text,
      "bank_address": bankAddressTEC.text,
      "iban": ibanTextEditingController.text,
      "bic": swiftCodeTEC.text,
    };
    var response = await post(Uri.parse(url), headers: {
      "Content-type": "application/json",
      "Accept": "application/json"
    }, body: jsonEncode(requestBody));
    var result = json.decode(response.body);

    if (result["user"] != null) {
      // sharedPreferences.setString("userName", result["user"]["f_name"] + result["user"]["f_name"]);
      // sharedPreferences.setString("firstName", result["user"]["f_name"]);
      // sharedPreferences.setString("lastName", result["user"]["l_name"]);
      // sharedPreferences.setString("email", result["user"]["email"]);
      // sharedPreferences.setString("phoneNumber", result["user"]["phone"]);
      // sharedPreferences.setString("token", result["user"]["auth_token"]);
      ProgressDialogHelper().hideProgressDialog(Get.context!);
      Get.offAllNamed(Routes.SIGN_IN);
      FlushBarHelper(Get.context!).showFlushBar(
          "Registration Successful", color: Colors.green);
    } else if (result["user"] == null) {
      ProgressDialogHelper().hideProgressDialog(Get.context!);
      print(result);
      FlushBarHelper(Get.context!).showFlushBar(
          result["errors"].toString(), color: Colors.red);
    } else {
      ProgressDialogHelper().hideProgressDialog(Get.context!);
      throw Exception("Unable to Complete Registration");
    }

    return result;
  }


}