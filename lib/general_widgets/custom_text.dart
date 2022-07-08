import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final double? size;
  final Color? color;
  final FontWeight? weight;
  final TextAlign? align;

  const CustomText({
    this.text,
    this.size,
    this.color,
    this.weight,
    this.align,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      textAlign: align!,
      style: TextStyle(
        color: color!,
        fontSize: size!,
        fontWeight: weight!,
      ),
    );
  }
}
