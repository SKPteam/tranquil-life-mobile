import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_app/app/getx_controllers/dashboard_controller.dart';
import 'package:tranquil_app/app/modules/chatroom/chat_screen.dart';
import 'package:tranquil_app/app/utils/sizes_helpers.dart';

import 'bottomNavBar.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final DashboardController _ = Get.put(DashboardController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
          children: [
            SizedBox(
              height: displayHeight(context),
              width: displayWidth(context),
              child: _.tabs![_.currentIndex.value],
            ),
            Stack(
              children: [
                Positioned(
                    bottom: 0,
                    left: 0,
                    child: SizedBox(
                      width: displayWidth(context),
                      height: 80,
                      child: Stack(
                        children: [
                          CustomPaint(
                            size: Size(displayWidth(context), 80),
                            painter: BNBCustomPainter(),
                          ),
                          Center(
                            heightFactor: 0.6,
                            child: SizedBox(
                              height: displayHeight(context) * 0.1,
                              width: displayWidth(context) * 0.1,
                              child: FloatingActionButton(
                                  backgroundColor: const Color(0xff266C29),
                                  child: Icon(
                                    Icons.chat_bubble,
                                    size: displayWidth(context) * 0.04,
                                  ),
                                  elevation: 0.1,
                                  onPressed: () {
                                    Get.to( const ChatScreenPage(
                                      consultantUid: '',
                                      clientUid: '',));
                                  }),
                            ),
                          ),
                          SizedBox(
                            width: displayWidth(context),
                            height: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                //home
                                IconButton(
                                  icon: Icon(
                                    Icons.home,
                                    size: _.currentIndex.value == 0
                                        ? displayWidth(context) * 0.058
                                        : displayWidth(context) * 0.05,
                                    color: _.currentIndex.value == 0
                                        ? Colors.green
                                        : Colors.grey.shade400,
                                  ),
                                  onPressed: () {
                                    _.setBottomBarIndex(0);
                                  },
                                  splashColor: Colors.white,
                                ),
                                //wallet
                                IconButton(
                                    icon: Icon(
                                      Icons.account_balance_wallet,
                                      size: _.currentIndex.value == 1
                                          ? displayWidth(context) * 0.058
                                          : displayWidth(context) * 0.05,
                                      color: _.currentIndex.value == 1
                                          ? Colors.green
                                          : Colors.grey.shade400,
                                    ),
                                    onPressed: () {
                                      _.setBottomBarIndex(1);
                                    }),
                                SizedBox(width: displayWidth(context) * 0.20),
                                //journal
                                IconButton(
                                    icon: Icon(
                                      Icons.note_add_sharp,
                                      size: _.currentIndex.value == 2
                                          ? displayWidth(context) * 0.058
                                          : displayWidth(context) * 0.05,
                                      color: _.currentIndex.value == 2
                                          ? Colors.green
                                          : Colors.grey.shade400,
                                    ),
                                    onPressed: () {
                                      _.setBottomBarIndex(2);
                                    }),
                                //Profile
                                IconButton(
                                    icon: Icon(
                                      Icons.person,
                                      size: _.currentIndex.value == 3
                                          ? displayWidth(context) * 0.058
                                          : displayWidth(context) * 0.05,
                                      color: _.currentIndex.value == 3
                                          ? Colors.green
                                          : Colors.grey.shade400,
                                    ),
                                    onPressed: () {
                                      _.setBottomBarIndex(3);
                                    }),
                              ],
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            )
          ],
        ));
  }
}
