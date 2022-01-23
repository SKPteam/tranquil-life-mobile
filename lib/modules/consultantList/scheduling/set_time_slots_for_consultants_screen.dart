// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tranquil_app/app/helperControllers/timeFunctionsController.dart';
import 'package:tranquil_app/app/models/consultant_profile_model.dart';
import 'package:tranquil_app/app/utils/constants.dart';
import 'package:tranquil_app/app/utils/sizes_helpers.dart';
import 'package:tranquil_app/app/utils/valueListenableBuilder2.dart';

import '../../../../main.dart';

import 'components/demoTimings.dart';
import 'components/grey_background_details_widget.dart';
import 'components/row_of_day_and_night_container.dart';
import 'components/time_slots_builder_widget.dart';

///SCREEN FOR THE CONSULTANT TO SELECT TIME SLOTS ON WHICH HE WILL BE AVAILABLE EITHER EVERYDAY OR ON A PARTICULAR DATE
///IF PASSED ONE TO [scheduleSelectedDate]
class SetTimeSlotsForConsultantScreen extends StatefulWidget {
  const SetTimeSlotsForConsultantScreen(
      {Key? key,
      required this.consultantProfileModel,
      this.scheduleSelectedDate,
      this.indexOfDayList = const [],
      this.indexOfNightList = const []})
      : super(key: key);
  final ConsultantProfileModel consultantProfileModel;
  final DateTime? scheduleSelectedDate;
  final List<int> indexOfDayList;
  final List<int> indexOfNightList;
  @override
  _SetTimeSlotsForConsultantScreenState createState() =>
      _SetTimeSlotsForConsultantScreenState();
}

