// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';

class OnBoardingContent extends StatelessWidget {
  const OnBoardingContent({
    Key? key,
    this.text,
    this.image,
  }) : super(key: key);
  final String? text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        Image.asset(
          image!,
          height: 360,
          width: 360,
        ),
        Container(
          margin: EdgeInsets.only(top: 24),
          child: Text(
            text!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18
            ),
          ),
        )
      ],
    );
  }
}