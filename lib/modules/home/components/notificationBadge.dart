// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_app/app/getx_controllers/notificationBadgeController.dart';
import 'package:tranquil_app/app/modules/notification_history/notification_history_view.dart';
import 'package:tranquil_app/app/utils/sizes_helpers.dart';
import 'package:tranquil_app/app/routes/app_pages.dart';


class NotificationBadge extends StatelessWidget {
  final NotificationBadgeController nbc = Get.put(NotificationBadgeController());

  NotificationBadge({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: 0.8,
        top: 0,
        child: GestureDetector(
          onTap: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const NotificationHistoryScreen())
            );
          },
        child: Container(
          margin: EdgeInsets.only(right: displayWidth(Get.context!) * 0.075),
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.red,
          ),
          constraints: const BoxConstraints(
            minWidth: 16,
            minHeight: 16,
          ),
          child: GetX<NotificationBadgeController>(
              builder : (_){
                return Text(
                  '${_.notificationDocsCount.value}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                );
              }

          ) ,
        ))
    );
  }
}
