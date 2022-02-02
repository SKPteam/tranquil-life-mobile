import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingTile extends StatelessWidget {
  final String? svgUrl;
  final String? text;
  final Color? color;
  final Function()? onTap;
  const SettingTile(
      {Key? key, this.svgUrl, this.text, this.color = const Color(0xff0E5D24), this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? (){},
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 8,
            ),
            SvgPicture.asset(
              svgUrl!,
              color: color,
              fit: BoxFit.none,
              width: 40,
              height: 40,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              text!,
              style: TextStyle(
                fontSize: 20,
                color: color,
              ),
            )
          ],
        ),
      ),
    );
  }
}