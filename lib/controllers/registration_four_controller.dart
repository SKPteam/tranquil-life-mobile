import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/main.dart';

import '../constants/controllers.dart';
import '../constants/style.dart';
import '../helpers/flush_bar_helper.dart';
import '../helpers/progress-dialog_helper.dart';
import '../routes/app_pages.dart';
import '../widgets/custom_loader.dart';
import '../widgets/custom_snackbar.dart';

class RegistrationFourController extends GetxController {
  static RegistrationFourController instance = Get.find();

  TextEditingController accountNameTEC = TextEditingController();
  TextEditingController accountNumberTEC = TextEditingController();
  TextEditingController homeAddressTEC = TextEditingController();
  TextEditingController bankNameTEC = TextEditingController();
  TextEditingController bankAddressTEC = TextEditingController();
  TextEditingController ibanTextEditingController = TextEditingController();
  TextEditingController swiftCodeTEC = TextEditingController();

  RxString passportURL = "".obs;
  RxString cvURL = "".obs;
  RxString videoURL = "".obs;

  @override
  void onInit() {
  }

  Future saveFilesToFbStorage() async{
    print("something");

    fbStorage = FirebaseStorage.instance;


    Reference identityStorageRef = fbStorage!.ref()
        .child(IDENTITY_PIC_STORAGE_PATH)
        .child(basename(registrationTwoController.passportPath.value));

    UploadTask identityUploadTask =
    identityStorageRef.putFile(File(registrationTwoController.passportPath.value));

    // String val = registrationTwoController.passportPath.value;
    //
    // print(basename(registrationTwoController.passportPath.value));
    // UploadTask identityUploadTask =
    // identityStorageRef.putFile(File(val));



    // Reference cvStorageRef = FirebaseStorage.instance
    //     .ref()
    //     .child(CV_FILES_STORAGE_PATH)
    //     .child(basename(registrationTwoController.cvPath.value));
    // UploadTask cvUploadTask =
    // cvStorageRef.putFile(File(registrationTwoController.cvPath.value));

    // List files = await Future.wait<String>([
    //   _uploadTaskNextStep(identityUploadTask, identityStorageRef),
    //   _uploadTaskNextStep(cvUploadTask, cvStorageRef),
    // ]).catchError((error) {
    //   CustomLoader.cancelDialog();
    //   // display error message
    //   CustomSnackBar.showSnackBar(
    //       context: Get.context,
    //       title: "An error occurred",
    //       message: error.toString(),
    //       backgroundColor: active);
    // });
    //
    // passportURL.value = "${files[0]}";
    // cvURL.value = "${files[1]}";
  }

  Future registerConsultant() async {
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
      "identity_front_url": passportURL.value.toString(),
      "cv_url": cvURL.value.toString(),
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

  Future<String> _uploadTaskNextStep(
      UploadTask uploadTask, Reference storage) async {
    await uploadTask;

    final url = await storage.getDownloadURL();

    CustomLoader.cancelDialog();
    return url;
  }

  Future saveConsultantProfile() async{
    await saveFilesToFbStorage();

    CustomLoader.cancelDialog();

    //registerConsultant();
  }

}