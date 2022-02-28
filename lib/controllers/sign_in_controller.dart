import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/controllers/dashboard_controller.dart';
import 'package:tranquil_life/main.dart';

class SignInController extends GetxController{
  static SignInController instance = Get.find();

  RxString accessToken = "".obs;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController = TextEditingController(text: 'ayomideseaz@gmail.com');
  TextEditingController passwordTextEditingController = TextEditingController(text: 'password');

  RxBool obscureText = RxBool(true);

  togglePassword(){
    obscureText.value = !(obscureText.value);
  }

  Future login(String email, String password) async {
    String url = baseUrl + loginPath;

    var requestBody = {
      'email': email,
      'password': password,
    };
    var response = await post(Uri.parse(url),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json"
        },
        body: json.encode(requestBody));

    accessToken.value =  json.decode(response.body)['user']['auth_token'];

    sharedPreferences!.setString('accessToken', accessToken.value);

    Map<String, dynamic> map = jsonDecode(response.body)['user'];

    if(map.containsKey("username")){
      //var key = map.containsKey("username");

      dashboardController.userType.value = client;
      sharedPreferences!.setString('userType', client);

      map.forEach((key, value) {
        dashboardController.username = map['username'].toString().obs;
      });
      print(dashboardController.username);

    }else{
      dashboardController.userType.value = consultant;
      sharedPreferences!.setString('userType', consultant);

      dashboardController.firstName = map['f_name'].toString().obs;
    }


    return dashboardController.userType.value;

  }
}