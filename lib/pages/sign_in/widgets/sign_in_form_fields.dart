// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tranquil_life/constants/controllers.dart';

TextFormField buildEmailFormField() {
  return TextFormField(
    controller: signInController.emailTextEditingController,
    keyboardType: TextInputType.emailAddress,
    style: TextStyle(
        fontSize: 16,
        color: Colors.black
    ),
    decoration: InputDecoration(
      fillColor: Colors.white,
      border: InputBorder.none,
      filled: true,
      hintText: "email address",
      hintStyle: TextStyle(
          fontSize: 16
          , color: Colors.grey),
      contentPadding: EdgeInsets.symmetric(
          vertical: 25.0, horizontal: 16),
      // If  you are using latest version of flutter then lable text and hint text shown like this
      // if you r using flutter less then 1.20.* then maybe this is not working properly
      floatingLabelBehavior: FloatingLabelBehavior.always,
      //prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
    ),
  );
}

TextFormField buildPasswordFormField() {
  return TextFormField(
    obscureText: signInController.obscureText.value,
    controller: signInController.passwordTextEditingController,
    style: TextStyle(
        fontSize: 16
        ,
        color: Colors.black
    ),
    decoration: InputDecoration(
      suffix: InkWell(
          onTap: () {
            signInController.togglePassword();
          },
          child: Icon(signInController.obscureText.value ? Icons.visibility : Icons.visibility_off)
      ),
      hintText: "password",
      hintStyle: TextStyle(
          fontSize: 16
          , color: Colors.grey),
      fillColor: Colors.white,
      border: InputBorder.none,
      filled: true,
      contentPadding: EdgeInsets.symmetric(
          vertical: 20.0, horizontal: 16),
      // If  you are using latest version of flutter then lable text and hint text shown like this
      // if you r using flutter less then 1.20.* then maybe this is not working properly
      floatingLabelBehavior: FloatingLabelBehavior.always,
      //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
    ),
  );
}