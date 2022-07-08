import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:tranquil_life/main.dart';

import '../constants/style.dart';
import '../general_widgets/custom_snackbar.dart';


class RegistrationTwoController extends GetxController {
  static RegistrationTwoController instance = Get.find();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey <FormState>();


  TextEditingController firstNameTextEditingController = TextEditingController(text: "ddkd");
  TextEditingController lastNameTextEditingController = TextEditingController(text: "ffsf");
  TextEditingController userNameTextEditingController = TextEditingController(text: "djjff");
  TextEditingController dobTextEditingController = TextEditingController();
  TextEditingController locationEditingController = TextEditingController();
  //You didn't initiate the textController that's the reason the constructor wasn't working
  TextEditingController timeZoneEditingController = TextEditingController();
  TextEditingController passportOrDriverTEC = TextEditingController();
  TextEditingController resumeTEC = TextEditingController();

  // fields for passport and resumé/cv
  File? passportImageFile;
  File? cvFile;

  RxString passportPath = "".obs;
  RxString cvPath = "".obs;

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
  File? imageFile;
  CloudinaryResponse? passportResponse;
  CloudinaryResponse? cvResponse;

  RxDouble passportUploadPercentage = 0.0.obs;
  RxDouble cvUploadPercentage = 0.0.obs;

  ///Position to get user current position with geoLocator using latitude and longitude
  late Position currentPosition;
  late String country, currentLocation;

  var geoLocator = Geolocator(); // geoLocator is an instance of GeoLocator
  //late List<Placemark> placemark;

  @override
  void onInit() {
    super.onInit();

    print("USER_TYPE: ${onBoardingController.userType.value}");

    // locatePosition();
  }

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


  // locatePosition() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.best);
  //     currentPosition = position;
  //
  //     print(
  //         'LAT: ${currentPosition.latitude.toString()} \n LON: ${currentPosition.longitude.toString()}');
  //
  //     placemark = await placemarkFromCoordinates(
  //         currentPosition.latitude, currentPosition.longitude);
  //
  //     var now = DateTime.now();
  //
  //     String _printDuration(Duration duration) {
  //       String twoDigits(int n) => n.toString().padLeft(2, "0");
  //       String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  //       return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
  //     }
  //
  //     print(
  //         'GMT ${now.timeZoneOffset.isNegative ? '' : '+'}${_printDuration(now.timeZoneOffset)}');
  //
  //     country = '${placemark[0].country}/${placemark[0].administrativeArea}';
  //     currentLocation =
  //     '$country/${placemark[0].locality}/${placemark[0].subLocality}/${placemark[0].name}';
  //
  //     timeZoneEditingController.text =
  //     'GMT ${now.timeZoneOffset.isNegative ? '' : '+'}${_printDuration(now.timeZoneOffset)}';
  //
  //     locationEditingController.text = country;
  //   } catch (e) {
  //     print('ERROR: ' + e.toString());
  //   }
  // }

}


// Reference identityStorageRef = FirebaseStorage.instance
//     .ref()
//     .child(IDENTITY_PIC_STORAGE_PATH)
//     .child(basename(registrationTwoController.passportPath.value));
// UploadTask identityUploadTask =
// identityStorageRef.putFile(File(registrationTwoController.passportPath.value));

// Reference cvStorageRef = FirebaseStorage.instance
//     .ref()
//     .child(CV_FILES_STORAGE_PATH)
//     .child(basename(registrationTwoController.cvPath.value));
// UploadTask cvUploadTask =
// cvStorageRef.putFile(File(registrationTwoController.cvPath.value));

// List files = await Future.wait<String>([
//   _uploadTaskNextStep(identityUploadTask, identityStorageRef),
//   _uploadTaskNextStep(cvUploadTask, cvStorageRef),
// ]).catchError((error) {
//   CustomLoader.cancelDialog();
//   // display error message
//   CustomSnackBar.showSnackBar(
//       context: Get.context,
//       title: "An error occurred",
//       message: error.toString(),
//       backgroundColor: active);
// });
//
// passportURL.value = "${files[0]}";
// cvURL.value = "${files[1]}";