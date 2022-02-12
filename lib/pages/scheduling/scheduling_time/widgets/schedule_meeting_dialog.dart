// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/models/consultant_profile_model.dart';
import 'package:tranquil_life/models/schedule_date_model.dart';

class ScheduleMeetingDialog extends StatefulWidget {
  final String workingTimeOfConsultant;
  final ConsultantProfileModel consultantProfileModel;
  final bool isUserClient;
  final bool reSchedule;
  final String reScheduleMeetingID;
  final List<Schedule> schedules;

  const ScheduleMeetingDialog(
      {Key? key,
        required this.schedules,
        this.workingTimeOfConsultant = 'Mon - Fri',
        this.isUserClient = false,
        this.reSchedule = false,
        required this.reScheduleMeetingID,
        required this.consultantProfileModel});

  @override
  _ScheduleMeetingDialogState createState() => _ScheduleMeetingDialogState();
}

class _ScheduleMeetingDialogState extends State<ScheduleMeetingDialog> {
  Size size = MediaQuery.of(Get.context!).size;

  final ValueNotifier<int> selectedDate = ValueNotifier(-1);
  final ValueNotifier<String> selectedMonthToDisplay = ValueNotifier('');
  final ScrollController _dateListController = ScrollController();
  bool dataLoaded = true;
  List<String> availableDayTimeList = [];
  List<String> availableNightTimeList = [];
  List<DateTime> allTimeSlotsList = [];


  @override
  void initState() {
    super.initState();
  }



  List<int> getListOfIndexFromList(List<String> list, List<String> mainList) {
    List<int> tmp = [];
    print(list);
    for (var i = 0; i < list.length; i++) {
      tmp.add(mainList.indexOf(list[i]));
    }
    return tmp;
  }

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
      padding: EdgeInsets.only(left: size.width * 0.1, top: 40),
      child: dataLoaded
          ? Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isUserClient)
            const SizedBox(
              height: 15,
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Working Time',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  fontSize: 20,
                ),
              ),
              //if user is not client then show the edit symbol
              if (!widget.isUserClient) ...[
                const SizedBox(
                  width: 20,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: kPrimaryColor,
                  ),
                  onPressed: () async {
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
              ]
            ],
          ),
          if (widget.isUserClient) ...[
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.workingTimeOfConsultant.isEmpty
                  ? 'No Working Time Provided'
                  : widget.workingTimeOfConsultant,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                  fontSize: 14),
            ),
          ],
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // value notifier for changing the String of the month according to the scrolling
              ValueListenableBuilder(
                valueListenable: selectedMonthToDisplay,
                builder: (context, String value, child) => Text(
                  value.isNotEmpty
                      ? value
                      : monthsFromIndex[
                  widget.schedules.first.dateTime.month - 1],
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(
                width: 25,
              ),
              const Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 80,
            //------------------------
            // ListView [horizontal] for weekDay and date containers
            //------------------------
            child: ValueListenableBuilder(
              valueListenable: selectedDate,
              builder: (context, value, child) =>
              //scroll listener widget that listens to any notifications thrown up the widget tree
              //we specifically are listening to Scroll Notification
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  //if the notification is scrollUpdateNotification then we proceed
                  if (notification is ScrollUpdateNotification) {
                    double scrollOffset = _dateListController.offset;
                    //we calculate the index of the last date container in the listView that is visinle on screen by a formula
                    // * where we attach a scroll controller [_dateListController] to the listview
                    // * we extract the offset from the scroll Controller and add it with the 90% of device width
                    // * as 10% is padding in the left and then subtract it by 20 as it's padding in the right
                    // * and then divide it by 80, 60 is the width of the container and added 20 as there is SizedBox
                    // * of 20 width between each container and then subtract 1 from it as we need index which starts from 0
                    var indexOfDateBadge = ((scrollOffset +
                        size.width * 0.9 -
                        20) ~/
                        80) -
                        1;
                    indexOfDateBadge = indexOfDateBadge < 0
                        ? 0
                        : indexOfDateBadge > 6
                        ? 6
                        : indexOfDateBadge;
                    print(indexOfDateBadge);
                    selectedMonthToDisplay.value = scrollOffset < 10
                        ? monthsFromIndex[
                    widget.schedules.first.dateTime.month - 1]
                        : monthsFromIndex[widget
                        .schedules[indexOfDateBadge]
                        .dateTime
                        .month -
                        1];
                  }
                  return false;
                },
                child: ListView.separated(
                  controller: _dateListController,
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 20,
                  ),
                  padding: const EdgeInsets.only(right: 20),
                  itemBuilder: (context, index) => InkWell(
                    onTap: () async {
                      // if (value == -1) {
                      //   //changing the selected date color
                      //   selectedDate.value = index;
                      //   //after a second delay navigate to another page
                      //   await Future.delayed(
                      //       const Duration(milliseconds: 300));
                      //   print(
                      //       'available List - > $availableDayTimeList and day list --> $dayTimeList');
                      //   var result = await Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => DashboardController
                      //             .to.userType ==
                      //             client
                      //             ? ScheduleTimeWithConsultantScreen(
                      //           consultantDetails:
                      //           widget.consultantProfileModel,
                      //           scheduleSelectedDate: widget
                      //               .schedules[index].dateTime,
                      //           availableDayTimeList:
                      //           availableDayTimeList,
                      //           availableNightTimeList:
                      //           availableNightTimeList,
                      //           reSchedule: widget.reSchedule,
                      //           reScheduleMeetingID:
                      //           widget.reScheduleMeetingID,
                      //           key: null,
                      //         )
                      //             : SetTimeSlotsForConsultantScreen(
                      //           consultantProfileModel:
                      //           widget.consultantProfileModel,
                      //           scheduleSelectedDate: widget
                      //               .schedules[index].dateTime,
                      //           indexOfDayList:
                      //           getListOfIndexFromList(
                      //               availableDayTimeList,
                      //               dayTimeList),
                      //           indexOfNightList:
                      //           getListOfIndexFromList(
                      //               availableNightTimeList,
                      //               nightTimeList),
                      //         ),
                      //       ));
                      //   Navigator.of(context).pop(result ?? false);
                      // }
                    },
                    child: Container(
                      height: 80,
                      width: 60,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: value != -1 && value == index
                            ? kPrimaryColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //------------------------
                          // weekDay in the listview
                          //------------------------
                          FittedBox(
                            fit: BoxFit.none,
                            child: Text(
                              widget.schedules[index].weekDay,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: value != -1 && value == index
                                    ? Colors.white60
                                    : Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          //------------------------
                          // date in the listview
                          //------------------------
                          FittedBox(
                            fit: BoxFit.none,
                            child: Text(
                              '${widget.schedules[index].dateTime.day}',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: value != -1 && value == index
                                    ? Colors.white
                                    : Colors.black87,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  itemCount: widget.schedules.length,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
          )
        ],
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}