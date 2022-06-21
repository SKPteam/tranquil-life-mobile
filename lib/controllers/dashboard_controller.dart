// ignore_for_file: file_names, prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/journal_controller.dart';
import 'package:tranquil_life/pages/chat/chatroom.dart';
import 'package:tranquil_life/pages/home/home.dart';
import 'package:tranquil_life/pages/journal/journal_page.dart';
import 'package:tranquil_life/pages/profile/profile_page.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tranquil_life/pages/wallet/wallet_page.dart';
import 'package:tranquil_life/pages/profile/profile_page.dart';

import 'package:tranquil_life/routes/app_pages.dart';
import 'package:tranquil_life/helpers/constants.dart';

import '../main.dart';

class DashboardController extends GetxController {
  static DashboardController instance = Get.find();

  ValueNotifier<String> selectedMoodSvgUrl = ValueNotifier('');
  Timer? inactiveTimer;
  Timer? pausedTimer;
  RxList<Widget>? tabs = <Widget>[].obs;

  RxBool pageLoaded = RxBool(false);

  RxBool toggleValue = false.obs;

  RxBool locked = false.obs;

  RxString username = "".obs;
  RxString firstName = "".obs;
  RxString lastName = "".obs;
  RxString dob = "".obs;
  RxString pin = "".obs;
  RxString email = "".obs;
  RxString workPlace = "".obs;
  RxString discount = "".obs;
  RxString phoneNumber = "".obs;
  RxString gender = "".obs;
  RxString screenTimeoutPin = "".obs;
  RxString avatarUrl = "".obs;
  RxString latitude = "".obs;
  RxString longitude = "".obs;
  RxString onlineStatus = "".obs;
  RxString fcmToken = "".obs;
  RxString companyID = "".obs;
  RxString staffID = "".obs;
  RxString timeZone = "".obs;
  RxString bankName = "".obs;
  RxString bankAddress = "".obs;
  RxString homeAddress = "".obs;
  RxString swiftCode = "".obs;
  RxString workStatus = "".obs;
  RxString areasOfExpertise = "".obs;
  RxString yearsOfExperience = "".obs;
  RxString preferredLangs = "".obs;
  RxString fee = "".obs;
  RxString IBAN = "".obs;
  RxInt dayOfBirth = 0.obs;
  RxInt monthOfBirth = 0.obs;
  RxInt yearOfBirth = 0.obs;
  RxDouble balance = 0.0.obs;
  RxInt myTotalConsultations = 0.obs;
  RxInt myTotalConsultationsForThisMonthLength = RxInt(0);
  // late QuerySnapshot myTotalConsultationsForThisMonth;
  RxString accountNumber = "".obs;



  // update the latitude of the user
  setLatitude(value) {
    latitude.value = value;
    print("LAT: ${latitude.value}");
    update();
  }

  // update the longitude of the user
  setLongitude(value) {
    longitude.value = value;
    print("LONG: ${longitude.value}");

    update();
  }

  RxInt tabIndex = 0.obs;
  String? moodSelected;



  void selectedTab(int index) {
    tabIndex.value = index;
  }

  void selectedFab(int index) {
    tabIndex.value = index;
  }

  Widget tabView(){
    switch(tabIndex.value){
      case 1:
        return WalletView(reloadWalletPage: setBottomBarIndex);
      case 2:
        return JournalView(moodSvgUrl: moodSelected ?? "");
      case 3:
        return ProfileView(setBottomBarIndex: (int index) {});
      default:
        return Home(moodOnTap: setBottomBarIndex);
    }
  }

  void setBottomBarIndex(int index, [String? moodSvgUrl = ""]) {
    if (moodSvgUrl!.isNotEmpty) {
      selectedMoodSvgUrl.value = moodSvgUrl;
    } else {
      selectedMoodSvgUrl.value = '';
    }
    print('Changing Index');
    tabIndex.value = index;
  }


  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      pausedTimer = Timer(const Duration(seconds: 300), () {
        locked.value = true;
      });
    } else if (state == AppLifecycleState.resumed) {
      if (locked.value) {
        Get.to(Routes.TIMEOUT_SCREEN);
        // Navigator.of(Get.context!).push(MaterialPageRoute(
        //   builder: (context) => LockScreenView(
        //     goBack: true, ///TODO : While changing SecurityPinPage add go back from args
        //   ),
        // ));
      }
      pausedTimer?.cancel();
      inactiveTimer?.cancel();
    } else if (state == AppLifecycleState.inactive) {
      inactiveTimer = Timer(const Duration(seconds: 30), () {
        locked.value = true;
      });
      print('Inactive');
    } else if (state == AppLifecycleState.detached) {
      locked.value = true;
      inactiveTimer?.cancel();
      pausedTimer?.cancel();
    }
  }

  Future getUserProfile() async{

    var apiPath = sharedPreferences!.getString("userType")
        .toString() == client
        ? getClientProfilePath
        : getConsultantProfilePath;

    var url = baseUrl + apiPath;

    var response = await get(
        Uri.parse(url),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer ${sharedPreferences!.getString(
              "accessToken")}",
        });

    var body = jsonDecode(response.body);


    Future.delayed(Duration(seconds: 1), (){
      if(sharedPreferences!.getString("userType")
          .toString() == client)
      {
        firstName.value = body['f_name'];
        lastName.value = body['l_name'];
        username.value = body['username'];
        // gender = body['gender'];
        phoneNumber.value = body['phone'];
        // email = body['email'];
        // screenTimeoutPin = body['screen_timeout_pin'];
        // avatarUrl = body['avatar_url'];
        // latitude = body['latitude'];
        // longitude = body['longitude'];
        // onlineStatus = body['online_status'];
        // dayOfBirth = body['day_of_birth'];
        // monthOfBirth = body['month_of_birth'];
        // yearOfBirth = body['year_of_birth'];
        // fcmToken = body['fcm_token'];
        // companyID = body['company_id'];
        // staffID = body['staffID'];

        sharedPreferences!.setString("display_name", username.value);
      }
      else{
        firstName.value = body['f_name'];
        lastName.value = body['l_name'];
        // gender = body['gender'];
        phoneNumber.value = body['phone'];
        // email = body['email'];
        // screenTimeoutPin = body['screen_timeout_pin'];
        // avatarUrl = body['avatar_url'];
        // latitude = body['latitude'];
        // longitude = body['longitude'];
        // onlineStatus = body['online_status'];
        // dayOfBirth = body['day_of_birth'];
        // monthOfBirth = body['month_of_birth'];
        // yearOfBirth = body['year_of_birth'];
        // fcmToken = body['fcm_token'];
        // companyID = body['company_id'];
        // staffID = body['staffID'];

        username.value = body['f_name'];
        sharedPreferences!.setString("display_name", username.value);
      }

      return jsonDecode(response.body);
    });

  }



  @override
  void onInit() {
    super.onInit();
    getUserProfile();

    //WidgetsBinding.instance!.addObserver(this);
  }

}