import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';

class PINNumber extends StatelessWidget{

  final TextEditingController textEditingController;
  final OutlineInputBorder outlineInputBorder;

  const PINNumber({Key? key,
    required this.textEditingController,
    required this.outlineInputBorder
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: displayWidth(context)*0.12,
      child: TextField(
        controller: textEditingController,
        enabled: false,
        obscureText: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(displayWidth(context)*0.04),
            border: outlineInputBorder,
            filled: true,
            fillColor: Colors.white30
        ),
        style: const TextStyle(
            fontSize: 21.0,
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
      ),
    );
  }

}