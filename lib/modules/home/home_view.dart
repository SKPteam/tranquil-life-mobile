// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tranquil_app/app/getx_controllers/dashboard_controller.dart';
import 'package:tranquil_app/app/getx_controllers/home_controller.dart';
import 'package:tranquil_app/app/getx_controllers/myScheduledMeetingsTabController.dart';
import 'package:tranquil_app/app/models/consultant_profile_model.dart';
import 'package:tranquil_app/app/models/schedule_date_model.dart';
import 'package:tranquil_app/app/modules/consultantList/scheduling/components/scheduleMeetingDialog.dart';
import 'package:tranquil_app/app/modules/consultationQuestionnaire/consultation_questionnaire_view.dart';
import 'package:tranquil_app/app/modules/notification_history/notification_history_view.dart';
import 'package:tranquil_app/app/utils/constants.dart';
import 'package:tranquil_app/app/utils/sizes_helpers.dart';

import '../../../main.dart';
import 'components/my_scheduled_meetings_tab.dart';
import 'components/notificationBadge.dart';
import 'components/selectMoodTab.dart';

class HomeView extends GetView<HomeController> {
  final void Function(int index, [String? moodSvgUrl]) moodOnTap;

  HomeView({Key? key, required this.moodOnTap}) : super(key: key);

  final HomeController _ = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: kPrimaryDarkColor),
          elevation: 0,
          actions: [
            // here is the container containing the switcher
            Center(
              child: InkWell(
                onTap: () {
                  _.anonymous.value = !_.anonymous.value;
                  isAnonymousInTheApp = _.anonymous.value;
                  print('switched');
                },
                child: ValueListenableBuilder(
                  valueListenable: _.anonymous,
                  builder: (context, value, child) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(displayWidth(context) * 0.04),
                        color: Colors.grey[500],
                      ),
                      width: displayWidth(context) * 0.064,
                      height: displayHeight(context) * 0.018,
                      alignment: value != null
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: displayWidth(context) * 0.036,
                        height: displayWidth(context) * 0.036,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            end: Alignment.bottomLeft,
                            begin: Alignment.topRight,
                            colors: value != null
                                ? [
                                    const Color(0xFF64B5F6),
                                    const Color(0xff1976d2)
                                  ]
                                : [
                                    const Color(0xffE57373),
                                    const Color(0xffD32F2F)
                                  ],
                          ),
                        ),
                      )),
                ),
              ),
            ),
            SizedBox(width: displayWidth(context) * 0.015),
            PopupMenuButton<String>(
                onSelected: _.optionAction,
                iconSize: displayWidth(context) * 0.06,
                itemBuilder: (BuildContext context) {
                  return _.menuOptions!.map((String option) {
                    return PopupMenuItem(value: option, child: Text(option));
                  }).toList();
                }),
            SizedBox(width: displayWidth(context) * 0.02)
          ],
        ),
        backgroundColor: kLightBackgroundColor,
        body: SafeArea(
          child: Get.find<DashboardController>().userType!.value == "client"
              ? Stack(
                  children: [
                    Container(
                      height: displayHeight(context) * .35,
                      decoration: const BoxDecoration(
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
                                        fontSize: displayWidth(context) * 0.06,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Obx(
                                      () => Text(
                                        Get.find<DashboardController>()
                                            .username!
                                            .value,
                                        style: TextStyle(
                                            color: kPrimaryDarkColor,
                                            fontSize:
                                                displayWidth(context) * 0.06,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
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
                                            left: displayWidth(context) * 0.2),
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
                                          onTap: () async {
                                            var result = await Get.to<bool>(
                                              () =>
                                                  const ConsultationQuestionnaireView(),
                                            );
                                            if (result ?? false) {
                                              Get.find<
                                                      MyScheduledMeetingsTabController>()
                                                  .getDataFromFirebase();
                                            }
                                          },
                                          child: SizedBox(
                                              width:
                                                  displayWidth(context) * 0.10,
                                              height:
                                                  displayWidth(context) * 0.10,
                                              child: Icon(
                                                Icons.people,
                                                size: displayWidth(context) *
                                                    0.06,
                                                color: kPrimaryColor,
                                              )),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: displayWidth(context) * 0.02),
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
                                            //Navigator.pushNamed(context, NotificationHistoryScreen.idScreen);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const NotificationHistoryScreen()));
                                          },
                                          child: SizedBox(
                                            width: displayWidth(context) * 0.10,
                                            height:
                                                displayWidth(context) * 0.10,
                                            child: Icon(
                                              Icons.notifications,
                                              color: kPrimaryColor,
                                              size:
                                                  displayWidth(context) * 0.06,
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
                    Container(
                      height: displayHeight(context),
                    ),
                    Positioned(
                        top: displayHeight(context) * 0.12,
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
                              MyScheduledMeetings(),
                              const SizedBox(
                                height: 30,
                              ),
                              SelectMood(
                                moodOnTap: (int index, [moodSvgUrl]) {
                                  DashboardController.to
                                      .setBottomBarIndex(index, moodSvgUrl!);
                                },
                              ),
                              const SizedBox(
                                height: 100,
                              )
                            ],
                          )),
                        ))
                  ],
                )
              : Stack(
                  children: [
                    Container(
                      height: displayHeight(context) * .35,
                      decoration: const BoxDecoration(
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
                                        fontSize: displayWidth(context) * 0.06,
                                      ),
                                    ),
                                    Text(
                                      !DashboardController
                                              .to.firstName!.value.isNull
                                          ? DashboardController
                                              .to.firstName!.value
                                              .toString()
                                          : '',
                                      style: TextStyle(
                                          color: kPrimaryDarkColor,
                                          fontSize:
                                              displayWidth(context) * 0.06,
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
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const NotificationHistoryScreen(),
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
                        height: displayHeight(context) -
                            displayHeight(context) * 0.12,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              MyScheduledMeetings(),
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
                                              await accountSettingsRef!
                                                  .child(auth!.currentUser!.uid)
                                                  .once()
                                                  .then((authProfile) async {
                                                print(authProfile.value);
                                                var profileValues = authProfile
                                                    .value['profile'];
                                                print(profileValues);
                                                consultantProfileModel =
                                                    ConsultantProfileModel(
                                                  uid: auth!.currentUser!.uid,
                                                  areaOfExpertise: profileValues[
                                                          'areaOfExpertise'] ??
                                                      '',
                                                  avatarUrl: authProfile
                                                      .value[userAvatarUrl],
                                                  firstName: authProfile
                                                      .value[userFirstName],
                                                  lastName: authProfile
                                                      .value[userLastName],
                                                  description: profileValues[
                                                          'description'] ??
                                                      '',
                                                  fee:
                                                      profileValues['fee'] ?? 0,
                                                  preferredLangs: profileValues[
                                                          'preferredLangs'] ??
                                                      '',
                                                  location: authProfile.value[
                                                          userCurrentLocation] ??
                                                      '',
                                                  yearsOfExperience: profileValues[
                                                          'yearsOfExperience'] ??
                                                      '',
                                                );
                                              });

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
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
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
                                                    fontSize:
                                                        displayWidth(context) /
                                                            28,
                                                  ),
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
                ),
        ));
  }
}
