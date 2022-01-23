// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tranquil_app/app/getx_controllers/dashboard_controller.dart';
import 'package:tranquil_app/app/getx_controllers/myScheduledMeetingsTabController.dart';
import 'package:tranquil_app/app/models/consultant_model.dart';
import 'package:tranquil_app/app/models/consultant_profile_model.dart';
import 'package:tranquil_app/app/models/schedule_date_model.dart';
import 'package:tranquil_app/app/models/scheduled_meeting.dart';
import 'package:tranquil_app/app/modules/chatroom/chat_screen.dart';
import 'package:tranquil_app/app/modules/consultantList/scheduling/components/scheduleMeetingDialog.dart';
import 'package:tranquil_app/app/utils/constants.dart';
import 'package:tranquil_app/app/utils/sizes_helpers.dart';
import 'package:tranquil_app/main.dart';

import '../../../getx_controllers/myScheduledMeetingsTabController.dart';

class MyScheduledMeetings extends StatelessWidget {
  final MyScheduledMeetingsTabController _ =
      Get.put(MyScheduledMeetingsTabController());
  MyScheduledMeetings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
          top: displayWidth(context) * 0.095,
          left: displayWidth(context) * 0.04,
          right: displayWidth(context) * 0.04,
        ),
        child: Container(
          height: displayHeight(context) * 0.42,
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
                  horizontal: displayWidth(context) * 0.04,
                  vertical: displayWidth(context) * 0.038,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'My scheduled meetings',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: displayWidth(context) * 0.048,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin:
                            EdgeInsets.only(left: displayWidth(context) * 0.14),
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: displayWidth(context) * 0.040,
                              vertical: 5),
                          child: Obx(() {
                            return Text(
                              '${_.scheduledMeetings.value.length}',
                              style: TextStyle(
                                  fontSize: displayWidth(context) * 0.042,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            );
                          }),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              GetX<MyScheduledMeetingsTabController>(builder: (_) {
                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      _.onReady();
                    },
                    child: _.dataLoaded.value
                        ? ListView.builder(
                            controller: _.scrollController,
                            scrollDirection: Axis.vertical,
                            itemCount: _.scheduledMeetings.value.length + 1,
                            itemBuilder: (BuildContext context, int index) =>
                                index == _.scheduledMeetings.value.length
                                    ? _.moreScheduledMeetingsAvailableInDatabase
                                        ? const SizedBox(
                                            height: 60,
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          )
                                        : _.scheduledMeetings.value.isNotEmpty
                                            ? Container()
                                            : Container(
                                                height: 100,
                                                child: const Center(
                                                  child: Text(
                                                    'No Scheduled Meetings',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )
                                    : buildAppointmentCard(context, index))
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                );
              }),
            ],
          ),
        ));
  }

  Widget buildAppointmentCard(BuildContext context, int index) {
    final appointment = _.scheduledMeetings.value[index];
    final timeFormat = DateFormat.Hm();
    final dateFormat = DateFormat('dd-MM-yyyy');
    return GestureDetector(
      onTap: () {
        Get.to(
          ChatScreenPage(
            scheduledMeetingID: appointment.id,
            meeting: appointment,
            clientUid: appointment.creatorID,
            consultantUid: appointment.consultantID,
          ),
        );
        // Navigator.pushNamed(context, Routes.CHAT_ROOM,
        //     arguments: {appointment.id, appointment});
      },
      onDoubleTap: () {
        DashboardController.to.userType!.value == client
            ? _meetingOptionsDialog(_.scheduledMeetings.value[index])
            : null;
      },
      child: Container(
        margin: const EdgeInsets.only(left: 8, bottom: 8, right: 8),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          color: kLightBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Container(
                  width: 54.0,
                  height: 54.0,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35.0),
                    border:
                        Border.all(width: 2, color: const Color(0xffC9D8CD)),
                    image: DecorationImage(
                      image: NetworkImage(appointment.avatarUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  left: 74,
                  child: Container(
                    margin: const EdgeInsets.only(top: 2.4),
                    height: 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(appointment.consultantName,
                            style: const TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        Text(appointment.duration,
                            style: const TextStyle(
                                color: Color(0xff4E4E4E),
                                fontWeight: FontWeight.bold,
                                fontSize: 14))
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  child: Container(
                    height: 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          timeFormat.format(appointment.startingTime),
                          style: const TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          dateFormat.format(appointment.startingTime),
                          style: const TextStyle(
                            color: Color(0xff4E4E4E),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _meetingOptionsDialog(ScheduledMeeting _model) async {
    return showDialog<void>(
      context: Get.context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  onTap: () async {
                    if (_model.startingTime.millisecondsSinceEpoch >
                        DateTime.now()
                            .add(const Duration(hours: 24))
                            .millisecondsSinceEpoch) {
                      late ConsultantProfileModel consultantProfileModel;

                      Consultant consultantModel;
                      await accountSettingsRef!
                          .child(_model.consultantID)
                          .once()
                          .then((snapshot) {
                        var value = snapshot.value;
                        consultantModel = Consultant(
                          uid: value[userUID].toString(),
                          firstName: value[userFirstName],
                          lastName: value[userLastName],
                          avatarUrl: value[userAvatarUrl],
                          location: value[userCountry],
                          onlineStatus: value[userOnlineStatus],
                        );
                        var values = value['profile'];
                        consultantProfileModel = ConsultantProfileModel(
                          uid: _model.consultantID,
                          areaOfExpertise: values['areaOfExpertise'] ?? '',
                          avatarUrl: consultantModel.avatarUrl,
                          firstName: consultantModel.firstName,
                          lastName: consultantModel.lastName,
                          description: values['description'] ?? '',
                          fee: values['fee'] ?? 0,
                          preferredLangs: values['preferredLangs'] ?? '',
                          location: consultantModel.location,
                          yearsOfExperience: values['yearsOfExperience'] ?? '',
                          email: '',
                          timeZone: '',
                          phoneNum: '',
                        );
                      });

                      ///list of schedules containing schedule model for creating container templates
                      ///of weekDay and date
                      ///dates from tom to next 7 days generated from DateTime
                      final List<Schedule> schedules = List.generate(
                        7,
                        (index) => Schedule(
                          DateTime.now().add(
                            Duration(days: index + 1),
                          ),
                        ),
                      );

                      //show modal sheet for Date Selecting
                      bool? result = await showModalBottomSheet<bool?>(
                        isDismissible: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(40))),
                        context: context,
                        builder: (context) => ScheduleMeetingDialog(
                          schedules: schedules,
                          consultantProfileModel: consultantProfileModel,
                          isUserClient: true,
                          reSchedule: true,
                          reScheduleMeetingID: _model.id,
                        ),
                      ).then((value) {
                        return value;
                      });

                      if (result ?? false) {
                        Navigator.of(context).pop();
                      }
                    } else {
                      //if the startTime is not greater than 24 hrs from now
                      //Reschedule
                      _showRescheduleDialog(_model.id);
                    }
                  },
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  horizontalTitleGap: 0,
                  title: Text(
                    'Reschedule',
                    style: TextStyle(fontSize: displayWidth(context) * 0.04),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    //Delete
                    scheduledMeetingsRef!.doc(_model.id).delete();
                    Navigator.of(context).pop();
                  },
                  horizontalTitleGap: 0,
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text('Delete',
                      style: TextStyle(fontSize: displayWidth(context) * 0.04)),
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
              children: const <Widget>[
                Text('You can only schedule a meeting 24hours or more '
                    'before the initially specified date of the meeting'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
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
