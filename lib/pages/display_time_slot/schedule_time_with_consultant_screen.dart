// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:tranquil_app/app/getx_controllers/dashboard_controller.dart';
import 'package:tranquil_app/app/getx_controllers/myScheduledMeetingsTabController.dart';
import 'package:tranquil_app/app/getx_controllers/wallet_controller.dart';
import 'package:tranquil_app/app/helperControllers/timeFunctionsController.dart';
import 'package:tranquil_app/app/models/consultant_profile_model.dart';
import 'package:tranquil_app/app/utils/constants.dart';
import 'package:tranquil_app/app/utils/sizes_helpers.dart';
import 'package:tranquil_app/app/utils/snackbar.dart';
import 'package:tranquil_app/app/utils/valueListenableBuilder2.dart';
import 'package:uuid/uuid.dart';
import 'package:add_2_calendar/add_2_calendar.dart' as cal;
import '../../../../main.dart';
import 'components/grey_background_details_widget.dart';
import 'components/row_of_day_and_night_container.dart';
import 'components/time_slots_builder_widget.dart';

///SCREEN FOR THE CLIENT TO SELECT A TIME SLOTS FROM THE AVAILABLE TIME SLOTS OF THE CONSULTANT TO BOOK A
///APPOINTMENT WITH THE CONSULTANT
class ScheduleTimeWithConsultantScreen extends StatefulWidget {
  const ScheduleTimeWithConsultantScreen({
    Key? key,
    this.consultantDetails,
    this.scheduleSelectedDate,
    this.reSchedule = false,
    this.reScheduleMeetingID,
    this.availableDayTimeList = const [],
    this.availableNightTimeList = const [],
  }) : super(key: key);
  final ConsultantProfileModel? consultantDetails;
  final bool reSchedule;
  final String? reScheduleMeetingID;
  final DateTime? scheduleSelectedDate;
  final List<String> availableDayTimeList;
  final List<String> availableNightTimeList;
  @override
  _ScheduleTimeWithConsultantScreenState createState() =>
      _ScheduleTimeWithConsultantScreenState();
}

