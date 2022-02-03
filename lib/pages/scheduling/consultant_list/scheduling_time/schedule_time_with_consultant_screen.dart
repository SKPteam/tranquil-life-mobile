// ignore_for_file: prefer_const_constructors

import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/dashboard_controller.dart';
import 'package:tranquil_life/controllers/wallet_controller.dart';
import 'package:tranquil_life/helpers/constants.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';
import 'package:tranquil_life/helpers/time_function_controller_helper.dart';
import 'package:tranquil_life/models/consultant_profile_model.dart';
import 'package:tranquil_life/pages/scheduling/consultant_list/scheduling_time/widgets/grey_background_details_widget.dart';
import 'package:tranquil_life/pages/scheduling/consultant_list/scheduling_time/widgets/row_of_day_and_night_container.dart';
import 'package:tranquil_life/pages/scheduling/consultant_list/scheduling_time/widgets/time_slots_builder_widget.dart';
import 'package:tranquil_life/widgets/custom_snackbar.dart';
import 'package:tranquil_life/widgets/valueListenableBuilder2.dart';

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



  // Future<void> updateNotificationInDB() async {
  //
  //   String id1 = subStr1!.substring(0, subStr1!.length - 10);
  //   String id2 = subStr2!.substring(0, subStr2!.length - 10);
  //   DateFormat formatter = DateFormat('kk:mm');
  //   String message =
  //       '${DashboardController.to.username!.value} scheduled a meeting with you for ${dateformat.format(widget.scheduleSelectedDate!)}, ${formatter.format(convertedTimeZoneTime!.toLocal()).toString()}';
  //   if (widget.reSchedule) {
  //     message =
  //     '${DashboardController.to.username!.value} re-scheduled a meeting with you for ${dateformat.format(widget.scheduleSelectedDate!)}, ${formatter.format(convertedTimeZoneTime!.toLocal()).toString()}';
  //   }
  //   GetStorage getStorage = await GetStorage();
  //   String? avatarUrl = getStorage.read(userAvatarUrl);
  //   //scheduled meeting notification for consultant
  //
  //   message =
  //   'You scheduled a meeting with <strong>${widget.consultantDetails!.firstName} ${widget.consultantDetails!.lastName}</strong> '
  //       'for ${dateformat.format(widget.scheduleSelectedDate!)}, ${formatter.format(convertedTimeZoneTime!.toLocal()).toString()}';
  //   if (widget.reSchedule) {
  //     message =
  //     'You re-scheduled a meeting with <strong>${widget.consultantDetails!.firstName} ${widget.consultantDetails!.lastName}</strong> '
  //         'for ${dateformat.format(widget.scheduleSelectedDate!)}, ${formatter.format(convertedTimeZoneTime!.toLocal()).toString()}';
  //   }
  //   //scheduled meeting notification for client
  //
  // }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
  }

  var timeFormat = DateFormat('kk:mm');
  var dateFormat = DateFormat('dd-MM-yyyy');

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
                              onTap: () async {},
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
                        onTap: () async {},
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


  ///gives a reference string mentioning from which device type and at what time it is charged
  // String _getReference() {
  //   String platform;
  //   // if (Platform.isIOS) {
  //   //   platform = 'iOS';
  //   // } else {
  //   //   platform = 'Android';
  //   // }
  //
  //   return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  // }

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