import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/helpers/constants.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';

// ignore_for_file: avoid_print

//import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

//  import_of_legacy_library_into_null_safe

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:language_picker/languages.dart';
import 'package:language_picker/language_picker.dart';
import 'package:tranquil_life/models/company.dart';
import 'package:tranquil_life/routes/app_pages.dart';

// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';



class ClientRegistrationController extends GetxController{
  static ClientRegistrationController instance = Get.find();

  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890?@!#%&%^*';
  final Random _rnd = Random();

  Map data = {};

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneNumTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPwdTextEditingController = TextEditingController();

  // client registration_two
  TextEditingController firstNameTextEditingController =
  TextEditingController();
  TextEditingController lastNameTextEditingController = TextEditingController();
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController dobTextEditingController = TextEditingController();
  TextEditingController locationEditingController = TextEditingController();
  //You didn't initiate the textController that's the reason the constructor wasn't working
  TextEditingController timeZoneEditingController = TextEditingController();

  // client registration three
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController companyEditingController = TextEditingController();
  Rx<TextEditingController> staffIDEditingController =
      TextEditingController().obs;
  TextEditingController areaOfExpertiseTEC = TextEditingController();
  TextEditingController yearsOfExpTEC = TextEditingController();
  TextEditingController preferredLangTEC = TextEditingController();

  // client registration four
  TextEditingController accountNameTEC = TextEditingController();
  TextEditingController homeAddressTEC = TextEditingController();
  TextEditingController bankNameTEC = TextEditingController();
  TextEditingController bankAddressTEC = TextEditingController();
  TextEditingController ibanTextEditingController = TextEditingController();
  TextEditingController swiftCodeTEC = TextEditingController();


  String? countryCode;
  String email = 'email';
  String password = 'password';
  RxString userType = RxString('');
  RxString generatedPwd = RxString('');
  RxBool obscureText = RxBool(true);

  /*............................................*/
  void togglePassword() {
    obscureText.value = !obscureText.value;
  }
  void onPressed(String pwdValue) {
    passwordTextEditingController = TextEditingController(text: pwdValue);
    confirmPwdTextEditingController = TextEditingController(text: "");
  }

  String getRandomPwd(int length)
  => String.fromCharCodes(
      Iterable.generate(
          length,
              (_) =>
              _chars.codeUnitAt(_rnd.nextInt(_chars.length))
      ));

  displaySnackBar(String message, BuildContext context) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(message,
              style: TextStyle(
                  fontSize: displayWidth(Get.context!) / 30
              ),),
            duration: const Duration(seconds: 2),
            action: message == kInvalidPassError
                ?
            SnackBarAction(
              label: "Generate",
              onPressed: () {
                print(getRandomPwd(12));
                generatedPwd.value = getRandomPwd(12);
                passwordTextEditingController.text = generatedPwd.value;
              },
            ) : null
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  /*............................................*/

  String newClientEmailTemplate = "";
  String companyName = "";
  String companyID = "";
  //String userType = "";
  String myLocation = "";
  RxBool orgSelected = false.obs;

  String staffID = "";

  //Position to get user current position with geoLocator using latitude and longitude
  Position? currentPosition;
  RxString country = "".obs;
  RxString currentLocation = RxString('');
  RxString selectedWorkStatus = "Self-employed".obs;

  var geoLocator = Geolocator(); // geoLocator is an instance of GeoLocator
  List<Placemark>? placemark;

  List<String> langArray = [];
  List<String> aoeArray = [];
  List<String> areaOfExpertiseList = [];
  List<String> yearsOfExperienceList = [];
  List<String> workStatusList = ['Self-employed', 'Employed'];

  //COMPANY LIST SETUP METHOD


  // void getAllEnrolledCompanies() async {
  //   QuerySnapshot queryCompanyDocs = await enrolledCompaniesRef!.get();
  //   if (queryCompanyDocs.docs.isNotEmpty) {
  //     for (var i = 0; i < queryCompanyDocs.docs.length; i++) {
  //       var companyDoc = queryCompanyDocs.docs[i].data() as Map;
  //       print(companyDoc['name']);
  //       companyList.add(Company(
  //         id: companyDoc['id'],
  //         name: companyDoc['name'],
  //         logo: companyDoc['logo'],
  //       ));
  //     }
  //   }
  // }

  onTapCompanyCard(Company company) async {
    companyID = company.id;
    companyName = company.name;
    companyEditingController.text = companyName;

    if (companyEditingController.text == 'None') {
      orgSelected.value = false;
      Get.back();
    }
  }

