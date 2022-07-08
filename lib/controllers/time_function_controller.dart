import 'package:intl/intl.dart';
import 'package:tranquil_life/constants/app_strings.dart';

class TimeManipulativeHelperController {
  static TimeManipulativeHelperController get instance =>
      TimeManipulativeHelperController();
  NumberFormat formatter = NumberFormat("00");

  ///convert time from DateTime type to a String with format as
  ///MONTH DAY, YEAR i.e April 25, 2021
  String convertTimeToMDY(DateTime? time) {
    String month = months[time!.month - 1];
    String day = time.day.toString();
    String year = time.year.toString();
    return '$month $day, $year';
  }

  // DateTime convertFromHourToTime(String hour,
  //     {bool utc = false, DateTime? now}) {
  //   now ??= DateTime.now();
  //
  //   var amOrPm = hour.substring(hour.length - 2);
  //   var hourAndMinutes = hour.substring(0, hour.length - 2).split(':');
  //   int hours = int.parse(hourAndMinutes[0]);
  //   int minutes = int.parse(hourAndMinutes[1]);
  //   if (amOrPm.toLowerCase() == 'pm') {
  //     hours = hours + 12;
  //     if (hours == 24) {
  //       hours = 12;
  //     }
  //   } else {
  //     if (hours == 12) {
  //       hours = 0;
  //     }
  //   }
  //   if (utc) {
  //     return DateTime.utc(now.year, now.month, now.day, hours, minutes);
  //   }
  //   return DateTime(now.year, now.month, now.day, hours, minutes);
  // }
  //
  // DateTime convertFromHourToTimepart2(String hour, {bool utc = false}) {
  //   DateTime? now;
  //
  //   now ??= DateTime.now();
  //
  //   var hourAndMinutes = hour.split(':');
  //   int hours = int.parse(hourAndMinutes[0]);
  //   int minutes = int.parse(hourAndMinutes[1]);
  //   if (utc) {
  //     return DateTime.utc(now.year, now.month, now.day, hours, minutes);
  //   }
  //   return DateTime(now.year, now.month, now.day, hours, minutes);
  // }
  //
  // String convertFromTimeToHour(DateTime time) {
  //   return DateFormat('hh:mm a').format(time);
  // }
  //
  // String convertFromHourToUTCHour(String hour) {
  //   var time = convertFromHourToTime(hour, now: null).toUtc();
  //   return convertFromTimeToHour(time);
  // }
  //
  // String convertFromHourToUTCHourpart2(String hour, {DateTime? now}) {
  //   var time = convertFromHourToTime(hour, now: now).toUtc();
  //   return DateFormat('kk:mm').format(time);
  // }
  //
  // DateTime convertFromHourToUTCTime(String hour,
  //     {required DateTime selectedDate}) {
  //   return convertFromHourToTime(hour, now: selectedDate).toUtc();
  // }
  //
  // String convertFromUTCHourToHour(String hour) {
  //   var time = convertFromHourToTime(hour, utc: true, now: null).toLocal();
  //   return convertFromTimeToHour(time);
  // }
  //
  // DateTime convertFromUTCHourToHourpart2(String hour) {
  //   var time = convertFromHourToTimepart2(hour, utc: true).toLocal();
  //   return time;
  // }
}