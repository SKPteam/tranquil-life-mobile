// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';


class NotificationBadge extends StatelessWidget {
  NotificationBadge({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Positioned(
      right: size.width * 0.02,
      top: size.height * 0.004,
      child: GestureDetector(
        onTap: (){
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => NotificationHistoryScreen())
          // );
        },
        child: Container(
          margin: EdgeInsets.only(right: size.width * 0.075),
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.red,
          ),
          constraints: const BoxConstraints(
            minWidth: 16,
            minHeight: 16,
          ),
          child: Text(
            '0',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}