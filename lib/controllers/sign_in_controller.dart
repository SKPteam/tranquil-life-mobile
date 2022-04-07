import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/main.dart';
import '../helpers/progress-dialog_helper.dart';

class SignInController extends GetxController{
  static SignInController instance = Get.find();

  String? accessToken;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController = TextEditingController(text: "ayomideseaz@gmail.com");
  TextEditingController passwordTextEditingController = TextEditingController(text: "password123@");

  RxBool obscureText = RxBool(true);

  togglePassword(){
    obscureText.value = !(obscureText.value);
  }

  Future login(String email, String password) async {
    ProgressDialogHelper().showProgressDialog(Get.context!, "Authenticating...");
    String url = baseUrl + loginPath;

    var requestBody = {'email': email, 'password': password,};
    var response = await post(Uri.parse(url),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json"
        },
        body: json.encode(requestBody));
    var map = jsonDecode(response.body)['user'];
    if(map!=null){
      accessToken =  map['auth_token'];
      sharedPreferences!.setString('accessToken', accessToken!);
      dashboardController.userType = client;
      // dashboardController.username = map['username'];
      // dashboardController.firstName = map['f_name'];
      sharedPreferences!.setString('userType', client);
    }else{
      print(map["errors"]);
      throw Exception("Unable to Authenticate User");
    }
    return map;
  }
}