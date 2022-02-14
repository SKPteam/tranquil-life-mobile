// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HomeController extends GetxController{

  static HomeController instance = Get.find();
   RxDouble  position = 0.0.obs;

  Size size = MediaQuery.of(Get.context!).size;


// dimensions 500.. 530/ 35 ... top 110
// dimensions 535.. 700 ... top 130
// dimensions 700.. 890 ... top 150
// dimensions 890.. 1080 ... top 170
// dimensions 1080.. 1242 ... top 190
// dimensions 1242.. 1291 ... top 200

  dimensionTop (){
    if (size.width >= 535.0){
      position = 110.0.obs;
    } else if(size.width >= 530.0 && size.width <= 700.0) {
      position = 130.0.obs;
    } else if(size.width >= 700.0 && size.width <= 890.0) {
      position = 150.0.obs;
    } else if(size.width >= 890.0 && size.width <= 1080.0) {
      position = 170.0.obs;
    } else if(size.width >= 1080.0 && size.width <= 1242.0) {
      position = 190.0.obs;
    } else if(size.width >= 1242.0 && size.width <= 1291.0) {
      position = 200.0.obs;
    }
    return position.obs;
  }

  //TODO: Implement business logic for every feature in the Home page here:
  //TODO: meetings, notifications, questionnaire

  @override
  void onInit() {
    dimensionTop();
    super.onInit();
  }
}