  Map mapData = {};




  //Display list of organisation
  // void ShowModalBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
  //       ),
  //       builder: (BuildContext context) {
  //         return Container(
  //             height: 300,
  //             decoration: const BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.only(
  //                 topLeft: Radius.circular(20),
  //                 topRight: Radius.circular(20),
  //               ),
  //             ),
  //             child: SizedBox(
  //               height: displayHeight(context) * 0.08,
  //               child: Column(
  //                 children: [
  //                   Expanded(
  //                     child: ListView.builder(
  //                         scrollDirection: Axis.horizontal,
  //                         itemCount: companyList.length,
  //                         itemBuilder: (BuildContext context, int index) =>
  //                             buildCompanyCard(context, index)),
  //                   )
  //                 ],
  //               ),
  //             ));
  //       });
  // }

  // Future<void> registerNewClient(BuildContext context) async {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return const ProgressDialog(message: 'Registering, Please wait...');
  //       });
  //
  //   User? firebaseUser;
  //   await auth!
  //       .createUserWithEmailAndPassword(
  //       email: emailTextEditingController.text.trim(),
  //       password: passwordTextEditingController.text.trim())
  //       .then((auth) {
  //     firebaseUser = auth.user!;
  //   }).catchError((errMsg) {
  //     Get.back();
  //     displaySnackBar("Error: " + errMsg.toString(), context);
  //   });
  //
  //   if (firebaseUser != null) //user created
  //       {
  //     //Save info to firebase realtime database
  //     saveUserInfoToFirebaseDatabase(firebaseUser!).then((value) => {
  //       Get.back(),
  //       Navigator.pushNamedAndRemoveUntil(
  //           context, Routes.SIGN_IN, (route) => false)
  //     });
  //   } else {
  //     Navigator.pop(context);
  //     //error occured - display error msg
  //
  //     displaySnackBar('New user account has not been created.', context);
  //   }
  // }

  ///SAVE NEW USER TO DATABASE
  // Future saveUserInfoToFirebaseDatabase(User firebaseUser) async {
  //   var getStorage = GetStorage();
  //
  //   double balance = 0;
  //
  //   Map userDataMap = {
  //     userUID: firebaseUser.uid,
  //     userEmail: EncryptionHelper.handleEncryption(emailTextEditingController.text.trim()),
  //     FCMtokenGetStoreConstant: getStorage.read(FCMtokenGetStoreConstant) == null
  //         ? ''
  //         : EncryptionHelper.handleEncryption(getStorage.read(FCMtokenGetStoreConstant)),
  //   };
  //   Map userAccountDataMap = {
  //     //user id (no encryption)
  //     userUID: firebaseUser.uid,
  //     //First name
  //     userFirstName: EncryptionHelper.handleEncryption(firstNameTextEditingController.text.trim()),
  //     //Last Name
  //     userLastName: EncryptionHelper.handleEncryption(lastNameTextEditingController.text.trim()),
  //     //Username
  //     userName: EncryptionHelper.handleEncryption(userNameTextEditingController.text.trim()),
  //     //Date of Birth
  //     userDOB: EncryptionHelper.handleEncryption(dobTextEditingController.text.trim()),
  //     //Staff ID
  //     userStaffID: staffIDEditingController
  //         .value.text.isEmpty
  //         ? ""
  //         : EncryptionHelper.handleEncryption(staffIDEditingController.value.text.trim()),
  //     //Current Location
  //     userCurrentLocation: currentLocation.isEmpty
  //         ? ""
  //         : EncryptionHelper.handleEncryption(myLocation),
  //     //Timezone
  //     userTimeZone: Get
  //         .find<RegistrationTwoController>()
  //         .timeZoneEditingController
  //         .text.isEmpty
  //         ? ""
  //         : EncryptionHelper
  //         .handleEncryption(
  //         Get.find<RegistrationTwoController>()
  //             .timeZoneEditingController.text),
  //     //Phone number
  //     userPhoneNum: EncryptionHelper
  //         .handleEncryption(Get.find<RegistrationOneController>()
  //         .phoneNumTextEditingController.text.trim()),
  //     //User's pin
  //     userPin: "",
  //     //User's online status
  //     userOnlineStatus: false,
  //     //User avatar url
  //     userAvatarUrl: '',
  //     //User's work-place
  //     userWorkPlace: EncryptionHelper
  //         .handleEncryption(companyEditingController.text.trim()),
  //     //Type of user (client or consultant)
  //     "userType": EncryptionHelper
  //         .handleEncryption(userType),
  //     //total number of consultations
  //     'totalConsultations': EncryptionHelper.handleEncryption(0.toString()),
  //     //date account was created (no encryption)
  //     'date_created': DateTime.now().toUtc().millisecondsSinceEpoch,
  //     //wallet balance
  //     userGender:"",
  //     'balance': EncryptionHelper
  //         .handleEncryption(balance.toString()),
  //     //subscribed for newsletters
  //     'subscribedForNewsletters': true
  //   };
  //
  //   usersRef!
  //       .child("clients")
  //       .child(firebaseUser.uid)
  //       .set(userDataMap)
  //       .whenComplete(() {
  //     accountSettingsRef!.child(firebaseUser.uid).set(userAccountDataMap);
  //     //sendMail(controller);
  //   }).whenComplete(
  //         () => displaySnackBar('Account created successfully!', Get.context!),
  //   );
  // }


