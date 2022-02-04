// ignore_for_file: non_constant_identifier_names

import 'dart:html';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:tranquil_life/routes/app_pages.dart';

class ProfileController extends GetxController {
  static ProfileController instance = Get.find();


//TODO: Implement business logic for every feature in the Profile page here:
//TODO: everything for Profile and edit profile page




}

/*....... App Setting Controller ......*/

class AppSettingsController extends GetxController {
  final bg = const Color(0xffdddddd);
  final color = const Color(0xff0E5D24);

  String message = "contact me via ayomideseaz@gmail.com, ok?";

  void checkIfEmailInString() {
    print(message.contains("@") || message.contains(".com"));
  }

}