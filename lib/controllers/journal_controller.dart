// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class JournalController extends GetxController {
  static JournalController instance = Get.find();

  Size size = MediaQuery.of(Get.context!).size;

  /*........ Journal Controller ......*/
  AnimationController? controller;
  Animation<double>? textAnim;
  RxBool disposed = false.obs;
  double fontSizeForTitle = 45;
  Animation<double>? textSlideAnim;
  TextEditingController? headingController;
  TextEditingController bodyController = TextEditingController();

  var uuid = Uuid();

  final dateTime = DateTime.now();

  Size getSizeOfText(double sWidth) {
  final painter = TextPainter();
  painter.text = TextSpan(
  style: TextStyle(
  fontSize: fontSizeForTitle,
  ),
  text: 'What\'s On Your Mind?');
  painter.textDirection = TextDirection.ltr;
  painter.textAlign = TextAlign.left;
  painter.textScaleFactor = 1.0;
  painter.layout();
  return painter.size.width > sWidth
  ? Size(sWidth, painter.size.height * 2.5)
      : Size(painter.size.width, painter.size.height * 0.25);
  }

  Map data = {};
  void setFontSize(BuildContext context) {
  var width = size.width;
  if (width < 200) {
  fontSizeForTitle = 36;
  } else if (width < 300) {
  fontSizeForTitle = 42;
  } else if (width < 400) {
  fontSizeForTitle = 48;
  } else {
  fontSizeForTitle = 52;
  }
  }

  @override
  void onInit() {
  super.onInit();
  }

  @override
  void onReady() {
  super.onReady();
  }

  @override
  void onClose() {}
  }




//TODO: Implement business logic for every feature in the Journal page here:
//TODO: everything for journal and journal history
