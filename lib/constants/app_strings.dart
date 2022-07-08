// ignore_for_file: constant_identifier_names, prefer_const_constructors

import 'dart:math';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const String app_name = "Tranquil Life";

const String client = 'client';
const String consultant = 'consultant';

//CLOUDINARY
const String CLOUDINARY_NAME = "tranquil-life";
const String UPLOAD_PRESET = "ml_default";
const String CLOUDINARY_API_KEY = "552586961285433";

final _emailValidator = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

// Form Error
// final RegExp emailValidatorRegExp =
// RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp emailValidatorRegExp =
RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp passwordValidatorRegExp = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
const String kEmailNullError = "Please enter your email address";
const String kHeaderNullError = "Please enter your header";
const String kBodyNullError = "Please enter a message";
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

const PROFILE_PIC_STORAGE_PATH = "profile_pics";
const AUDIO_FILES_STORAGE_PATH = "audio_files";
const VIDEO_FILES_STORAGE_PATH = "video_files";
const IDENTITY_PIC_STORAGE_PATH = "identification_pics";
const CV_FILES_STORAGE_PATH = "cv_files";


const List payment_options = [
  "Your Tranquil Life Default Card",
  "Mobile Money Transfer",
  "A New Card",
  "Bank Transfer"
];


const List<String> months = [
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
const dayTimeList = ['06:00', '07:00', '08:00', '09:00', '10:00', '11:00', '12:00', '13:00',
  '14:00', '15:00', '16:00', '17:00'];
const nightTimeList = ['18:00', '19:00', '20:00', '21:00', '22:00', '23:00',
  '00:00', '01:00', '02:00', '03:00', '04:00', '05:00'];

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

var timeFormat = DateFormat('kk:mm');
var dateFormat = DateFormat('dd-MM-yyyy');

//provide the Paystack key here
//Live key
//var publicKey = 'pk_live_b52f8dfdae10acd0d8844ac2a135306ac4026c98';
//test key
var publicKey = 'pk_test_7c8a9567ff263e8c5ee4b464b385f0e667b205a2';

//the first parameter of the URI should be just the main URL, without http, any kind of special character like / or & or ?
//the seconnd paramter will be the endpoint path
//and the third paramter is a map of the different properties
final String forceUpdate = 'force_update';
final String shouldUpdateApp = 'update_app';
final String latestVersionCode = 'app_version_code';

const isAuthenticated = "User is authenticated";
const isNotAuthenticated = "User is not authenticated";

const baseUrl = "https://a336-168-253-119-198.eu.ngrok.io/api/";
//const baseUrl = "https://tranquil-api.herokuapp.com";

//Post Api paths
const clientRegisterPath = 'client/register';
const consultantRegisterPath = 'consultant/register';
const isConsultantAuthenticatedPath = 'consultant/isAuthenticated';
const loginPath = 'client/login';
const clientAddJournal = 'client/addNote';
const clientGetJournal = 'client/listNotes';
const ifUsernameExistsPath = 'client/ifUsernameExists';
const getStaffPath = 'client/showStaff';
const getStaffUsingEmailPath = 'client/showUsingEmail';
const createWalletPath = 'client/createWallet';
const ravePayPath = 'pay';
const addCardPath = 'client/addCard';
const setDefaultCardPath = 'client/setDefaultCard';
const bankTransferPath = 'transfer/pay';
const mobileMoneyTransferPath = 'transfer/flw';
const clientLogoutPath = 'client/logOut';
const consultantLogoutPath = 'consultant/logOut';


//Get Api Paths
const listCardsPath = 'client/listCards';
const getClientProfilePath = 'client/getProfile';
const getConsultantProfilePath = 'consultant/getProfile';
const getAllPartnersPath = 'client/listPartners';
const listQuestionsPath = 'client/listQuestions';
const getAllConsultantsPath = 'client/listConsultants';



