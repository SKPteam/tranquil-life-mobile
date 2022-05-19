// ignore_for_file: file_names, prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
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
  RxString userType = ''.obs;

  static DashboardController instance = Get.find();

  RxBool toggleValue = false.obs;

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


  //RxInt currentIndex = RxInt(0);
  RxBool pageLoaded = RxBool(false);
  //static DashboardController get to => Get.find();

  void setBottomBarIndex(int index, [String? moodSvgUrl = ""]) {
    if (moodSvgUrl!.isNotEmpty) {
      selectedMoodSvgUrl.value = moodSvgUrl;
    } else {
      selectedMoodSvgUrl.value = '';
    }
    print('Changing Index');
    tabIndex.value = index;
  }

  ValueNotifier<String> selectedMoodSvgUrl = ValueNotifier('');
  Timer? inactiveTimer;
  Timer? pausedTimer;
  RxList<Widget>? tabs = <Widget>[].obs;


  RxString username = "".obs;
  RxString firstName = "".obs;
  RxString lastName = "".obs;
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
  RxInt dayOfBirth = 0.obs;
  RxInt monthOfBirth = 0.obs;
  RxInt yearOfBirth = 0.obs;
  RxDouble balance = 0.0.obs;
  RxInt myTotalConsultations = 0.obs;
  RxInt myTotalConsultationsForThisMonthLength = RxInt(0);
  // late QuerySnapshot myTotalConsultationsForThisMonth;

  RxString accountNumber = "".obs;
  RxString bankName = "".obs;

  RxBool locked = false.obs;


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

  Future userProfile() async{
    String url = baseUrl + getClientProfilePath;

    var response = await get(
        Uri.parse(url),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer ${sharedPreferences!.getString(
              "accessToken")}",
        });

    var body = jsonDecode(response.body);

    if(body['username'] == null){
      userType.value = consultant;
      //sharedPreferences!.setString('username', body['f_name'] + body['l_name']);
    }else{
      userType.value = client;
      //sharedPreferences!.setString('username', body['username']);

    }

    Future.delayed(Duration(seconds: 1), (){
      firstName = body['f_name'];
      lastName = body['l_name'];
      username.value = body['username'];
      // gender = body['gender'];
      // phoneNumber = body['phone'];
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

      print(jsonDecode(response.body).toString());
      print(sharedPreferences!.getString("accessToken"));

      return jsonDecode(response.body);

    });

  }

  @override
  void onInit() {
    super.onInit();
    userProfile();

    print("YESS!!!");

    //WidgetsBinding.instance!.addObserver(this);
  }

}