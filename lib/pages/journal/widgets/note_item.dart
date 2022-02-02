// ignore_for_file: non_constant_identifier_names

import 'dart:ui';

import 'package:flutter/material.dart';

class CustomTextClipper extends CustomClipper<Rect> {
  CustomTextClipper(this.TextSize);

  final Size TextSize;

  @override
  Rect getClip(Size size) {
    return Rect.fromPoints(
        Offset.zero, Offset(TextSize.width, TextSize.height));
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}