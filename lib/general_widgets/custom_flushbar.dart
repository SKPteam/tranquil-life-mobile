
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FlushBarHelper{
  BuildContext? c;
  Flushbar? flush;
  FlushBarHelper(this.c);

  showFlushBar(String message, {Color? color}){
    flush = Flushbar(
      message:  message, padding: EdgeInsets.symmetric(horizontal: 20, vertical: 17),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: color ?? Colors.blueGrey,
      margin: EdgeInsets.all(15),
      borderRadius: BorderRadius.circular(5),
      isDismissible: true,
      duration: Duration(seconds: 3),
    )..show(c ?? Get.context!);
  }

  showFlushBarWithAction(String message, String action, {Color? color, Function? actionFunction}){
    flush = Flushbar(
      message:  message, padding: EdgeInsets.symmetric(horizontal: 20, vertical: 17),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: color ?? Colors.blueGrey,
      margin: EdgeInsets.all(15),
      borderRadius: BorderRadius.circular(5),
      isDismissible: true,
      duration: Duration(seconds: 10),
      mainButton: TextButton(
        onPressed: () {
          actionFunction?.call();
          flush?.dismiss(true);
        },
        child: Text(action, style: TextStyle(color: Colors.amber),
        ),
      ),
    )..show(c ?? Get.context!);
  }
}