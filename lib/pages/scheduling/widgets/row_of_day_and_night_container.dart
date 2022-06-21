// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/my_time_slots_controller.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';

class RowOfDayAndNightContainer extends StatefulWidget {
  @override
  _RowOfDayAndNightContainerState createState() =>
      _RowOfDayAndNightContainerState();
}

class _RowOfDayAndNightContainerState extends State<RowOfDayAndNightContainer> {
  final MyTimeSlotController _myTimeSlotController = Get.put(MyTimeSlotController());


  final List<Map<String, String>> timeSections = [
    {'svgUrl': 'assets/icons/icon-sunny.svg', 'title': 'Daytime'},
    {'svgUrl': 'assets/icons/icon-partly-sunny.svg', 'title': 'Nightime'}
  ];
  @override
  Widget build(BuildContext context) {
    return Obx(()=>
        Container(
          padding: EdgeInsets.symmetric(horizontal: displayWidth(context) * 0.07),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: timeSections.map(
                  (timeSectionItem) {
                int index = timeSections.indexOf(timeSectionItem);
                return InkWell(
                  onTap: () {
                    _myTimeSlotController.selectedSectionIndex.value = index;

                    //print(_myTimeSlotController.selectedSectionIndex.value);
                   // print(int.parse(dayTimeList[6].substring(0, 2)));

                    // final _localTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, int.parse(dayTimeList[6].substring(0, 2)), 0, 0);
                    // print("LOCAL HOUR: ${_localTime.hour}");
                    // final _utcTime = _localTime.toUtc();
                    // print("UTC HOUR: $_utcTime");
                    // print("TIMESTAMP: ${_utcTime.millisecondsSinceEpoch}");


                    List utcDayTimeList = [];

                    var timeFormat = DateFormat("kk:mm");

                    for(var i = 0; i <= dayTimeList.length-1; i++)
                    {
                      final _localTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, int.parse(dayTimeList[i].substring(0, 2)), 0, 0);
                      print("LOCAL HOUR: ${_localTime.hour}");
                      final _utcTime = _localTime.toUtc();
                      print("UTC HOUR: $_utcTime");
                      print("TIMESTAMP: ${_utcTime.millisecondsSinceEpoch}");
                      //print(timeFormat.format(_utcTime));

                      utcDayTimeList.add(timeFormat.format(_utcTime));
                    }

                    print(utcDayTimeList);


                  },
                  child: Container(
                    width: displayWidth(context) * 0.405,
                    height: 70,
                    decoration: BoxDecoration(
                      color: _myTimeSlotController.selectedSectionIndex.value == index
                          ? kPrimaryColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 45,
                          height: 45,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: _myTimeSlotController.selectedSectionIndex.value == index
                                ? Colors.white
                                : kLightBackgroundColor,
                          ),
                          child: SvgPicture.asset(
                            timeSectionItem['svgUrl']!,
                            color: _myTimeSlotController.selectedSectionIndex.value == index
                                ? kPrimaryColor
                                : Colors.grey[600],
                            fit: BoxFit.none,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        //------------------------
                        // TITLE
                        //------------------------
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              timeSectionItem['title']!,
                              style: TextStyle(
                                color:  _myTimeSlotController.selectedSectionIndex.value == index
                                    ? Colors.white70
                                    : Colors.grey[600],
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ));
  }
}