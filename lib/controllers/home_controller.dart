// ignore_for_file: file_names

import 'package:get/get.dart';

class HomeController extends GetxController{
  static HomeController instance = Get.find();

  RxBool toggleValue = false.obs;

  //TODO: Implement business logic for every feature in the Home page here:
  //TODO: meetings, notifications, questionnaire
}