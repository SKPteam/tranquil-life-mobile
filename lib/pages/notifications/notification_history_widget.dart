// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_print, unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:get_storage/get_storage.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';
import 'package:tranquil_life/models/notification_history_model.dart';

class NotificationHistoryItem extends StatelessWidget {
  NotificationHistoryItem(
      {Key? key,
        this.notificationModel,
        this.loader = false,
        required this.index,
        this.deleteNotification})
      : super(key: key);
  final NotificationModel? notificationModel;
  final bool loader;
  final GetStorage prefs = GetStorage();
  final int index;
  final Function(int)? deleteNotification;
  @override
  Widget build(BuildContext context) {
    if (loader) {
      return  SizedBox(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      //initializing the x-axis position of the notification container
      //for delete- drag animation
      ValueNotifier<double> dxPosition = ValueNotifier(0);

      //initial x-axis position when dragging starts
      double initialdxPosition = 0;
      //opened bool value to see whether the drag is opened or not
      bool opened = false;
      //co-ordinates where the username is to be replaced
      List<int> coordinatesOfUsername =
      _getcordinatesOfUsername(msg: notificationModel?.msg ?? '');
      return Column(
        children: [
          GestureDetector(
            onHorizontalDragStart: (details) {
              // SETTING THE INITIAL X-AXIS POSITION WHEN DRAG STARTS
              initialdxPosition = details.localPosition.dx;
            },
            onHorizontalDragUpdate: (details) {
              //CHECKING IF THE CHANGING VALUE OF X-AXIS IS GREATER THAN -120 (as it is been dragged to left side)
              //and initial dx positions is greater than current dx position (to know that it's dragged to left)
              if (dxPosition.value < 120 &&
                  details.localPosition.dx < initialdxPosition) {
                print('still dragging');
                opened = false;
                //setting the difference between current and initial x-axis position during drag
                dxPosition.value = initialdxPosition - details.localPosition.dx;
              } else if (details.localPosition.dx < initialdxPosition) {
                //if the difference exceeds 120 then define it to 120 as maximum displacement
                //- because dragged to left
                print('drag threshold reached');
                opened = true;
                dxPosition.value = 120;
              } else if (opened) {
                //if opened i.e dragged out then close it on horizontal right drag even a little
                opened = false;
                dxPosition.value = 0;
              }
            },
            onHorizontalDragCancel: () {
              //on cancel set the displacement to original position
              opened = false;
              dxPosition.value = 0;
            },
            onDoubleTap: () {
              //opening the dissmissible Container directly to 120 px from right on double tap
              opened = true;
              dxPosition.value = 120;
            },
            onLongPress: () {
              //opening the dissmissible Container directly to 120 px from right on long press
              opened = true;
              dxPosition.value = 120;
            },
            onHorizontalDragEnd: (details) {
              //checking if the difference is less than 120
              //to make sure that minimum 120 displacement is required
              //to keep the container dragged
              if (dxPosition.value < 120) {
                opened = false;
                //if not then set to initial position
                dxPosition.value = 0;
              }
            },
            child: SizedBox(
              width: displayWidth(context) * 0.8,
              height: 140,
              //------------------------
              // STACK FOR HOLDING BADGE AND NOTIFICATION CONTAINER
              //------------------------
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  //------------------------
                  // BACKGROUND BUTTON BEHIND THE DRAGGABLE NOTIFICATION
                  //------------------------
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        deleteNotification?.call(index);
                      },
                      child: Container(
                        margin:  EdgeInsets.only(right: 20),
                        height: 60,
                        width: 60,
                        padding:  EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.blue[600],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/material-delete.svg',
                          color: Colors.white,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: dxPosition,
                    builder: (context, double value, child) =>
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.ease,
                          right: value,
                          child: Container(
                            padding:  EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            width: displayWidth(context) * 0.8,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),

                            //------------------------
                            // ROW CONTAINING THE PROFILE PIC AND NOTIFICATION
                            //------------------------
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //------------------------
                                // PROFILE PIC
                                //------------------------
                                CircleAvatar(
                                  backgroundColor: Colors.grey[400],
                                  radius: 28,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        notificationModel?.imageUrl ??
                                            prefs.read(userAvatarUrl)),
                                    radius: 26,
                                  ),
                                ),
                                 SizedBox(
                                  width: 16,
                                ),
                                //------------------------
                                // COLUMN CONTAINING THE TEXTS OF NOTIFICATION
                                //------------------------
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                     Spacer(
                                      flex: 1,
                                    ),
                                    //------------------------
                                    // TIMEAGO OF THE NOTIFICATION
                                    //------------------------
                                    Text(
                                      "timeago.format(notificationModel?.timeAgo ??",
                                         // DateTime.now())",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                     SizedBox(
                                      height: 5,
                                    ),
                                    //------------------------
                                    // NOTIFICATION TEXT
                                    //------------------------
                                    Container(
                                      width: displayWidth(context) * 0.53,
                                      child: coordinatesOfUsername.isEmpty
                                          ? Text(
                                        notificationModel?.msg ?? '',
                                        style:  TextStyle(
                                          fontSize: 14,
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                          : RichText(
                                        softWrap: true,
                                        text: TextSpan(
                                          children: [
                                            //------------------------
                                            // STARTING TEXT BEFORE USERNAME
                                            //------------------------
                                            TextSpan(
                                              text: notificationModel?.msg ??
                                                  ''.substring(
                                                      0,
                                                      coordinatesOfUsername
                                                          .first),
                                              style:  TextStyle(
                                                fontSize: 14,
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            //------------------------
                                            // USERNAME [bold]
                                            //------------------------
                                            TextSpan(
                                              text: notificationModel
                                                  ?.userName ??
                                                  '',
                                              style:  TextStyle(
                                                fontSize: 14,
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            //------------------------
                                            // ENDING TEXT AFTER USERNAME
                                            //------------------------
                                            TextSpan(
                                              text: notificationModel?.msg
                                                  .substring(
                                                  coordinatesOfUsername
                                                      .last),
                                              style:  TextStyle(
                                                fontSize: 14,
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                     Spacer(
                                      flex: 2,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                  ),
                  //------------------------
                  // TYPE OF NOTIFICATION BADGE
                  //------------------------
                  ValueListenableBuilder(
                    valueListenable: dxPosition,
                    builder: (context, double value, child) =>
                        AnimatedPositioned(
                          curve: Curves.ease,
                          duration:  Duration(milliseconds: 220),
                          //adding 15 to value so that the position is a little onto the right side
                          right: value + 15,
                          //getting out of the container by 15 px
                          top: -15,
                          // offset: Offset(value - 10, -24),
                          child: Container(
                              height: 40,
                              width: 40,
                              padding:  EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child:
                              SvgPicture.asset(
                                'assets/icons/schedule.svg',
                                color: Colors.white,
                                fit: BoxFit.contain,
                              )
                          ),
                        ),
                  )
                ],
              ),
            ),
          ),
           SizedBox(
            height: 40,
          )
        ],
      );
    }
  }

  ///get svg asset url from the type of the Notification
  // String _getSvgForType(NotificationType type) {
  //   switch (type) {
  //     case NotificationType.time:
  //       return 'assets/icons/schedule.svg';
  //     case NotificationType.chat:
  //       return 'assets/icons/chat-bubble.svg';
  //     case NotificationType.transaction:
  //       return 'assets/icons/icon-credit-card.svg';
  //     default:
  //       return 'assets/icons/people.svg';
  //   }
  // }

  ///getting index in the string where 'username' exists to replace it
  ///with the username given for text bold reasons
  List<int> _getcordinatesOfUsername({String msg = ''}) {
    if (msg.contains('username')) {
      int start = msg.indexOf('username');
      return [start, start + 8];
    } else {
      return [];
    }
  }
}