class _SetTimeSlotsForConsultantScreenState
    extends State<SetTimeSlotsForConsultantScreen> {
  final dateformat = DateFormat('dd-MM-yyyy');
  final ValueNotifier<int> selectedIndexOfTimeSections = ValueNotifier(0);
  final ValueNotifier<List<int>> selectedIndexOfTimeSlot = ValueNotifier([]);
  List<int> indexListOfNightSection = [];
  List<int> indexListOfDaySection = [];
  final ValueNotifier<bool> confirmed = ValueNotifier(false);
  CollectionReference allTimeSlotsRef =
      FirebaseFirestore.instance.collection('timeSlots');
  List<int> bookedDaySlotIndex = [];
  List<int> bookedNightSlotIndex = [];
  bool readOnly = false;
  final timeManipulativeHelperController =
      TimeManipulativeHelperController.instance;
  CollectionReference meetingsRef =
      FirebaseFirestore.instance.collection('meetings');
  bool dataLoaded = false;

  @override
  void initState() {
    super.initState();
    readOnly = widget.scheduleSelectedDate != null;
    getMyDayTimeHours();
  }

  getAllBookedSlot() async {
    var testMeetings = await meetingsRef
        .where('consultantID', isEqualTo: widget.consultantProfileModel.uid)
        .get();
    print('testing --> ${testMeetings.docs.length}');
    for (var i = 0; i < dayTimeList.length; i++) {
      print(timeManipulativeHelperController
          .convertFromHourToUTCTime(dayTimeList[i],
              selectedDate: widget.scheduleSelectedDate!)
          .millisecondsSinceEpoch);
      // var meeting = await meetingsRef
      //     .where('consultantID', isEqualTo: widget.consultantProfileModel.uid)
      //     .where(
      //       'startingTime',
      //       isEqualTo: timeManipulativeHelperController
      //           .convertFromHourToUTCTime(dayTimeList[i],
      //               selectedDate: widget.scheduleSelectedDate!)
      //           .millisecondsSinceEpoch,
      //     )
      //     .get();
      // if (meeting.docs.isNotEmpty) {
      //   bookedDaySlotIndex.add(i);
      // }
      for (var j = 0; j < testMeetings.docs.length; j++) {
        final _data = testMeetings.docs[j].data() as Map<String, dynamic>?;
        if ((_data?['startingTime'] ?? 0) ==
            timeManipulativeHelperController
                .convertFromHourToUTCTime(dayTimeList[i],
                    selectedDate: widget.scheduleSelectedDate!)
                .millisecondsSinceEpoch) {
          bookedDaySlotIndex.add(i);
        }
      }
    }
    for (var i = 0; i < nightTimeList.length; i++) {
      print(timeManipulativeHelperController
          .convertFromHourToUTCTime(nightTimeList[i],
              selectedDate: widget.scheduleSelectedDate!)
          .millisecondsSinceEpoch);
      // var meeting = await meetingsRef
      //     .where('consultantID', isEqualTo: widget.consultantProfileModel.uid)
      //     .where(
      //       'startingTime',
      //       isEqualTo: timeManipulativeHelperController
      //           .convertFromHourToUTCTime(nightTimeList[i],
      //               selectedDate: widget.scheduleSelectedDate!)
      //           .millisecondsSinceEpoch,
      //     )
      //     .get();
      // if (meeting.docs.isNotEmpty) {
      //   bookedNightSlotIndex.add(i);
      // }
      for (var j = 0; j < testMeetings.docs.length; j++) {
        final _data = testMeetings.docs[j].data() as Map<String, dynamic>?;
        if ((_data?['startingTime'] ?? 0) ==
            timeManipulativeHelperController
                .convertFromHourToUTCTime(nightTimeList[i],
                    selectedDate: widget.scheduleSelectedDate!)
                .millisecondsSinceEpoch) {
          bookedNightSlotIndex.add(i);
        }
      }
    }
    print(bookedDaySlotIndex);
    print(bookedNightSlotIndex);
    setState(() {
      dataLoaded = true;
    });
  }

  getMyDayTimeHours() async {
    print('Day List: ${widget.indexOfDayList}');
    print('Night List: ${widget.indexOfNightList}');
    indexListOfNightSection = widget.indexOfNightList;
    indexListOfDaySection = widget.indexOfDayList;
    if (widget.scheduleSelectedDate == null) {
      selectedIndexOfTimeSlot.value = indexListOfDaySection;
      setState(() {
        dataLoaded = true;
      });
    } else {
      getAllBookedSlot();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBackgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: SizedBox(
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
                            icon: const Icon(
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
                            '${widget.consultantProfileModel.firstName} ${widget.consultantProfileModel.lastName}',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.05,
                    ),
                    if (!dataLoaded)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    if (dataLoaded) ...[
                      //------------------------
                      // Row of DayTime and NightTime containers
                      //------------------------
                      RowOfDayAndNightContainer(
                        onAnyContainerTapped: (index) {
                          selectedIndexOfTimeSections.value = index;
                          if (!readOnly) {
                            if (index == 0) {
                              //when day time is selected storing the last selected index of time slot
                              //i.timeSectionItem nightTime selected time slot and then changing the selected index of time slot
                              //of dayTime section with the previously stored index
                              indexListOfNightSection =
                                  selectedIndexOfTimeSlot.value;
                              selectedIndexOfTimeSlot.value =
                                  indexListOfDaySection;
                            } else {
                              //when night time is selected storing the last selected index of time slot
                              //i.timeSectionItem dayTime selected time slot and then changing the selected index of time slot
                              //of nightTime section with the previously stored index
                              indexListOfDaySection =
                                  selectedIndexOfTimeSlot.value;
                              selectedIndexOfTimeSlot.value =
                                  indexListOfNightSection;
                            }
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
                            List<int> indexOfTimeSlot, child) {
                          print(indexOfTimeSlot);
                          return TimeSlotBuilderWidget(
                            enabledIndex: widget.scheduleSelectedDate != null
                                ? indexOfTimeSection == 0
                                    ? indexListOfDaySection
                                    : indexListOfNightSection
                                : null,
                            timeList: indexOfTimeSection == 0
                                ? dayTimeList
                                : nightTimeList,
                            selectedIndexOfTimeSlotsList: indexOfTimeSlot,
                            bookedIndex: widget.scheduleSelectedDate != null
                                ? indexOfTimeSection == 0
                                    ? bookedDaySlotIndex
                                    : bookedNightSlotIndex
                                : null,
                            onTapped: (index) {
                              if (!readOnly) {
                                if (selectedIndexOfTimeSlot.value
                                    .contains(index)) {
                                  selectedIndexOfTimeSlot.value =
                                      List.from(selectedIndexOfTimeSlot.value)
                                        ..remove(index);
                                  // selectedIndexOfTimeSlot.notifyListeners();
                                } else {
                                  //setting the index to the ValueListener object of index of time slot
                                  selectedIndexOfTimeSlot.value =
                                      List.from(selectedIndexOfTimeSlot.value)
                                        ..add(index);
                                  // selectedIndexOfTimeSlot.notifyListeners();
                                }
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(
                        height: displayHeight(context) * 0.06,
                      ),
                      if (readOnly) ...[
                        //------------------------
                        // DATE CONTAINER
                        //------------------------
                        GreyBorderContainerForDetails(
                          svgUrl: 'assets/icons/schedule.svg',
                          title: 'Date',
                          info: dateformat.format(widget.scheduleSelectedDate!),
                        ),
                        SizedBox(
                          height: displayHeight(context) * 0.02,
                        ),
                      ],
                      //------------------------
                      // FEE CONTAINER
                      //------------------------
                      GreyBorderContainerForDetails(
                        svgUrl: 'assets/icons/schedule.svg',
                        title: 'Fee',
                        info: 'N${widget.consultantProfileModel.fee}',
                      ),
                      SizedBox(
                        height: displayHeight(context) * 0.06,
                      ),
                      if (!readOnly)
                        //------------------------
                        // CONFIRM BOOKING BUTTON
                        //------------------------
                        ValueListenableBuilder(
                          valueListenable: selectedIndexOfTimeSlot,
                          builder: (context, List<int> value, child) => value
                                  .isNotEmpty
                              ? SizedBox(
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
                                    child: const FittedBox(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'CONFIRM AVAILABLE HOURS',
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
                          padding: EdgeInsets.all(displayWidth(context) * 0.1),
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
                                    'Please note: You are about to change your available hour for everyday for ${selectedIndexOfTimeSections.value == 0 ? 'Day Time Slots' : 'Night Time Slots'}',
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
                                        if (widget.scheduleSelectedDate ==
                                            null) {
                                          if (!readOnly) {
                                            if (selectedIndexOfTimeSections
                                                    .value ==
                                                1) {
                                              indexListOfNightSection =
                                                  selectedIndexOfTimeSlot.value;
                                            } else {
                                              indexListOfDaySection =
                                                  selectedIndexOfTimeSlot.value;
                                            }
                                          }
                                          List<String> selectedTimeSlotsList =
                                              indexListOfDaySection
                                                  .map((e) => dayTimeList[e])
                                                  .toList();
                                          Map<String, bool> dayMap = {
                                            for (var e in dayTimeList)
                                              TimeManipulativeHelperController
                                                      .instance
                                                      .convertFromHourToUTCHourpart2(
                                                          e.toString()):
                                                  selectedTimeSlotsList
                                                      .contains(e)
                                          };
                                          print(indexListOfDaySection);
                                          print(selectedTimeSlotsList);
                                          print(dayMap);
                                          List<String>
                                              nightselectedTimeSlotsList =
                                              indexListOfNightSection
                                                  .map((e) => nightTimeList[e])
                                                  .toList();
                                          Map<String, bool> nightMap = {
                                            for (var e in nightTimeList)
                                              TimeManipulativeHelperController
                                                      .instance
                                                      .convertFromHourToUTCHourpart2(
                                                          e.toString()):
                                                  nightselectedTimeSlotsList
                                                      .contains(e)
                                          };
                                          print(indexListOfNightSection);
                                          print(nightselectedTimeSlotsList);
                                          print(nightMap);
                                          Map<String, bool> map = {};
                                          map.addEntries(dayMap.entries);
                                          map.addEntries(nightMap.entries);
                                          print(map);
                                          // if (selectedIndexOfTimeSections.value ==
                                          //     0) {
                                          await allTimeSlotsRef
                                              .doc(auth!.currentUser!.uid)
                                              .set({
                                            'hours': map,
                                            'isAllowed': false,
                                          });
                                          // } else {
                                          //   await nightTimeRef
                                          //       .doc(auth.currentUser.uid)
                                          //       .set({
                                          //     'hours': map,
                                          //     'slot':
                                          //         selectedIndexOfTimeSections.value,
                                          //     'isAllowed': false
                                          //   });
                                          // }
                                        }
                                        confirmed.value = false;
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
    );
  }
}