class _ScheduleTimeWithConsultantScreenState
    extends State<ScheduleTimeWithConsultantScreen> {
  final dateformat = DateFormat('dd-MM-yyyy');
  late List<String> availableDayTimeList;
  late List<String> availableNightTimeList;

  final ValueNotifier<int> selectedIndexOfTimeSections = ValueNotifier(0);

  final ValueNotifier<int> selectedIndexOfTimeSlot = ValueNotifier(-1);

  final ValueNotifier<bool> confirmed = ValueNotifier(false);

  final plugin = PaystackPlugin();

  CollectionReference transactionRef =
      FirebaseFirestore.instance.collection('transactions');
  DatabaseReference companyRef =
      FirebaseDatabase.instance.reference().child('company');
  CollectionReference meetingsRef =
      FirebaseFirestore.instance.collection('meetings');
  CollectionReference notificationsRef =
      FirebaseFirestore.instance.collection('notifications');
  CollectionReference chatRoomsRef =
      FirebaseFirestore.instance.collection('chatRooms');
  bool dataLoaded = false;
  double? consultantBalance;
  String? consultantTimeZone;
  DateTime? convertedTimeZoneTime;
  List<DisplayingTimeSlot> displayDayTimeSlot = [];
  List<DisplayingTimeSlot> displayNightTimeSlot = [];
  late String clientPhoneNumber;
  late int myTotalConsultations;
  late String consultantPhoneNumber;
  List<int> bookedDaySlotIndex = [];
  List<int> bookedNightSlotIndex = [];
  late Uuid uuid;
  String? subStr1;
  String? subStr2;
  String? subStr3;
  double? tranquilaAccountBal;
  // NumberFormat numberFormatter = NumberFormat("00");
  TimeManipulativeHelperController timeManipulativeHelperController =
      TimeManipulativeHelperController.instance;
  int indexOfDaySection = -1;
  int indexOfNightSection = -1;

  WalletController walletController = Get.put(WalletController());


  @override
  void initState() {
    super.initState();
    availableDayTimeList = widget.availableDayTimeList;
    availableNightTimeList = widget.availableNightTimeList;

    uuid = const Uuid();

    getDataFromFirebase();
    //initialize the payment gateway with the public key
    plugin.initialize(publicKey: publicKey);
  }

  Future getDataFromFirebase() async {
    QuerySnapshot meetings = await meetingsRef
        .where('consultantID', isEqualTo: widget.consultantDetails!.uid)
        .get();
    for (var i = 0; i < availableDayTimeList.length; i++) {
      var meeting = meetings.docs.where((element) {
        return (element.data() as Map?)!['startingTime'] ==
            timeManipulativeHelperController
                .convertFromHourToUTCTime(availableDayTimeList[i],
                    selectedDate: widget.scheduleSelectedDate!)
                .millisecondsSinceEpoch;
      }).toList();
      if (meeting.isNotEmpty) {
        bookedDaySlotIndex.add(i);
      }
    }
    for (var i = 0; i < availableNightTimeList.length; i++) {
      var meeting = meetings.docs
          .where((element) =>
              (element.data() as Map?)!['startingTime'] ==
              timeManipulativeHelperController
                  .convertFromHourToUTCTime(availableNightTimeList[i],
                      selectedDate: widget.scheduleSelectedDate!)
                  .millisecondsSinceEpoch)
          .toList();
      if (meeting.isNotEmpty) {
        bookedNightSlotIndex.add(i);
      }
    }
    print(bookedDaySlotIndex);
    print(bookedNightSlotIndex);
    convertTimeSlotListToDisplayList();
    setState(() {
      dataLoaded = true;
    });
  }

  void convertTimeSlotListToDisplayList() {
    for (var i = 0; i < availableNightTimeList.length; i++) {
      DateTime temp = TimeManipulativeHelperController.instance
          .convertFromHourToTime(availableNightTimeList[i]);
      if (temp.hour >= 7 && temp.hour < 20) {
        displayDayTimeSlot.add(DisplayingTimeSlot(
            availableNightTimeList[i], i, 1, temp.millisecondsSinceEpoch));
      } else {
        displayNightTimeSlot.add(DisplayingTimeSlot(
            availableNightTimeList[i], i, 1, temp.millisecondsSinceEpoch));
      }
    }
    for (var i = 0; i < availableDayTimeList.length; i++) {
      DateTime temp = TimeManipulativeHelperController.instance
          .convertFromHourToTime(availableDayTimeList[i]);
      if (temp.hour >= 7 && temp.hour < 20) {
        displayDayTimeSlot.add(DisplayingTimeSlot(
            availableDayTimeList[i], i, 0, temp.millisecondsSinceEpoch));
      } else {
        displayNightTimeSlot.add(DisplayingTimeSlot(
            availableDayTimeList[i], i, 0, temp.millisecondsSinceEpoch));
      }
    }
    sortDayAndListLists();
    print(displayDayTimeSlot);
    print(displayNightTimeSlot);
  }

  void sortDayAndListLists() {
    displayDayTimeSlot
        .sort((a, b) => a.dateOfTimeSlot.compareTo(b.dateOfTimeSlot));
    List<DisplayingTimeSlot> pmList = [];
    List<DisplayingTimeSlot> amList = [];
    for (var e in displayNightTimeSlot) {
      if (e.timeSlot.toLowerCase().contains('am')) {
        amList.add(e);
      } else {
        pmList.add(e);
      }
    }
    amList.sort((a, b) => a.dateOfTimeSlot.compareTo(b.dateOfTimeSlot));
    pmList.sort((a, b) => a.dateOfTimeSlot.compareTo(b.dateOfTimeSlot));
    displayNightTimeSlot.clear();
    displayNightTimeSlot.addAll(pmList);
    displayNightTimeSlot.addAll(amList);
  }

  updateMyConsultations() async {
    await accountSettingsRef!.child(auth!.currentUser!.uid).update({
      'totalConsultations':
          (DashboardController.to.myTotalConsultations!.value + 1)
    }).whenComplete(() {
      accountSettingsRef!
          .child("${widget.consultantDetails!.uid}")
          .child("profile")
          .update({
        'totalConsultations':
            (DashboardController.to.myTotalConsultations!.value + 1)
      });
    });

    DashboardController.to.myTotalConsultations!.value =
        DashboardController.to.myTotalConsultations!.value + 1;
  }

  Future<void> updateNotificationInDB() async {
    subStr1 = uuid.v4();
    subStr2 = uuid.v4();
    String id1 = subStr1!.substring(0, subStr1!.length - 10);
    String id2 = subStr2!.substring(0, subStr2!.length - 10);
    DateFormat formatter = DateFormat('kk:mm');
    String message =
        '${DashboardController.to.username!.value} scheduled a meeting with you for ${dateformat.format(widget.scheduleSelectedDate!)}, ${formatter.format(convertedTimeZoneTime!.toLocal()).toString()}';
    if (widget.reSchedule) {
      message =
          '${DashboardController.to.username!.value} re-scheduled a meeting with you for ${dateformat.format(widget.scheduleSelectedDate!)}, ${formatter.format(convertedTimeZoneTime!.toLocal()).toString()}';
    }
    GetStorage getStorage = await GetStorage();
    String? avatarUrl = getStorage.read(userAvatarUrl);
    //scheduled meeting notification for consultant
    await notificationsRef.doc(id1).set({
      'id': id1,
      'username': DashboardController.to.username!.value,
      'message': message,
      'notificationType': 'time',
      'uid': widget.consultantDetails!.uid,
      'avatarUrl': avatarUrl,
      'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch
    });
    message =
        'You scheduled a meeting with <strong>${widget.consultantDetails!.firstName} ${widget.consultantDetails!.lastName}</strong> '
        'for ${dateformat.format(widget.scheduleSelectedDate!)}, ${formatter.format(convertedTimeZoneTime!.toLocal()).toString()}';
    if (widget.reSchedule) {
      message =
          'You re-scheduled a meeting with <strong>${widget.consultantDetails!.firstName} ${widget.consultantDetails!.lastName}</strong> '
          'for ${dateformat.format(widget.scheduleSelectedDate!)}, ${formatter.format(convertedTimeZoneTime!.toLocal()).toString()}';
    }
    //scheduled meeting notification for client
    notificationsRef.doc(id2).set({
      'id': id2,
      'username':
          '${widget.consultantDetails!.firstName} ${widget.consultantDetails!.lastName}',
      'message': message,
      'notificationType': 'time',
      'uid': auth!.currentUser!.uid,
      'avatarUrl': widget.consultantDetails!.avatarUrl,
      'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch
    });
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
  }

  var timeFormat = DateFormat('kk:mm');
  var dateFormat = DateFormat('dd-MM-yyyy');

  sendEmailToClient() {
    String email = 'skiplab.innovation@gmail.com';
    String password = 'aaaaaa@123';
    String messageString = 'You have a meeting with';
    if (widget.reSchedule) {
      messageString = 'Your meeting is re-scheduled with';
    }
    //user for your own domain
    final smtpServer = gmail(email, password);

    final message = Message()
      ..from = Address(email, 'Tranquil life')
      ..recipients.add('${auth!.currentUser!.email}')
      //..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      //..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'You have a meeting 😀'
      ..html = '''
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <meta name="x-apple-disable-message-reformatting">
  <title></title>
  <style>
    table, td, div, h1, p {
      font-family: Arial, sans-serif;
    }
    @media screen and (max-width: 530px) {
      .unsub {
        display: block;
        padding: 8px;
        margin-top: 14px;
        border-radius: 6px;
        background-color: #555555;
        text-decoration: none !important;
        font-weight: bold;
      }
      .col-lge {
        max-width: 100% !important;
      }
    }
    @media screen and (min-width: 531px) {
      .col-sml {
        max-width: 27% !important;
      }
      .col-lge {
        max-width: 73% !important;
      }
    }
  </style>
</head>
<body style="margin:0;padding:0;word-spacing:normal;background-color:#939297;">
  <div role="article" aria-roledescription="email" lang="en" style="text-size-adjust:100%;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#939297;">
    <table role="presentation" style="width:100%;border:none;border-spacing:0;">
      <tr>
        <td align="center" style="padding:0;">
          <table role="presentation" style="width:94%;max-width:600px;border:none;border-spacing:0;text-align:left;font-family:Arial,sans-serif;font-size:16px;line-height:22px;color:#363636;">
            <tr>
              <td style="padding:40px 30px 30px 30px;text-align:center;font-size:24px;font-weight:bold;">
                <a href="http://www.example.com/" style="text-decoration:none;"><img src="https://assets.codepen.io/210284/logo.png" width="165" alt="Tranquila" style="width:80%;max-width:165px;height:auto;border:none;text-decoration:none;color:#ffffff;"></a>
              </td>
            </tr>
            <tr>
              <td style="padding:30px;background-color:#ffffff;">
                <h1 style="margin-top:0;margin-bottom:16px;font-size:26px;line-height:32px;font-weight:bold;letter-spacing:-0.02em;">Hello ${DashboardController.to.username!.value}!</h1>
                <p style="margin:0;">$messageString <strong>${widget.consultantDetails!.firstName} ${widget.consultantDetails!.lastName}</strong>, scheduled for 
                  ${timeFormat.format(convertedTimeZoneTime!).toString()} 'GMT ${DateTime.now().timeZoneOffset.isNegative ? '' : '+'}${_printDuration(DateTime.now().timeZoneOffset)}' 
                  on ${dateformat.format(widget.scheduleSelectedDate!)}</p>
              </td>
            </tr>
            <tr>
              <td style="padding:0;font-size:24px;line-height:28px;font-weight:bold;">
                <a href="http://www.example.com/" style="text-decoration:none;">
                <img src="https://firebasestorage.googleapis.com/v0/b/mindscapeproject-ef43d.appspot.com/o/emailTemplates%2Fschedule-vetcor.png?alt=media&token=b5c1f4c4-86ce-4dcf-b748-d16c32f9c59c" 
                width="600" alt="" style="width:100%;height:auto;display:block;border:none;text-decoration:none;color:#363636;">
                </a>
              </td>
            </tr>
            <tr>
              <td style="padding:35px 30px 11px 30px;font-size:0;background-color:#ffffff;border-bottom:1px solid #f0f0f5;border-color:rgba(201,201,207,.35);">
              <div style="text-align:center">
                <div class="col-lge" style="display:inline-block;width:100%;max-width:395px;vertical-align:top;padding-bottom:20px;font-family:Arial,sans-serif;font-size:16px;line-height:22px;color:#363636;">
                      <p style="margin:0;">
                          <a href="https://example.com/" style="background: #4CAF50; text-decoration: none; padding: 10px 25px; color: #ffffff; border-radius: 4px; display:inline-block; mso-padding-alt:0;text-underline-color:#ff3884">
                              <span style="mso-text-raise:10pt;font-weight:bold;">Tranquila
                              </span>
                          </a>
                      </p>
                  </div>
              </div>
                
              </td>  
            </tr>
            <tr>
              <td style="padding:30px;text-align:center;font-size:12px;background-color:#404040;color:#cccccc;">
                <p style="margin:0 0 8px 0;">
                <a href="http://www.facebook.com/" style="text-decoration:none;"><img src="https://assets.codepen.io/210284/facebook_1.png" width="40" height="40" alt="f" style="display:inline-block;color:#cccccc;"></a> 
                <a href="http://www.twitter.com/" style="text-decoration:none;"><img src="https://assets.codepen.io/210284/twitter_1.png" width="40" height="40" alt="t" style="display:inline-block;color:#cccccc;"></a></p>
                <p style="margin:0;font-size:14px;line-height:20px;">&reg; Skiplab Innovation, Nigeria 2021<br><a class="unsub" href="http://www.example.com/" style="color:#cccccc;text-decoration:underline;">Unsubscribe instantly</a></p>
              </td>
            </tr>
          </table>
 
        </td>
      </tr>
    </table>
  </div>
</body>
</html>
    ''';

    try {
      final sendReport = send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  void sendEmailToConsultant() {
    String email = 'skiplab.innovation@gmail.com';
    String password = 'aaaaaa@123';
    String messageString = 'You have a meeting with '
        '<strong>${widget.consultantDetails!.firstName} ${widget.consultantDetails!.lastName}</strong>';
    if (widget.reSchedule) {
      messageString = 'Your meeting is re-scheduled with '
          '<strong>${widget.consultantDetails!.firstName} ${widget.consultantDetails!.lastName}</strong>';
    }
    //user for your own domain
    final smtpServer = gmail(email, password);

    final message = Message()
      ..from = Address(email, 'Tranquil life')
      ..recipients.add(widget.consultantDetails!.email)
      //..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      //..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'You have a meeting 😀'
      ..html = '''
      <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <meta name="x-apple-disable-message-reformatting">
  <title></title>
  <style>
    table, td, div, h1, p {
      font-family: Arial, sans-serif;
    }
    @media screen and (max-width: 530px) {
      .unsub {
        display: block;
        padding: 8px;
        margin-top: 14px;
        border-radius: 6px;
        background-color: #555555;
        text-decoration: none !important;
        font-weight: bold;
      }
      .col-lge {
        max-width: 100% !important;
      }
    }
    @media screen and (min-width: 531px) {
      .col-sml {
        max-width: 27% !important;
      }
      .col-lge {
        max-width: 73% !important;
      }
    }
  </style>
</head>
<body style="margin:0;padding:0;word-spacing:normal;background-color:#939297;">
  <div role="article" aria-roledescription="email" lang="en" style="text-size-adjust:100%;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#939297;">
    <table role="presentation" style="width:100%;border:none;border-spacing:0;">
      <tr>
        <td align="center" style="padding:0;">
          <table role="presentation" style="width:94%;max-width:600px;border:none;border-spacing:0;text-align:left;font-family:Arial,sans-serif;font-size:16px;line-height:22px;color:#363636;">
            <tr>
              <td style="padding:40px 30px 30px 30px;text-align:center;font-size:24px;font-weight:bold;">
                <a href="http://www.example.com/" style="text-decoration:none;"><img src="https://assets.codepen.io/210284/logo.png" width="165" alt="Tranquila" style="width:80%;max-width:165px;height:auto;border:none;text-decoration:none;color:#ffffff;"></a>
              </td>
            </tr>
            <tr>
              <td style="padding:30px;background-color:#ffffff;">
                <h1 style="margin-top:0;margin-bottom:16px;font-size:26px;line-height:32px;font-weight:bold;letter-spacing:-0.02em;">Hello ${widget.consultantDetails!.firstName}!</h1>
                <p style="margin:0;">$messageString <strong>${DashboardController.to.username!.value}</strong>, scheduled for 
                  ${timeFormat.format(convertedTimeZoneTime!).toString()} 'GMT ${DateTime.now().timeZoneOffset.isNegative ? '' : '+'}${_printDuration(DateTime.now().timeZoneOffset)}' 
                  on ${dateformat.format(widget.scheduleSelectedDate!)}</p>
              </td>
            </tr>
            <tr>
              <td style="padding:0;font-size:24px;line-height:28px;font-weight:bold;">
                <a href="http://www.example.com/" style="text-decoration:none;">
                <img src="https://firebasestorage.googleapis.com/v0/b/mindscapeproject-ef43d.appspot.com/o/emailTemplates%2Fschedule-vetcor.png?alt=media&token=b5c1f4c4-86ce-4dcf-b748-d16c32f9c59c" 
                width="600" alt="" style="width:100%;height:auto;display:block;border:none;text-decoration:none;color:#363636;">
                </a>
              </td>
            </tr>
            <tr>
              <td style="padding:35px 30px 11px 30px;font-size:0;background-color:#ffffff;border-bottom:1px solid #f0f0f5;border-color:rgba(201,201,207,.35);">
              <div style="text-align:center">
                <div class="col-lge" style="display:inline-block;width:100%;max-width:395px;vertical-align:top;padding-bottom:20px;font-family:Arial,sans-serif;font-size:16px;line-height:22px;color:#363636;">
                      <p style="margin:0;">
                          <a href="https://example.com/" style="background: #4CAF50; text-decoration: none; padding: 10px 25px; color: #ffffff; border-radius: 4px; display:inline-block; mso-padding-alt:0;text-underline-color:#ff3884">
                              <span style="mso-text-raise:10pt;font-weight:bold;">Tranquila
                              </span>
                          </a>
                      </p>
                  </div>
              </div>
                
              </td>  
            </tr>
            <tr>
              <td style="padding:30px;text-align:center;font-size:12px;background-color:#404040;color:#cccccc;">
                <p style="margin:0 0 8px 0;">
                <a href="http://www.facebook.com/" style="text-decoration:none;"><img src="https://assets.codepen.io/210284/facebook_1.png" width="40" height="40" alt="f" style="display:inline-block;color:#cccccc;"></a> 
                <a href="http://www.twitter.com/" style="text-decoration:none;"><img src="https://assets.codepen.io/210284/twitter_1.png" width="40" height="40" alt="t" style="display:inline-block;color:#cccccc;"></a></p>
                <p style="margin:0;font-size:14px;line-height:20px;">&reg; Skiplab Innovation, Nigeria 2021<br><a class="unsub" href="http://www.example.com/" style="color:#cccccc;text-decoration:underline;">Unsubscribe instantly</a></p>
              </td>
            </tr>
          </table>
 
        </td>
      </tr>
    </table>
  </div>
</body>
</html>
      ''';

    try {
      final sendReport = send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  sendSMStoClient() async {
    await twilioFlutter?.sendSMS(
        toNumber: clientPhoneNumber,
        messageBody:
            '''You have a meeting with ${widget.consultantDetails!.firstName} ${widget.consultantDetails!.lastName}, scheduled for 
                  ${dateformat.format(convertedTimeZoneTime!).toString()} UTC ${DateTime.now().toUtc().timeZoneOffset.isNegative ? '' : '+'}${_printDuration(DateTime.now().toUtc().timeZoneOffset)}' 
                  on ${dateformat.format(widget.scheduleSelectedDate!)}''');

    twilioFlutter?.sendWhatsApp(
        toNumber: 'clientPhoneNumber', messageBody: 'hello world');
  }

  sendSMStoConsultant() async {
    await twilioFlutter?.sendSMS(
        toNumber: consultantPhoneNumber,
        messageBody:
            '''You have a meeting with ${DashboardController.to.username!.value}, scheduled for 
        ${dateformat.format(convertedTimeZoneTime!).toString()} UTC ${DateTime.now().toUtc().timeZoneOffset.isNegative ? '' : '+'}${_printDuration(DateTime.now().toUtc().timeZoneOffset)}'
    on ${dateformat.format(widget.scheduleSelectedDate!)}''');
  }

  void getSms() async {
    var data = await twilioFlutter?.getSmsList();
    print(data);
    await twilioFlutter?.getSMS('Sent');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (confirmed.value) {
          confirmed.value = false;
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: kLightBackgroundColor,
        body: Stack(
          children: [
            SafeArea(
              child: Container(
                width: displayWidth(context),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: displayWidth(context) * 0.97,
                        padding: const EdgeInsets.all(8),
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
                              icon: Icon(
                                Icons.arrow_back,
                                color: kPrimaryColor,
                              ),
                            ),
                            SizedBox(
                              width: displayWidth(context) * 0.06,
                            ),
                            //------------------------
                            // SCREEN HEADING
                            //------------------------
                            Text(
                              '${widget.consultantDetails!.firstName} ${widget.consultantDetails!.lastName}',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!dataLoaded)
                        Container(
                          height: 100,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      if (dataLoaded) ...[
                        SizedBox(
                          height: displayHeight(context) * 0.05,
                        ),
                        //------------------------
                        // Row of DayTime and NightTime containers
                        //------------------------
                        RowOfDayAndNightContainer(
                          onAnyContainerTapped: (index) {
                            selectedIndexOfTimeSections.value = index;
                            //setting the selected index of time slot to previously selected in other time section
                            if (index == 0) {
                              //when day time is selected storing the last selected index of time slot
                              //i.timeSectionItem nightTime selected time slot and then changing the selected index of time slot
                              //of dayTime section with the previously stored index
                              indexOfNightSection =
                                  selectedIndexOfTimeSlot.value;
                              selectedIndexOfTimeSlot.value = indexOfDaySection;
                            } else {
                              //when night time is selected storing the last selected index of time slot
                              //i.timeSectionItem dayTime selected time slot and then changing the selected index of time slot
                              //of nightTime section with the previously stored index
                              indexOfDaySection = selectedIndexOfTimeSlot.value;
                              selectedIndexOfTimeSlot.value =
                                  indexOfNightSection;
                            }
                          },
                        ),

                        SizedBox(
                          height: displayHeight(context) * 0.04,
                        ),

                        //------------------------
                        // TIME SLOT BUILDER
                        //------------------------
                        ValueListenableBuilder2(
                          selectedIndexOfTimeSections,
                          selectedIndexOfTimeSlot,
                          builder: (context, indexOfTimeSection,
                              int? indexOfTimeSlot, child) {
                            //print(indexOfTimeSlot);
                            return TimeSlotBuilderWidget(
                              timeList: indexOfTimeSection == 0
                                  ? availableDayTimeList
                                  : availableNightTimeList,
                              selectedIndexOfTimeSlot: indexOfTimeSlot,
                              bookedIndex: indexOfTimeSection == 0
                                  ? bookedDaySlotIndex
                                  : bookedNightSlotIndex,
                              onTapped: (index) {
                                if (selectedIndexOfTimeSections.value == 0 &&
                                    !bookedDaySlotIndex.contains(index)) {
                                  //setting the index to the ValueListener object of index of time slot
                                  selectedIndexOfTimeSlot.value = index;
                                } else if (selectedIndexOfTimeSections.value ==
                                        1 &&
                                    !bookedNightSlotIndex.contains(index)) {
                                  //setting the index to the ValueListener object of index of time slot
                                  selectedIndexOfTimeSlot.value = index;
                                }
                              },
                            );
                          },
                        ),
                        SizedBox(
                          height: displayHeight(context) * 0.06,
                        ),
                        if (widget.scheduleSelectedDate != null) ...[
                          //------------------------
                          // DATE CONTAINER
                          //------------------------
                          GreyBorderContainerForDetails(
                            svgUrl: 'assets/icons/calendar.svg',
                            title: 'Date',
                            info:
                                dateformat.format(widget.scheduleSelectedDate!),
                          ),
                          SizedBox(
                            height: displayHeight(context) * 0.02,
                          ),
                        ],

                        //------------------------
                        // FEE CONTAINER
                        //------------------------
                        GreyBorderContainerForDetails(
                          svgUrl: 'assets/icons/icon-credit-card.svg',
                          title: 'Fee',
                          info:
                              '\$${widget.consultantDetails!.fee == 0 ? 'No Fees Provided' : widget.consultantDetails!.fee}',
                        ),
                        SizedBox(
                          height: displayHeight(context) * 0.06,
                        ),
                        //------------------------
                        // CONFIRM BOOKING BUTTON
                        //------------------------
                        ValueListenableBuilder(
                          valueListenable: selectedIndexOfTimeSlot,
                          builder: (context, value, child) => value != -1
                              ? Container(
                                  width: displayWidth(context) * 0.86,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              kPrimaryColor),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      )),
                                      elevation: MaterialStateProperty.all(2),
                                    ),
                                    onPressed: () {
                                      confirmed.value = true;
                                    },
                                    //------------------------
                                    // CONFIRM BOOKING TITLE
                                    //------------------------
                                    child: FittedBox(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'CONFIRM BOOKING',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                      fit: BoxFit.none,
                                    ),
                                  ),
                                )
                              : Container(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: confirmed,
              builder: (context, bool confirmButtonValue, child) =>
                  confirmButtonValue
                      ? GestureDetector(
                          onTap: () {
                            confirmed.value = false;
                          },
                          child: Container(
                            height: displayHeight(context),
                            width: displayWidth(context),
                            padding:
                                EdgeInsets.all(displayWidth(context) * 0.1),
                            color: Colors.black.withOpacity(0.7),
                            child: GestureDetector(
                              onTap: () {},
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: SvgPicture.asset(
                                        'assets/icons/icon-caution.svg',
                                        height: displayHeight(context) * 0.05,
                                        width: displayHeight(context) * 0.05,
                                        // fit: BoxFit.scaleDown,
                                        color: Colors.yellowAccent,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 35,
                                    ),
                                    Text(
                                      widget.reSchedule
                                          ? 'Please note: You are about to re-schedule your meeting with the consultant'
                                          : 'Please note: If you are not present 10 minutes after the session starts, you would be marked as absent. \nBeing marked as absent means 50% will be deducted from the fee',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        wordSpacing: 2,
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 35,
                                    ),
                                    Center(
                                      child: InkWell(
                                        onTap: () async {
                                          confirmed.value = false;
                                          bool result = false;
                                          if (widget.reSchedule) {
                                            var selectectedTime =
                                                selectedIndexOfTimeSections
                                                            .value ==
                                                        0
                                                    ? availableDayTimeList[
                                                        selectedIndexOfTimeSlot
                                                            .value]
                                                    : availableNightTimeList[
                                                        selectedIndexOfTimeSlot
                                                            .value];

                                            convertedTimeZoneTime =
                                                _convertDateFromTimeDate(
                                                    selectedDate: widget
                                                        .scheduleSelectedDate!,
                                                    selectedTime:
                                                        selectectedTime);
                                            print(convertedTimeZoneTime);

                                            //add new scheduled meeting to database
                                            await meetingsRef
                                                .doc(widget.reScheduleMeetingID)
                                                .update({
                                              'startingTime':
                                                  convertedTimeZoneTime!
                                                      .millisecondsSinceEpoch,
                                              'timestamp': DateTime.now()
                                                  .toUtc()
                                                  .millisecondsSinceEpoch
                                            });
                                            await updateNotificationInDB();
                                            sendEmailToClient();
                                            sendEmailToConsultant();
                                            result = true;
                                          } else {
                                            result =
                                                await _paymentOptionsDialog(
                                                    context);
                                          }
                                          if (result) {
                                            Get.find<
                                                    MyScheduledMeetingsTabController>()
                                                .onReady();
                                            Navigator.of(context).pop(result);
                                          }
                                        },
                                        child: Container(
                                          height: 40,
                                          width: displayWidth(context) * 0.25,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: kPrimaryColor,
                                          ),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Ok',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _paymentOptionsDialog(BuildContext context) async {
    final ValueNotifier<bool> paymentLoading = ValueNotifier(false);
    bool result = false;
    await showDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Option:'),
          content: ValueListenableBuilder(
              valueListenable: paymentLoading,
              builder: (context, bool paymentLoadingValue, child) {
                return paymentLoadingValue
                    ? SizedBox(
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            ListTile(
                              onTap: () async {
                                paymentLoading.value = true;
                                var uuid = Uuid();
                                var subStr = uuid.v4();
                                String id =
                                    subStr.substring(0, subStr.length - 10);

                                //deduct amount from current user balance in database and update
                                double myBalance;
                                await accountSettingsRef!
                                    .child(auth!.currentUser!.uid)
                                    .once()
                                    .then((snapshot) {
                                  myBalance = double.parse(
                                      snapshot.value['balance'].toString());

                                  if (DashboardController
                                          .to.myTotalConsultations!.value <
                                      4) {
                                    double discountedFee = (widget
                                            .consultantDetails!.fee
                                            .toDouble()) *
                                        ((walletController.discount!.value) /
                                            100);

                                    print("DICOUNTED FEE" +
                                        discountedFee.toString());

                                    if (myBalance >= discountedFee) {
                                      //update my balance
                                      accountSettingsRef!
                                          .child(auth!.currentUser!.uid)
                                          .update({
                                        'balance': (myBalance - discountedFee)
                                      });

                                      //change state of wallet balance
                                      Get.find<DashboardController>()
                                          .balance!
                                          .value = (myBalance - discountedFee);

                                      //get consultant wallet balance
                                      accountSettingsRef!
                                          .child(widget.consultantDetails!.uid!)
                                          .once()
                                          .then((snapshot) async {
                                        consultantBalance = double.parse(
                                            snapshot.value['balance']
                                                .toString());
                                        consultantPhoneNumber =
                                            snapshot.value[userPhoneNum];

                                        //update consultant balance
                                        await accountSettingsRef!
                                            .child(
                                                widget.consultantDetails!.uid!)
                                            .update({
                                          'balance': consultantBalance! +
                                              (discountedFee * 0.6)
                                        });
                                        // !Here it is, here the selectedTIme has been set based on the time section selected
                                        // that is either dayTime or NightTime
                                        var selectectedTime =
                                            selectedIndexOfTimeSections.value ==
                                                    0
                                                ? availableDayTimeList[
                                                    selectedIndexOfTimeSlot
                                                        .value]
                                                : availableNightTimeList[
                                                    selectedIndexOfTimeSlot
                                                        .value];

                                        convertedTimeZoneTime =
                                            _convertDateFromTimeDate(
                                                selectedDate: widget
                                                    .scheduleSelectedDate!,
                                                selectedTime: selectectedTime);
                                        print(convertedTimeZoneTime);

                                        //add new scheduled meeting to database
                                        await scheduledMeetingsRef!
                                            .doc(id)
                                            .set({
                                          'creatorID': auth!.currentUser!.uid,
                                          'consultantID':
                                              widget.consultantDetails!.uid,
                                          'fee': widget.consultantDetails!.fee,
                                          'meetingID': id,
                                          'duration': '60:00',
                                          'startingTime': convertedTimeZoneTime!
                                              .millisecondsSinceEpoch,
                                          'timestamp': DateTime.now()
                                              .toUtc()
                                              .millisecondsSinceEpoch
                                        });

                                        //update my number of consultations
                                        await updateMyConsultations();
                                        await updateCalendarEvents(
                                            convertedTimeZoneTime!,
                                            convertedTimeZoneTime!.add(
                                                const Duration(minutes: 60)),
                                            widget.consultantDetails?.email ??
                                                '',
                                            "${widget.consultantDetails?.firstName ?? ''} ${widget.consultantDetails?.lastName ?? ''}");
                                        await updateNotificationInDB();

                                        subStr3 = uuid.v4();
                                        String id3 = subStr.substring(
                                            0, subStr3!.length - 10);

                                        //update consultations collection in firestore
                                        await consultationsRef!.doc(id3).set({
                                          "id": id3,
                                          'creatorID': auth!.currentUser!.uid,
                                          'consultantID':
                                              widget.consultantDetails!.uid,
                                          "avatarUrl": widget
                                              .consultantDetails!.avatarUrl,
                                          "timestamp": DateTime.now()
                                              .toUtc()
                                              .millisecondsSinceEpoch,
                                          'startingTime': convertedTimeZoneTime!
                                              .millisecondsSinceEpoch,
                                        });

                                        //transaction notification for client
                                        await notificationRef!.doc(id3).set({
                                          'id': id3,
                                          'username':
                                              '${widget.consultantDetails!.firstName} ${widget.consultantDetails!.lastName}',
                                          'message': '\$$discountedFee '
                                              'has been deducted from your wallet for a meeting with '
                                              '${widget.consultantDetails!.firstName} ${widget.consultantDetails!.lastName}',
                                          'notificationType': 'transaction',
                                          'uid': auth!.currentUser!.uid,
                                          'avatarUrl': widget
                                              .consultantDetails!.avatarUrl,
                                          'timestamp': DateTime.now()
                                              .toUtc()
                                              .millisecondsSinceEpoch
                                        });
                                      }).then((value) {
                                        sendEmailToClient();
                                        sendEmailToConsultant();
                                        print('all successful');
                                        result = true;
                                        paymentLoading.value = false;

                                        Navigator.of(context).pop();
                                      });
                                    } else {
                                      result = false;
                                      Navigator.of(context).pop();
                                      paymentLoading.value = false;

                                      displaySnackBar(
                                          'Your balance is too low', context);
                                    }
                                  } else {
                                    //update my balance
                                    if (myBalance >=
                                        double.parse(widget
                                            .consultantDetails!.fee
                                            .toString())) {
                                      accountSettingsRef!
                                          .child(auth!.currentUser!.uid)
                                          .update({
                                        'balance': (myBalance -
                                            widget.consultantDetails!.fee
                                                .toDouble())
                                      });

                                      //change state of wallet balance
                                      Get.find<DashboardController>()
                                              .balance!
                                              .value =
                                          (myBalance -
                                              widget.consultantDetails!.fee
                                                  .toDouble());

                                      //get consultant wallet balance
                                      accountSettingsRef!
                                          .child(widget.consultantDetails!.uid!)
                                          .once()
                                          .then((snapshot) async {
                                        consultantBalance = double.parse(
                                            snapshot.value['balance']
                                                .toString());
                                        consultantPhoneNumber =
                                            snapshot.value[userPhoneNum];

                                        //update consultant balance
                                        await accountSettingsRef!
                                            .child(
                                                widget.consultantDetails!.uid!)
                                            .update({
                                          'balance': consultantBalance! +
                                              (double.parse(widget
                                                      .consultantDetails!.fee
                                                      .toString()) *
                                                  0.6)
                                        });

                                        await transactionRef.doc(id).set({
                                          'id': id,
                                          'amount':
                                              widget.consultantDetails!.fee,
                                          'referenceNumber': _getReference(),
                                          'timestamp': DateTime.now()
                                              .toUtc()
                                              .millisecondsSinceEpoch,
                                          'uid': auth!.currentUser!.uid,
                                          'type': 'meeting'
                                        });

                                        // !Here it is, here the selectedTIme has been set based on the time section selected
                                        // that is either dayTime or NightTime
                                        var selectectedTime =
                                            selectedIndexOfTimeSections.value ==
                                                    0
                                                ? availableDayTimeList[
                                                    selectedIndexOfTimeSlot
                                                        .value]
                                                : availableNightTimeList[
                                                    selectedIndexOfTimeSlot
                                                        .value];

                                        convertedTimeZoneTime =
                                            _convertDateFromTimeDate(
                                                selectedDate: widget
                                                    .scheduleSelectedDate!,
                                                selectedTime: selectectedTime);
                                        print(convertedTimeZoneTime);

                                        //add new scheduled meeting to database
                                        await meetingsRef.doc(id).set({
                                          'creatorID': auth!.currentUser!.uid,
                                          'consultantID':
                                              widget.consultantDetails!.uid,
                                          'fee': widget.consultantDetails!.fee,
                                          'meetingID': id,
                                          'duration': '60:00',
                                          'startingTime': convertedTimeZoneTime!
                                              .millisecondsSinceEpoch,
                                          'timestamp': DateTime.now()
                                              .toUtc()
                                              .millisecondsSinceEpoch
                                        });

                                        //update my number of consultations
                                        await updateMyConsultations();

                                        await updateNotificationInDB();

                                        subStr3 = uuid.v4();
                                        String id3 = subStr.substring(
                                            0, subStr3!.length - 10);

                                        //update consultations collection in firestore
                                        await consultationsRef!.doc(id3).set({
                                          "id": id3,
                                          'creatorID': auth!.currentUser!.uid,
                                          'consultantID':
                                              widget.consultantDetails!.uid,
                                          "avatarUrl": widget
                                              .consultantDetails!.avatarUrl,
                                          "timestamp": DateTime.now()
                                              .toUtc()
                                              .millisecondsSinceEpoch
                                        });

                                        //transaction notification for client
                                        await notificationsRef.doc(id3).set({
                                          'id': id3,
                                          'username':
                                              '${widget.consultantDetails!.firstName} ${widget.consultantDetails!.lastName}',
                                          'message': '\$${widget.consultantDetails!.fee} '
                                              'has been deducted from your wallet for a meeting with '
                                              '${widget.consultantDetails!.firstName} ${widget.consultantDetails!.lastName}',
                                          'notificationType': 'transaction',
                                          'uid': auth!.currentUser!.uid,
                                          'avatarUrl': widget
                                              .consultantDetails!.avatarUrl,
                                          'timestamp': DateTime.now()
                                              .toUtc()
                                              .millisecondsSinceEpoch
                                        });
                                      }).then((value) {
                                        sendEmailToClient();
                                        sendEmailToConsultant();
                                        print('all successful');
                                        result = true;
                                        paymentLoading.value = false;

                                        Navigator.of(context).pop();
                                      });
                                    } else {
                                      result = false;
                                      Navigator.of(context).pop();
                                      paymentLoading.value = false;

                                      displaySnackBar(
                                          'Your balance is too low', context);
                                    }
                                  }
                                });
                              },
                              visualDensity: VisualDensity.compact,
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              horizontalTitleGap: 0,
                              title: Text(
                                'Wallet balance',
                                style: TextStyle(
                                    fontSize: displayWidth(context) * 0.04),
                              ),
                            ),
                          ],
                        ),
                      );
              }),
        );
      },
    );
    return result;
  }

  Future<void> updateCalendarEvents(DateTime startTime, DateTime endtime,
      String consultantEmail, String consultantName) async {
    final cal.Event event = cal.Event(
      title: 'Scheduled Meeting with $consultantName',
      description:
          'A appointment has been scheduled with $consultantName, on ${startTime.toIso8601String()}',
      startDate: startTime,
      endDate: endtime,
      iosParams: const cal.IOSParams(
        reminder: Duration(hours: 1),
      ),
      androidParams: cal.AndroidParams(
        emailInvites: [
          consultantEmail,
        ], // on Android, you can add invite emails to your event.
      ),
    );

    cal.Add2Calendar.addEvent2Cal(event);
  }

  ///gives a reference string mentioning from which device type and at what time it is charged
  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  DateTime _convertDateFromTimeDate(
      {required String selectedTime, required DateTime selectedDate}) {
    var selectedTimeWithOutnotation = selectedTime.split(' ');
    var selectedTimeList = selectedTimeWithOutnotation[0].split(':');
    var selectedHours = int.parse(selectedTimeList[0]);
    var selectedMinutes = int.parse(selectedTimeList[1]);
    if (selectedTimeWithOutnotation[1].toLowerCase() == 'pm' &&
        selectedHours != 12) {
      selectedHours += 12;
      if (selectedHours > 23) {
        selectedHours -= 24;
      }
    }
    return DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
            selectedHours, selectedMinutes)
        .toUtc();
  }
}

class DisplayingTimeSlot {
  final String timeSlot;
  final int indexOfTimeSlot;
  final int indexOfTimeSection;
  final int dateOfTimeSlot;

  DisplayingTimeSlot(this.timeSlot, this.indexOfTimeSlot,
      this.indexOfTimeSection, this.dateOfTimeSlot);

  @override
  String toString() {
    return 'The timeSlot is ------ $timeSlot'
        ', and index is --------- $indexOfTimeSlot '
        'and the timeSection is '
        '${indexOfTimeSection == 0 ? 'Day' : 'night'}';
  }
}
