import 'package:get/get.dart';

import '../constants/app_strings.dart';

class CalendarController extends GetxController{
  static CalendarController instance = Get.find();

  var now = new DateTime.now();
  RxList daysFromIndex = [].obs;
  RxList datesFromIndex = [].obs;

  String currentMonth(){
    var current_mon = now.month;

    return months[current_mon-1];
  }

  void nextSevenDays(){
    // Find the last day of the month.
    var lastDayDateTime = (now.month < 12)
        ? new DateTime(now.year, now.month + 1, 0)
        : new DateTime(now.year + 1, 1, 0);

    // Find the next current week days after today.
    List nextWeekDays = [];
    for(int i=now.weekday+1; i <= now.weekday + 7; i++){
        if(i <= 7){
          nextWeekDays.add(i);
        }
    }

    List nextDays = [];
    List nextMonthDays = [];

    // Find the next current dates after today.
    for(int j=now.day+1; j <= now.day + 7; j++){
      if(j <= lastDayDateTime.day){
        nextDays.add(j);
      }
    }

    // Find the next first days of next month if calendar reaches last
    // day of current month and add to last days of current month array.
    if(nextDays.length < 7){
      var toAdd = 7 - nextDays.length;
      var next_month = now.month+1;
      var firstDayDateTime = (next_month < 12)
          ? new DateTime(now.year, next_month, 1)
          : new DateTime(now.year + 1, 1, 0);

      for(int k=firstDayDateTime.day; k <= firstDayDateTime.day-1 + toAdd; k++){
        nextMonthDays.add(k);
      }
    }

    var list1 = [];
    var list2 = [];

    for(var element in nextWeekDays){
      list1.add(days[element-1]);
    }

    if(nextWeekDays.contains(7)){
      for(var x = 0; x <= (7-list1.length)-1; x++){
        list2.add(days[x]);
      }
    }


    datesFromIndex.value = List.from(nextDays)..addAll(nextMonthDays);
    daysFromIndex.value = List.from(list1)..addAll(list2);
  }

  @override
  void onInit() {
    nextSevenDays();

    super.onInit();
  }
}