  List<String> phoneNumbers = [];

  final List<String> errors = [];
  // String? email;
  // String? password;
  String? phoneNumber;
  String? dateOfBirth;
  int? day;
  int? month;
  int? year;
  late RxInt age;
  DateTime currentDate = DateTime.now();
  final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
  List<String> usernames = [];
  Map<dynamic, dynamic>? map;



  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ///Position to get user current position with geoLocator using latitude and longitude
  //late Position currentPosition;
  //late String country, currentLocation;

  //var geoLocator = Geolocator(); // geoLocator is an instance of GeoLocator
  //late List<Placemark> placemark;

  var now;

  void getClientUserNames() {
    // accountSettingsRef!.once().then((DataSnapshot snapshot) {
    //   map = snapshot.value;
    //
    //   map!.forEach((key, values) {
    //     usernames.add(values[userName]);
    //     print(usernames);
    //   });
    // });
  }

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
    String formattedDOB = dateFormatter.format(pickedDate);
    dateOfBirth = formattedDOB.toString();
    dobTextEditingController.text = dateOfBirth ?? '';
    // });
  }

  String getAge() {
    age = RxInt(currentDate.year - year!);
    return age.value.toString();
  }

  getPhoneNumbers() {
    // accountSettingsRef!.once().then((DataSnapshot snapshot) {
    //
    //   if(snapshot.value != null){
    //     map = snapshot.value;
    //
    //     map!.forEach((key, values) {
    //       phoneNumbers.add(values[userPhoneNum]);
    //       print(phoneNumbers);
    //     });
    //   }
    // });
  }
  // already defined
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





  /*........................*/



  @override
  void onInit() {
    super.onInit();
    //userType = userType.value;
    staffID = staffIDEditingController.value.toString();

    emailTextEditingController = emailTextEditingController;
    passwordTextEditingController = passwordTextEditingController;
    firstNameTextEditingController = firstNameTextEditingController;
    lastNameTextEditingController = lastNameTextEditingController;
    phoneTextEditingController = TextEditingController(text: phoneNumber);
    userNameTextEditingController =
    userType.value == client
        ?
    userNameTextEditingController
        :
    TextEditingController(text: "");
    dobTextEditingController = TextEditingController(text: dateOfBirth);

    print(
        "FIRST NAME: ${firstNameTextEditingController.text}, D.O.B: ${dobTextEditingController.text}");

    //locatePosition();
    // getAllEnrolledCompanies();
    // getConsltRegDataFromDatabase();

    print(passwordTextEditingController.text);

    getPhoneNumbers();

    print(
        "EMAIL: $email\n"
            "PHONE NUMBER: $phoneNumber\n"
            "PASSWORD: $password\n"
            "FIRST NAME: ${firstNameTextEditingController.text}\n"
            "LAST NAME: ${lastNameTextEditingController.text}\n"
            "CURRENT LOCATION: $currentLocation\n"
            "DATE OF BIRTH: $dateOfBirth\n"
            "TIMEZONE: ${timeZoneEditingController.text}\n"
            "COMPANY: ${companyEditingController.text}\n"
            "AREA OF EXPERTISE: ${areaOfExpertiseTEC.text.replaceAll(',', ' |')}\n"
            "YEARS OF EXPERIENCE: ${yearsOfExpTEC.text}\n"
            "PREFERRED LANGUAGES: ${preferredLangTEC.text.replaceAll(',', ' |')}\n"
    );
  }
}


