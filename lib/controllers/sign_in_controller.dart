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
  TextEditingController emailTextEditingController = TextEditingController(text: "ayomide@tranquil-life.health");
  TextEditingController passwordTextEditingController = TextEditingController(text: "passw1@");

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
    var body = jsonDecode(response.body)['user'];
    if(body!=null){
      accessToken =  body['auth_token'];
      sharedPreferences!.setString('accessToken', accessToken!);
      if(body['username'] == null){
        dashboardController.userType.value = consultant;
        sharedPreferences!.setString('userType', consultant);
        dashboardController.firstName.value = body['f_name'];
      }else{
        dashboardController.userType.value = client;
        //dashboardController.username.value = body['username'];
        sharedPreferences!.setString('userType', client);
        //sharedPreferences!.setString('username', body['username']);
      }

    }else{
      print(body["errors"]);
      throw Exception("Unable to Authenticate User");
    }
    return body;
  }
}