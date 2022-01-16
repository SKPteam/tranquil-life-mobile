import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController{
  static SignInController instance = Get.find();


  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  RxBool obscureText = RxBool(true);

  togglePassword(){
    obscureText.value = !(obscureText.value);
  }
}