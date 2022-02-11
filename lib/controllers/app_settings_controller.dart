import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSettingsController extends GetxController {
  final bg = const Color(0xffdddddd);
  final color = const Color(0xff0E5D24);

  String message = "contact me via ayomideseaz@gmail.com, ok?";

  void checkIfEmailInString() {
    print(message.contains("@") || message.contains(".com"));
  }

}