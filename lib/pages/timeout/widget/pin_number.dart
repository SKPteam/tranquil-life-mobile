// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PINNumber extends StatelessWidget{

  Size size = MediaQuery.of(Get.context!).size;


  final TextEditingController textEditingController;
  final OutlineInputBorder outlineInputBorder;

   PINNumber({Key? key,
    required this.textEditingController,
    required this.outlineInputBorder
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width*0.12,
      child: TextField(
        controller: textEditingController,
        enabled: false,
        obscureText: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(size.width*0.04),
            border: outlineInputBorder,
            filled: true,
            fillColor: Colors.white30
        ),
        style:  TextStyle(
            fontSize: 21.0,
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
      ),
    );
  }

}