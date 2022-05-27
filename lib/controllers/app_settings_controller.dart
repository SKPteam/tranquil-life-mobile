import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:tranquil_life/constants/app_strings.dart';

import '../main.dart';

class AppSettingsController extends GetxController {
  static AppSettingsController instance = Get.find();

  //final bg = const Color(0xffdddddd);
  final color = const Color(0xff0E5D24);

  String message = "contact me via ayomideseaz@gmail.com, ok?";

  void checkIfEmailInString() {
    print(message.contains("@") || message.contains(".com"));
  }

  Future logOut() async{
    String url = baseUrl +
        (sharedPreferences!.getString(userType) == client
            ? clientLogoutPath : consultantLogoutPath);

    var response = await post(Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${sharedPreferences!.getString('accessToken')}",
        });

    return response.body;
  }
}