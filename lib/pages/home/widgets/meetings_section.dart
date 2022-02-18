// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/widgets/custom_text.dart';

class MyMeetingsSection extends StatelessWidget {

  MyMeetingsSection({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(Get.context!).size;

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Padding(
        padding: EdgeInsets.only(
          top: width * 0.095,
          left: width * 0.04,
          right: width * 0.04,
        ),
        child: Container(
          height: height * 0.42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                blurRadius: 10.0,
                spreadRadius: 3.0,
                offset: Offset(10.0, 10.0),
                color: Colors.grey,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: width * 0.04,
                  vertical: height * 0.038,
                ),
                child: Stack(
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: CustomText(
                          text: 'My scheduled meetings',

                          color: dark,
                          size: 18,
                          weight: FontWeight.w700,
                          align: TextAlign.start,
                        )
                    ),

                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin:
                        EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                            color: active,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5),
                          child: CustomText(
                              text: "0",
                              color: light,
                              align: TextAlign.center,
                              weight: FontWeight.w700,
                              size: 18
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    //_.onReady();
                  },
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  // Widget buildAppointmentCard(BuildContext context, int index) {
  //   final appointment = _.scheduledMeetings.value[index];
  //   // final timeFormat = DateFormat.Hm();
  //   // final dateFormat = DateFormat('dd-MM-yyyy');
  //   return GestureDetector(
  //     onTap: () {
  //       // Get.to(
  //       //   ChatScreenPage(
  //       //     scheduledMeetingID: appointment.id,
  //       //     meeting: appointment,
  //       //     clientUid: appointment.creatorID,
  //       //     consultantUid: appointment.consultantID,
  //       //   ),
  //       // );
  //       // Navigator.pushNamed(context, Routes.CHAT_ROOM,
  //       //     arguments: {appointment.id, appointment});
  //     },
  //     onDoubleTap: () {
  //       // dashboardController.userType!.value == client
  //       //     ? _meetingOptionsDialog(_.scheduledMeetings.value[index])
  //       //     : null;
  //     },
  //     child: Container(
  //       margin: const EdgeInsets.only(left: 8, bottom: 8, right: 8),
  //       child: Card(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12.0),
  //         ),
  //         color: lightBgColor,
  //         child: Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Stack(
  //             children: [
  //               Container(
  //                 width: 54.0,
  //                 height: 54.0,
  //                 margin: const EdgeInsets.only(right: 10),
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(35.0),
  //                   border:
  //                   Border.all(width: 2, color: const Color(0xffC9D8CD)),
  //                   image: DecorationImage(
  //                     image: NetworkImage(appointment.avatarUrl),
  //                     fit: BoxFit.cover,
  //                   ),
  //                 ),
  //               ),
  //               Positioned(
  //                 left: 74,
  //                 child: Container(
  //                   margin: const EdgeInsets.only(top: 2.4),
  //                   height: 50,
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       CustomText(
  //                           text: appointment.consultantName,
  //                           color: primaryColor,
  //                           textAlign: TextAlign.start,
  //                           fontWeight: FontWeight.w700,
  //
  //                           fontSize: 14
  //                       ),
  //                       CustomText(
  //                           text: appointment.duration,
  //                           textAlign: TextAlign.start,
  //                           color: Color(0xff4E4E4E),
  //                           fontWeight: FontWeight.w700,
  //
  //                           fontSize: 14
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               Positioned(
  //                 right: 8,
  //                 child: Container(
  //                   height: 50,
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.end,
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       CustomText(
  //                           text: "timeFormat.format(appointment.startingTime)",
  //                           color: primaryColor,
  //                           textAlign: TextAlign.start,
  //                           fontWeight: FontWeight.w700,
  //
  //                           fontSize: 14
  //                       ),
  //                       CustomText(
  //                           text: "dateFormat.format(appointment.startingTime)",
  //                           color: Color(0xff4E4E4E),
  //                           textAlign: TextAlign.start,
  //                           fontWeight: FontWeight.w700,
  //
  //                           fontSize: 14
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Future<void> _meetingOptionsDialog() async {
    return showDialog<void>(
      context: Get.context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  onTap: () async
                  {
                    // if (_model.startingTime.millisecondsSinceEpoch >
                    //     DateTime.now()
                    //         .add(const Duration(hours: 24))
                    //         .millisecondsSinceEpoch) {
                    //   late ConsultantProfileModel consultantProfileModel;

                    ///Consultant consultantModel;
                    // await accountSettingsRef!
                    //     .child(_model.consultantID)
                    //     .once()
                    //     .then((snapshot) {
                    //   var value = snapshot.value;
                    //   consultantModel = Consultant(
                    //     uid: value[userUID].toString(),
                    //     firstName: value[userFirstName],
                    //     lastName: value[userLastName],
                    //     avatarUrl: value[userAvatarUrl],
                    //     location: value[userCountry],
                    //     onlineStatus: value[userOnlineStatus],
                    //   );
                    //   var values = value['profile'];
                    //   consultantProfileModel = ConsultantProfileModel(
                    //     uid: _model.consultantID,
                    //     areaOfExpertise: values['areaOfExpertise'] ?? '',
                    //     avatarUrl: consultantModel.avatarUrl,
                    //     firstName: consultantModel.firstName,
                    //     lastName: consultantModel.lastName,
                    //     description: values['description'] ?? '',
                    //     fee: values['fee'] ?? 0,
                    //     preferredLangs: values['preferredLangs'] ?? '',
                    //     location: consultantModel.location,
                    //     yearsOfExperience: values['yearsOfExperience'] ?? '',
                    //     email: '',
                    //     timeZone: '',
                    //     phoneNum: '',
                    //   );
                    // });

                    ///list of schedules containing schedule model for creating container templates
                    ///of weekDay and date
                    ///dates from tom to next 7 days generated from DateTime
                    // final List<Schedule> schedules = List.generate(
                    //   7,
                    //       (index) => Schedule(
                    //     DateTime.now().add(
                    //       Duration(days: index + 1),
                    //     ),
                    //   ),
                    // );
                    //
                    // //show modal sheet for Date Selecting
                    // bool? result = await showModalBottomSheet<bool?>(
                    //   isDismissible: true,
                    //   shape: const RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.vertical(
                    //           top: Radius.circular(40))),
                    //   context: context,
                    //   builder: (context) => ScheduleMeetingDialog(
                    //     schedules: schedules,
                    //     consultantProfileModel: consultantProfileModel,
                    //     isUserClient: true,
                    //     reSchedule: true,
                    //     reScheduleMeetingID: _model.id,
                    //   ),
                    // ).then((value) {
                    //   return value;
                    // });
                    //
                    // if (result ?? false) {
                    //   Navigator.of(context).pop();
                    // }
                    //} else {
                    //if the startTime is not greater than 24 hrs from now
                    ///Reschedule
                    //_showRescheduleDialog(_model.id);
                  },
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  horizontalTitleGap: 0,
                  title: CustomText(
                      text: 'Reschedule',
                      align: TextAlign.start,
                      color: active,
                      weight: FontWeight.w700,
                      size: 14
                  ),
                ),
                ListTile(
                  onTap: () async {
                    //Delete
                    // scheduledMeetingsRef!.doc(_model.id).delete();
                    Navigator.of(context).pop();
                  },
                  horizontalTitleGap: 0,
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: CustomText(
                      text: 'Delete',
                      align: TextAlign.start,
                      color: active,
                      weight: FontWeight.w700,
                      size: 14
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showRescheduleDialog(String _modelID) async {
    return showDialog<void>(
      context: Get.context!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                CustomText(
                    text: 'You can only schedule a meeting 24hours or more '
                        'before the initially specified date of the meeting',
                    align: TextAlign.start,
                    color: dark,
                    weight: FontWeight.normal,
                    size: 16
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: CustomText(
                  text: "Yes",
                  align: TextAlign.start,
                  color: dark,
                  weight: FontWeight.normal,
                  size: 14
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}