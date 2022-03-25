import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/controllers/registration_one_controller.dart';

class RegistrationTwoController extends GetxController {
  static RegistrationTwoController instance = Get.find();

  TextEditingController firstNameTextEditingController = TextEditingController();
  TextEditingController lastNameTextEditingController = TextEditingController();
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController dobTextEditingController = TextEditingController();
  TextEditingController locationEditingController = TextEditingController();
  //You didn't initiate the textController that's the reason the constructor wasn't working
  TextEditingController timeZoneEditingController = TextEditingController();


  List<String> phoneNumbers = [];

  final List<String> errors = [];
  String? email;
  String? password;
  String? phoneNumber;
  String? dateOfBirth;
  int? day;
  int? month;
  int? year;
  RxInt age = 0.obs;
  DateTime currentDate = DateTime.now();
  final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
  List<String> usernames = [];
  Map<dynamic, dynamic>? map;

  RxBool usernameExists = false.obs;


  @override
  void onInit() {
    super.onInit();

    print("USER_TYPE: ${onBoardingController.userType.value}");

    // locatePosition();
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ///Position to get user current position with geoLocator using latitude and longitude
  late Position currentPosition;
  late String country, currentLocation;

  var geoLocator = Geolocator(); // geoLocator is an instance of GeoLocator
  late List<Placemark> placemark;

  var now;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1970),
        lastDate: currentDate);
    if (pickedDate != null && pickedDate != currentDate) {
      day = pickedDate.day;
    }
    month = pickedDate!.month;
    year = pickedDate.year;
    day = pickedDate.day;
    age.value = currentDate.year - year!;

    if (month! > currentDate.month) {
      age.value--;
    } else if (month! == currentDate.month) {
      if (day! > currentDate.day) {
        age.value--;
      }
    }
    String formattedDOB = dateFormatter.format(pickedDate);
    dateOfBirth = formattedDOB.toString();
    dobTextEditingController.text = dateOfBirth ?? '';
  }

  //check if username exists in api path
  Future<String> checkForUsername() async {
    String url = baseUrl + ifUsernameExistsPath;

    try{
      var response = await post(Uri.parse(url),
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json",
          },
          body: json.encode({'username': userNameTextEditingController.text}));

      return json.decode(response.body)['message'];
    }catch (e) {
      //print();
      return "ERROR: "+e.toString();
    }
  }

  locatePosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      currentPosition = position;

      print(
          'LAT: ${currentPosition.latitude.toString()} \n LON: ${currentPosition.longitude.toString()}');

      placemark = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);

      var now = DateTime.now();

      String _printDuration(Duration duration) {
        String twoDigits(int n) => n.toString().padLeft(2, "0");
        String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
        return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
      }

      print(
          'GMT ${now.timeZoneOffset.isNegative ? '' : '+'}${_printDuration(now.timeZoneOffset)}');

      country = '${placemark[0].country}/${placemark[0].administrativeArea}';
      currentLocation =
      '$country/${placemark[0].locality}/${placemark[0].subLocality}/${placemark[0].name}';

      timeZoneEditingController.text =
      'GMT ${now.timeZoneOffset.isNegative ? '' : '+'}${_printDuration(now.timeZoneOffset)}';

      locationEditingController.text = country;
    } catch (e) {
      print('ERROR: ' + e.toString());
    }
  }

}