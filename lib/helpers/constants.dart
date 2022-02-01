// ignore_for_file: prefer_const_declarations

import 'dart:core';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';



const kAnimationDuration = Duration(milliseconds: 200);

const List<int> top_up_figures = [50, 150, 250, 500, 750, 900, 1500];

const List<String> monthsFromIndex = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];
const days = ['Mon', 'Tue', 'Wed', 'Thurs', 'Fri', 'Sat', 'Sun'];



// Form Error
// final RegExp emailValidatorRegExp =
// RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
//final RegExp passwordValidatorRegExp = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
//const String kEmailNullError = "Please enter your email address";
// const String kInvalidEmailError = "Please enter Valid Email";
// const String kPassNullError = "Please enter your password";
// const String kShortPassError = "Password is too short";
// const String kInvalidPassError =
//     "Password must be alphanumeric (e.g, myname@K18)";
// const String kMatchPassError = "Passwords don't match";
// const String kUserNameNullError = "Please enter your username";
// const String kUserNameExists = "Username exists";
// const String kPhoneNumberNullError = "Please enter your phone number";
// const String kFirstNameNullError = "Please enter your first name";
// const String kLastNameNullError = "Please enter your last name";
// const String kAgeNullError = "Please enter your age";
// const String kTooYoungError = "You must be 16 or above";
// const String kLocationNullError = "Please enter your current location";
// const String kCompanyNullError = "Please enter the company you work with";
//
// const String userUID = 'uid';
// const String userName = 'userName';
// const String userEmail = 'email';
// const String password = 'password';
// const String userFirstName = 'firstName';
// const String userLastName = 'lastName';
// const String userAvatarUrl = 'avatarUrl';
// const String userDOB = 'dateOfBirth';
// const String userCountry = 'country';
// const String userCurrentLocation = 'currentLocation';
// const String userPhoneNum = 'phoneNumber';
// const String userCardList = 'paymentCards';
// const String userOnlineStatus = 'isOnline';
// const String userPin = 'pin';
// const String userTimeZone = 'timeZone';
// const String userWorkPlace = 'workPlace';
// const String   = 'gender';
// const String userType = 'userType';
// const String userStaffID = 'staffID';
//
// const String userBankName = 'bankName';
// const String userAccountNumber = 'accountNumber';
//
// const String paymentCardList = 'paymentCards';
// const String cardNumber = 'cardNumber';
// const String cardOwner = 'cardOwner';
// const String cardType = 'cardType';
// const String cardExpiryDate = 'expiryDate';
// const String cardCVV = 'cvv';
// const String defaultCard = 'isDefault';
//
// const String businessProfit = "profit";
// const String businessLoss = "loss";

//provide the Paystack key here
//Live key
//var publicKey = 'pk_live_b52f8dfdae10acd0d8844ac2a135306ac4026c98';
//test key
var publicKey = 'pk_test_7c8a9567ff263e8c5ee4b464b385f0e667b205a2';

//currencyconv api client
final Uri currencyURL = Uri.http("free.currconv.com", "/api/v7/currencies",
    {"apiKey": "36c7bbb929c685da0160"});
//the first parameter of the URI should be just the main URL, without http, any kind of special character like / or & or ?
//the seconnd paramter will be the endpoint path
//and the third paramter is a map of the different properties
final String forceUpdate = 'force_update';
final String shouldUpdateApp = 'update_app';
final String latestVersionCode = 'app_version_code';

//var uuid = Uuid();
const List<String> monthsInString = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];
const String userJID = 'id';
const String userJHeading = 'heading';
const String userJBody = 'body';
const String userJMood = 'moodUrl';
const String userJDate = 'timestamp';

///FIREBASE MESSAGING SECTION
const String FCMtokenGetStoreConstant = 'FCMtoken';

/// Define agora App ID and Token
const APP_ID = 'a2782460e26a405cb9ffda0ae62e8038';
//const Token = '006a2782460e26a405cb9ffda0ae62e8038IABKW1P+6NvmO4XBVAnb7BW8zdOZAOPZtTdALbBTheP2ccJBJDUAAAAAEAAAQmFyH1e2YAEAAQAfV7Zg';
var uuid = Uuid();

//twilio
const accountSSID = 'AC5f2a27e9c114942c27af1ff78c611c89';
const authToken = '5bb1c682f996c1030b95740a1a4b2b26';
const twilioNumber = '+12055093678';

//braintree gateway
const sandboxToken = 'sandbox_tv7f753t_nrvd7g4j7xwdmf4f';

const _chars =
    'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890?@!#%&%^*';
Random _rnd = Random();

RxString generatedPwd = RxString(" ");

showMessageDialog(String message, BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
        );
      });
}

showLoaderDialog(BuildContext context) {
  SimpleDialog alert = SimpleDialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Center(
      child: Container(
        height: 40,
        width: 40,
        child: CircularProgressIndicator(),
      ),
    ),
  );
  showDialog(
    barrierDismissible: false,
    barrierColor: Colors.black38,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

///returns a dynamic linking url as URI object, which is created when this function is called
///[urlToLink] is the parameter that takes in the url that has to be converted into dynamic link
///[short] is a boolean parameter used to return either a shortened uri or the long uri
// Future<Uri> createDynamicLink(
//     {required String urlToLink, required bool short}) async {
//   final DynamicLinkParameters parameters = DynamicLinkParameters(
//     uriPrefix: 'https://cx4k7.app.goo.gl',
//     link: Uri.parse('$urlToLink'),
//     androidParameters: AndroidParameters(
//       packageName: 'io.flutter.plugins.firebasedynamiclinksexample',
//       minimumVersion: 0,
//     ),
//     dynamicLinkParametersOptions: DynamicLinkParametersOptions(
//       shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
//     ),
//     iosParameters: IosParameters(
//       bundleId: 'com.google.FirebaseCppDynamicLinksTestApp.dev',
//       minimumVersion: '0',
//     ),
//   );

//   Uri url;
//   if (short) {
//     final ShortDynamicLink shortLink = await parameters.buildShortLink();
//     url = shortLink.shortUrl;
//   } else {
//     url = await parameters.buildUrl();
//   }
//   return url;
// }

var timeFormat = DateFormat('kk:mm');
var dateFormat = DateFormat('dd-MM-yyyy');
