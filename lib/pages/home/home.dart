// ignore_for_file: avoid_unnecessary_containers, prefer__ructors, prefer__literals_to_create_immutables, prefer__ructors, prefer__literals_to_create_immutables, avoid_print, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/dashboard_controller.dart';
import 'package:tranquil_life/controllers/onboarding_controller.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';
import 'package:tranquil_life/models/consultant_profile_model.dart';
import 'package:tranquil_life/models/schedule_date_model.dart';
import 'package:tranquil_life/pages/home/widgets/meetings_section.dart';
import 'package:tranquil_life/pages/notifications/notification_history_view.dart';
import 'package:tranquil_life/pages/onboarding/onboarding_two.dart';
import 'package:tranquil_life/pages/scheduling/consultant_list_view.dart';
import 'package:tranquil_life/pages/scheduling/scheduling_time/widgets/schedule_meeting_dialog.dart';
import 'package:tranquil_life/routes/app_pages.dart';
import 'package:tranquil_life/widgets/custom_text.dart';
import 'package:tranquil_life/widgets/top_nav.dart';

import 'widgets/moods_section.dart';
import 'widgets/notificationBadge.dart';

class Home extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  bool? toggleValue = false;

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(responsiveBuilder: (context, size) {
      return Scaffold(
          key: scaffoldKey,
          backgroundColor: light,
          appBar: topNavigationBar(context, scaffoldKey),
          body: Get.find<OnBoardingController>().userType.value == client
              ? Stack(children: [
                  Container(
                    height: size.height * .35,
                    decoration: BoxDecoration(
                      color: lightBgColor,
                      gradient: LinearGradient(
                          colors: [Color(0xffC9D8CD), lightBgColor],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        left: size.width * 0.1, top: size.width * 0.1),
                    child: Stack(
                      children: [
                        SizedBox(
                            width: size.width * 0.6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hi,',
                                  style: TextStyle(
                                    color: active,
                                    fontSize: 28,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                CustomText(
                                  text: "Joseph",
                                  color: active,
                                  weight: FontWeight.w700,
                                  size: 28,
                                  align: TextAlign.start,
                                ),
                              ],
                            )),
                        Positioned(
                            right: size.width * 0.1,
                            child: Padding(
                              padding: EdgeInsets.only(top: size.width * 0.01),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      //Get.toNamed(Routes.CONSULTANT_LIST);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ConsultantListView()));

                                      print("Consutlant list");
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: size.width * 0.2),
                                      decoration: BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 10,
                                            spreadRadius: 0,
                                            offset: Offset(3, 6),
                                          ),
                                        ],
                                      ),
                                      child: SizedBox(
                                          width: 46,
                                          height: 46,
                                          child: Icon(
                                            Icons.people,
                                            size: 28,
                                            color: active,
                                          )),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: displayWidth(context) * 0.02),
                                    decoration: BoxDecoration(
                                      color: Colors.white70,
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [
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
                                        //Navigator.pushNamed(context, NotificationHistoryScreen.idScreen);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NotificationHistoryScreen()));
                                      },
                                      child: SizedBox(
                                        width: displayWidth(context) * 0.10,
                                        height: displayWidth(context) * 0.10,
                                        child: Icon(
                                          Icons.notifications,
                                          color: kPrimaryColor,
                                          size: displayWidth(context) * 0.06,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        NotificationBadge(),
                      ],
                    ),
                  ),
                  Container(
                    height: displayHeight(context),
                  ),
                  Positioned(
                      top: size.height * 0.1,
                      left: 0,
                      width: displayWidth(context),
                      child: SizedBox(
                        height: displayHeight(context) -
                            displayHeight(context) * 0.12,
                        child: SingleChildScrollView(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MyMeetingsSection(),
                            SizedBox(
                              height: 30,
                            ),
                            SelectMood(
                              moodOnTap: (int index, [moodSvgUrl]) {
                                DashboardController.to
                                    .setBottomBarIndex(index, moodSvgUrl!);
                              },
                            ),
                            SizedBox(
                              height: 100,
                            )
                          ],
                        )),
                      ))
                ])
              : Stack(
                  children: [
                    Container(
                      height: displayHeight(context) * .35,
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
                            left: displayWidth(context) * 0.1,
                            top: displayWidth(context) * 0.1),
                        child: Stack(
                          children: [
                            SizedBox(
                                width: displayWidth(context) * 0.4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hi,',
                                      style: TextStyle(
                                        color: kPrimaryDarkColor,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      "First name ",
                                      // !DashboardController
                                      //     .to.firstName!.value.isNull
                                      //     ? DashboardController
                                      //     .to.firstName!.value
                                      //     .toString()
                                      //     : '',
                                      style: TextStyle(
                                          color: kPrimaryDarkColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )),
                            Positioned(
                              right: displayWidth(context) * 0.1,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      top: displayWidth(context) * 0.01),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: displayWidth(context) * 0.02),
                                        decoration: BoxDecoration(
                                          color: Colors.white70,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          boxShadow: [
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
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  NotificationHistoryScreen(),
                                            ));
                                          },
                                          child: SizedBox(
                                            width: displayWidth(context) * 0.10,
                                            height:
                                                displayWidth(context) * 0.10,
                                            child: SvgPicture.asset(
                                              'assets/icons/notification.svg',
                                              color: kPrimaryColor,
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            NotificationBadge(),
                          ],
                        )),
                    Positioned(
                      top: displayHeight(context) * 0.12,
                      left: 0,
                      width: displayWidth(context),
                      child: SizedBox(
                        width: size.width * 0.12,
                        height: displayHeight(context) -
                            displayHeight(context) * 0.12,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MyMeetingsSection(),
                              SizedBox(height: displayHeight(context) * .04),
                              Center(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: SizedBox(
                                        height: displayHeight(context) * 0.077,
                                        width: displayWidth(context) * 0.94,
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              ConsultantProfileModel?
                                                  consultantProfileModel;

                                              ///list of schedules containing schedule model for creating container templates
                                              ///of weekDay and date
                                              ///dates from tom to next 7 days generated from DateTime
                                              final List<Schedule> schedules =
                                                  List.generate(
                                                7,
                                                (index) => Schedule(
                                                  DateTime.now().add(
                                                    Duration(days: index + 1),
                                                  ),
                                                ),
                                              );

                                              //show modal sheet for Date Selecting
                                              showModalBottomSheet<void>(
                                                isDismissible: true,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    40))),
                                                context: context,
                                                builder: (context) =>
                                                    ScheduleMeetingDialog(
                                                  schedules: schedules,
                                                  consultantProfileModel:
                                                      consultantProfileModel!,
                                                  isUserClient: false,
                                                  key: null,
                                                  reScheduleMeetingID: '',
                                                ),
                                              );
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/icons/schedule.svg',
                                                  color: Colors.white,
                                                  width: displayWidth(context) *
                                                      0.1,
                                                  height:
                                                      displayWidth(context) *
                                                          0.1,
                                                  fit: BoxFit.none,
                                                ),
                                                Text(
                                                  'Set your convenient consultation hours',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                )
                                              ],
                                            )),
                                      )))
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ));
    });
  }
}
