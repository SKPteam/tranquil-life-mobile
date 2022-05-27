// ignore_for_file: avoid_unnecessary_containers, prefer__ructors, prefer__literals_to_create_immutables, prefer__ructors, prefer__literals_to_create_immutables, avoid_print, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/dashboard_controller.dart';
import 'package:tranquil_life/controllers/home_controller.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/main.dart';
import 'package:tranquil_life/pages/home/widgets/meetings_section.dart';
import 'package:tranquil_life/pages/notifications/notification_history_view.dart';
import 'package:tranquil_life/pages/questionnaire/questionnaire_page.dart';
import 'package:tranquil_life/pages/scheduling/widgets/schedule_meeting_dialog.dart';
import 'package:tranquil_life/widgets/custom_text.dart';
import 'package:tranquil_life/widgets/top_nav.dart';

import 'widgets/moods_section.dart';
import 'widgets/notificationBadge.dart';

class Home extends StatefulWidget {
  final void Function(int index, [String? moodSvgUrl]) moodOnTap;

  Home({Key? key, required this.moodOnTap}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  final DashboardController _dashboardController = Get.put(DashboardController());
  final HomeController? _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      responsiveBuilder: (context, size){
        return Scaffold(
            key: scaffoldKey,
            appBar: topNavigationBar(context, scaffoldKey),
            backgroundColor: kLightBackgroundColor,
            body: Stack(
              children: [
                Container(
                  height: size.height * .35,
                  decoration: BoxDecoration(
                    color: kLightBackgroundColor,
                    gradient: LinearGradient(
                        colors: [Color(0xffC9D8CD), kLightBackgroundColor],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter),
                  ),
                ),

                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                      left: size.width * 0.1,
                      top: size.width * 0.1),
                  child: Stack(
                    children: [
                      SizedBox(
                          width: size.width * 0.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi,',
                                style: TextStyle(
                                  color: kPrimaryDarkColor,
                                  fontSize: 26,
                                  fontWeight: FontWeight.normal,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),

                              CustomText(
                                text: sharedPreferences!.getString("display_name").toString().isEmpty
                                    ? ""
                                    : sharedPreferences!.getString("display_name").toString(),
                                color: kPrimaryDarkColor,
                                weight: FontWeight.w700,
                                align: TextAlign.start,
                                size: 26,
                              )


                            ],
                          )),
                      Positioned(
                        right: size.width * 0.1,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: size.width * 0.01),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  var result = await Get.to<bool>(
                                        () => QuestionnaireView(),
                                  );
                                  if (result ?? false) {
                                    print("Get meetings list");
                                    // Get.find<
                                    //     MyScheduledMeetingsTabController>()
                                    //     .getDataFromFirebase();
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: size.width * 0.2),
                                  decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius:
                                    BorderRadius.circular(10.0),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 10,
                                        spreadRadius: 0,
                                        offset: Offset(3, 6),
                                      ),
                                    ],
                                  ),
                                  child: sharedPreferences!.getString(userType) == client
                                  ? SizedBox(
                                      width: 46,
                                      height: 46,
                                      child: Icon(
                                        Icons.people,
                                        size: 28,
                                        color: kPrimaryColor,
                                      ))
                                  : SizedBox(),
                                ),
                              ),
                              SizedBox(width: size.width*0.02),
                              Container(
                                margin: EdgeInsets.only(
                                    left: size.width * 0.02),
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius:
                                  BorderRadius.circular(10.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 10,
                                      spreadRadius: 0,
                                      offset: Offset(3, 6),
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, NotificationHistoryScreen.idScreen);
                                  },
                                  child: SizedBox(
                                    width: 46,
                                    height: 46,
                                    child: Icon(
                                      Icons.notifications,
                                      color: kPrimaryColor,
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      NotificationBadge(),
                    ],
                  ),
                ),

                ///meetings and moods section for client
                ///meetings and work hours setting
                Positioned(
                    top: size.height * 0.12,
                    left: 0,
                    width: size.width,
                    child: SizedBox(
                      height: size.height -
                          size.height * 0.12,
                      child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MyMeetingsSection(),
                              SizedBox(
                                height: 30,
                              ),
                              sharedPreferences!.getString(userType) == client
                                  ? SelectMood(
                                  moodOnTap: (int index, [moodSvgUrl]) {
                                    _dashboardController.setBottomBarIndex(index, moodSvgUrl!);
                                  })
                                  : Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: SizedBox(
                                    width: size.width * 0.9,
                                    height: 60,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            context: context, builder: (context){
                                          return ScheduleMeetingDialog();
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          SizedBox(width: size.width*0.06),

                                          SvgPicture.asset(
                                            'assets/icons/schedule.svg',
                                            color: Colors.white,
                                            width: 28,
                                            height: 28,
                                            fit: BoxFit.none,
                                          ),

                                          SizedBox(width: size.width*0.06),

                                          Text(
                                            'Set your consultation hours',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),

                                          SizedBox(width: size.width*0.06),

                                        ],
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(
                                            size.width * 0.02,
                                            size.height * 0.02,
                                            size.width * 0.03,
                                            size.height * 0.02,
                                          ),
                                          shadowColor: Colors.green,
                                          elevation: 6.0,
                                          primary: kPrimaryColor),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.width > 520 ? size.height * 0.12 : size.height * 0.2,
                              )
                            ],
                          )),
                    ))


              ],
            )
        );
      },
    );
  }
}

