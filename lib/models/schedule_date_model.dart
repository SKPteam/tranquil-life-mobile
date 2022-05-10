import 'package:tranquil_life/constants/app_strings.dart';

///Model for a Schedule containing a [weekDay] such as MON, TUE, etc
///and a [date] in int
// ignore_for_file: file_names

class Schedule {
  final DateTime dateTime;
  String weekDay = "";

  Schedule(this.dateTime) {
    weekDay = days[dateTime.weekday - 1];
  }

}