// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tranquil_life/constants/controllers.dart';

TextFormField buildEmailFormField() {
  return TextFormField(
    controller: signInController.emailTextEditingController,
    keyboardType: TextInputType.emailAddress,
    style: TextStyle(
        fontSize: 18,
        color: Colors.black
    ),
    decoration: InputDecoration(
      fillColor: Colors.white,
      border: InputBorder.none,
      filled: true,
      hintText: "email address",
      hintStyle: TextStyle(
          fontSize: 18
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