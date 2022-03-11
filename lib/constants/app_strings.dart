// ignore_for_file: constant_identifier_names, prefer_const_constructors

import 'dart:math';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const String app_name = "Tranquil Life";

const String client = 'client';
const String consultant = 'consultant';

// Form Error
final RegExp emailValidatorRegExp =
RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp passwordValidatorRegExp = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
const String kEmailNullError = "Please enter your email address";
const String kInvalidEmailError = "Please enter Valid Email";
const String kPassNullError = "Please enter your password";
const String kShortPassError = "Password is too short";
const String kInvalidPassError =
    "Password must be alphanumeric (e.g, myname@K18)";
const String kMatchPassError = "Passwords don't match";
const String kUserNameNullError = "Please enter your username";
const String kUserNameExists = "username already exists";
const String kPhoneNumberNullError = "Please enter your phone number";
const String kFirstNameNullError = "Please enter your first name";
const String kLastNameNullError = "Please enter your last name";
const String kAgeNullError = "Please enter your age";
const String kTooYoungError = "You must be 16 or above";
const String kLocationNullError = "Please enter your current location";
const String kCompanyNullError = "Please enter the company you work with";

const String userUID = 'uid';
const String userName = 'userName';
const String userEmail = 'email';
const String password = 'password';
const String userFirstName = 'firstName';
const String userLastName = 'lastName';
const String userAvatarUrl = 'avatarUrl';
const String userDOB = 'dateOfBirth';
const String userCountry = 'country';
const String userCurrentLocation = 'currentLocation';
const String userPhoneNum = 'phoneNumber';
const String userCardList = 'paymentCards';
const String userOnlineStatus = 'isOnline';
const String userPin = 'pin';
const String userTimeZone = 'timeZone';
const String userWorkPlace = 'workPlace';
const String userGender = 'gender';
const String userType = 'userType';
const String userStaffID = 'staffID';

const String userBankName = 'bankName';
const String userAccountNumber = 'accountNumber';

const String paymentCardList = 'paymentCards';
const String cardNumber = 'cardNumber';
const String cardOwner = 'cardOwner';
const String cardType = 'cardType';
const String cardExpiryDate = 'expiryDate';
const String cardCVV = 'cvv';
const String defaultCard = 'isDefault';

const String profit = "profit";
const String loss = "loss";

const String userJID = 'id';
const String userJHeading = 'heading';
const String userJBody = 'body';
const String userJMood = 'moodUrl';
const String userJDate = 'timestamp';

const List<int> top_up_figures = [1, 50, 150, 250, 500, 750, 900, 1500];

const List payment_options = [
  "Your Tranquil Life Default Card",
  "Mobile Money Transfer",
  "A New Card",
  "Bank Transfer"
];


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

//currencyconv api client
final Uri currencyURL = Uri.http("free.currconv.com", "/api/v7/currencies",
    {"apiKey": "36c7bbb929c685da0160"});

///FIREBASE MESSAGING SECTION
const String FCMtokenGetStoreConstant = 'FCMtoken';

/// Define agora App ID and Token
const APP_ID = 'a2782460e26a405cb9ffda0ae62e8038';
//const Token = '006a2782460e26a405cb9ffda0ae62e8038IABKW1P+6NvmO4XBVAnb7BW8zdOZAOPZtTdALbBTheP2ccJBJDUAAAAAEAAAQmFyH1e2YAEAAQAfV7Zg';

var uuid = Uuid();

const randomChars =
    'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890?@!#%&%^*';
Random rnd = Random();

RxString generatedPwd = RxString(" ");

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
//
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

const baseUrl = "http://2f97-102-89-32-47.ngrok.io";
//const baseUrl = "http://127.0.0.1:8000";
//const baseUrl = "https://tranquil-api.herokuapp.com";

//Post Api paths
const clientRegisterPath = '/api/client/register';
const loginPath = '/api/client/login';
const ifUsernameExistsPath = '/api/client/ifUsernameExists';
const getStaffPath = '/api/client/showStaff';
const getStaffUsingEmailPath = '/api/client/showUsingEmail';
const createWalletPath = '/api/client/createWallet';
const ravePayPath = '/api/pay';
const addCardPath = '/api/client/addCard';
const setDefaultCardPath = '/api/client/setDefaultCard';
const logoutPath = '/api/client/logout';


//Get Api Paths
const listCardsPath = '/api/client/listCards';
const getClientProfilePath = '/api/client/getProfile';
const getAllPartnersPath = '/api/client/listPartners';
const listQuestionsPath = '/api/client/listQuestions';


