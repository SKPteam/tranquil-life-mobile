// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:tranquil_life/main.dart';
import 'package:tranquil_life/routes/app_pages.dart';
import 'package:tranquil_life/services/http_services.dart';

import '../constants/app_strings.dart';

class SplashScreenController extends GetxController{
  static SplashScreenController instance = Get.find();

  @override
  void onInit() {
    displaySplash();


    super.onInit();
  }

  /*
      HttpClass().httpPostRequest(
      {
      "Authorization": "Bearer ${sharedPreferences!.getString(
      'accessToken')}",
      },
      null, Uri.parse(url)).then((value) {
      var body = jsonDecode(value!.body);

      if (body['message'].toString() == isAuthenticated) {
      Get.offAllNamed(Routes.DASHBOARD);
      } else {

      }

      print("isAUTHENTICATED:POST: ${jsonDecode(value!.body)}");
      });
   * */

  void displaySplash() {
    Future.delayed(Duration(seconds: 4), () async {
      Get.offAllNamed(Routes.ON_BOARDING_ONE);
    });
  }

}