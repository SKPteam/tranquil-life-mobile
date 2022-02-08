// ignore_for_file: unnecessary_import, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/notification_history_controller.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';
import 'package:tranquil_life/pages/notifications/notification_history_widget.dart';

class NotificationHistoryScreen extends StatelessWidget {
  static  String idScreen = 'notificationsPage';

   NotificationHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = Get.put(NotificationHistoryController());
    return ResponsiveSafeArea(
      responsiveBuilder: (context, size)
      => Scaffold(
      backgroundColor: kLightBackgroundColor,
      body: SizedBox(
        width: displayWidth(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: displayWidth(context) * 0.95,
              padding:  EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //------------------------
                  // BACK BUTTON
                  //------------------------
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon:  Icon(Icons.arrow_back, color: kPrimaryColor),
                  ),
                  SizedBox(
                    width: displayWidth(context) * 0.06,
                  ),
                  //------------------------
                  // SCREEN HEADING
                  //------------------------
                   Text(
                    'Notifications',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: displayHeight(context) * 0.03,
            ),
            //------------------------
            // LIST OF NOTIFICATIONS
            //------------------------
            Expanded(
              child: Obx(()
              {
                return
                  _.dataLoaded.value
                      ? _.notifications.isNotEmpty
                      ? AnimatedList(
                    controller: _.scrollController,
                    key: _.listKey,
                    itemBuilder: (context, index, animation) =>
                    index == _.notifications.length
                        ? _.moreNotificationsAvailableInDatabase
                        ? NotificationHistoryItem(
                        index: index, loader: true)
                        : Container()
                        : NotificationHistoryItem(
                      notificationModel:
                      _.notifications[index],
                      index: index,
                      deleteNotification: (index) {
                        _deleteNotification(index, _);
                      },
                    ),
                    initialItemCount: _.notifications.length + 1,
                    physics:  BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      bottom: 20,
                      top: displayHeight(context) * 0.05,
                    ),
                  )
                      : Container(
                    margin:  EdgeInsets.only(top: 40),
                    child:  Text(
                      'No Notifications',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                      :  Center(
                    child: CircularProgressIndicator(),
                  );
              }),
            ),
          ],
        ),
      ),
    ),) ;
  }

  void _deleteNotification(int index, NotificationHistoryController _) {
    //removing the element in the notification list after a second to avoid the index error
    _.notifications.removeAt(index);
    //removing the element from the animated list using key with size and fade animation
    _.listKey.currentState?.removeItem(
      index,
          (BuildContext context, Animation<double> animation) {
        return FadeTransition(
          opacity:
          CurvedAnimation(parent: animation, curve:  Interval(0.5, 1.0)),
          child: SizeTransition(
            sizeFactor:
            CurvedAnimation(parent: animation, curve:  Interval(0.0, 1.0)),
            axisAlignment: 0.0,
            child: NotificationHistoryItem(
              //checking if index is last [demonotifications.length without -1 becoz
              // the last element is already removed so] and building notifications with - 1
              // if index is last to avoid not in range index
                notificationModel: index == _.notifications.length
                    ? _.notifications[index - 1]
                    : _.notifications[index],
                index: index),
          ),
        );
      },
      duration:  Duration(milliseconds: 600),
    );
    // print(index);

    // Future.delayed(Duration(seconds: 1)).then(
    //   (value) => ,
    // );
  }
}