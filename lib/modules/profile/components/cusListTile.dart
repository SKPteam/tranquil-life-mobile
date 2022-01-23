// ignore_for_file: file_names, unnecessary_null_comparison, prefer_if_null_operators

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tranquil_app/app/utils/constants.dart';

class CusListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function() onTap;
  const CusListTile({
    required this.icon,
    required this.title,
    required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap != null ? onTap : () {},
      child: Container(
        height: 90,
        width: double.infinity,
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: kPrimaryDarkColor,
              size: 20,
            ),
            // SvgPicture.asset(
            //   svg,
            //   color: kPrimaryDarkColor,
            //   fit: BoxFit.none,
            //   height: 20,
            //   width: 20,
            // ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 14, color: kPrimaryDarkColor),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_right,
              color: kPrimaryDarkColor,
              size: 30,
            )
          ],
        ),
      ),
    );
  }
}
