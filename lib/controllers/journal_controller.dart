// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/helpers/progress-dialog_helper.dart';
import 'package:uuid/uuid.dart';
import '../helpers/flush_bar_helper.dart';
import '../routes/app_pages.dart';

class JournalController extends GetxController {
  static JournalController instance = Get.find();

  Size size = MediaQuery.of(Get.context!).size;

  /*........ Journal Controller ......*/
  AnimationController? controller;
  Animation<double>? textAnim;
  RxBool disposed = false.obs;
  double fontSizeForTitle = 45;
  Animation<double>? textSlideAnim;
  TextEditingController? headingController = TextEditingController();
  TextEditingController? bodyController = TextEditingController();

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

  //Method for Client to add journal
  addJournal(String? messageHeader, String? messageBody, String moodSvgUrl)async{
    ProgressDialogHelper().showProgressDialog(Get.context!, "Adding Journal...");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.get('accessToken');

    String url = baseUrl + clientAddJournal;
    Map<String, String> header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization" : "Bearer $token"
    };
    var body = {
      "heading": messageHeader,
      "body": messageBody,
      "moodSvgUrl": moodSvgUrl,
    };

    final response = await post(Uri.parse(url), headers: header, body: json.encode(body));
    final result = json.decode(response.body);
    if(result["note"] != null){
      ProgressDialogHelper().hideProgressDialog(Get.context!);
      Get.toNamed(Routes.JOURNAL_HISTORY);
      FlushBarHelper(Get.context!).showFlushBar("Successful!", color: Colors.green);
    }else{
      ProgressDialogHelper().hideProgressDialog(Get.context!);
      FlushBarHelper(Get.context!).showFlushBar("The body must not be greater than 255 characters.", color: Colors.red);
      throw Exception("Unable to add note");
    }
  }

}

