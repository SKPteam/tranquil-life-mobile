// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/app_font.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/calendar_controller.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';
import 'package:tranquil_life/main.dart';
import 'package:tranquil_life/models/schedule_date_model.dart';
import 'package:tranquil_life/pages/scheduling/my_time_slots.dart';

import 'row_of_day_and_night_container.dart';

class ScheduleMeetingDialog extends StatefulWidget {
  @override
  _ScheduleMeetingDialogState createState() => _ScheduleMeetingDialogState();
}

class _ScheduleMeetingDialogState extends State<ScheduleMeetingDialog> {

  final CalendarController _calendarController = Get.put(CalendarController());
  // Size size = MediaQuery.of(Get.context!).size;
  //
  // final ValueNotifier<int> selectedDate = ValueNotifier(-1);
  // final ValueNotifier<String> selectedMonthToDisplay = ValueNotifier('');
  // final ScrollController _dateListController = ScrollController();
  // bool dataLoaded = true;
  // List<String> availableDayTimeList = [];
  // List<String> availableNightTimeList = [];
  // List<DateTime> allTimeSlotsList = [];


  // List<int> getListOfIndexFromList(List<String> list, List<String> mainList) {
  //   List<int> tmp = [];
  //   print(list);
  //   for (var i = 0; i < list.length; i++) {
  //     tmp.add(mainList.indexOf(list[i]));
  //   }
  //   return tmp;
  // }


  bool dataLoaded = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(40),
        ),
      ),
      padding: EdgeInsets.only(left: displayWidth(context) * 0.1, top: 40),
      child: dataLoaded
          ? Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sharedPreferences!.getString("userType") == client)
            SizedBox(
              height: 15,
            ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Edit Working Time',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  fontSize: 20,
                ),
              ),
              //if user is not client then show the edit symbol
              if(sharedPreferences!.getString("userType") == consultant)
                SizedBox(
                  width: 20,
                ),
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: kPrimaryColor,
                ),
                onPressed: () {
                  _calendarController.currentMonth();

                  print(_calendarController.daysFromIndex);
                  print(_calendarController.datesFromIndex);

                  // await Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //         SetTimeSlotsForConsultantScreen(
                  //           consultantProfileModel:
                  //           widget.consultantProfileModel,
                  //           indexOfDayList: getListOfIndexFromList(
                  //               availableDayTimeList, dayTimeList),
                  //           indexOfNightList: getListOfIndexFromList(
                  //               availableNightTimeList, nightTimeList),
                  //         ),
                  //   ),
                  // );
                  // Navigator.of(context).pop();
                },
              )
            ],
          ),

          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(_calendarController.currentMonth(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: josefinSansBold,
                  color: kPrimaryDarkColor,
                  fontSize: 22,
                ),
              ),
              SizedBox(
                width: displayWidth(context) * 0.02,
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 30,
                color: Colors.black,
              ),
            ],
          ),
          Expanded(
              child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _calendarController.daysFromIndex.length,
              itemBuilder: (BuildContext context,int index){
                return GestureDetector(
                  onTap: (){
                    Get.to(MyTimeSlots());
                  },
                  child: SizedBox(
                    width: 80,
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        margin: EdgeInsets.only(
                            top: displayHeight(context)*0.02,
                            bottom: displayHeight(context)*0.12,
                            right: displayWidth(context)*0.02),
                        child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${_calendarController.daysFromIndex[index]}"),
                                SizedBox(height: displayHeight(context)*0.02),
                                Text("${_calendarController.datesFromIndex[index]}"),
                              ],
                            )
                        )
                    ),
                  ),
                );
              }))
        ],
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/*
* Text(
                          "${_calendarController.daysFromIndex[index]} \n\n${_calendarController.datesFromIndex[index]}",
                          textAlign: TextAlign.center),
* */