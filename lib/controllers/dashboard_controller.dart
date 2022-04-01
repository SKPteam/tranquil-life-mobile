// ignore_for_file: file_names, prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
import 'package:get_storage/get_storage.dart';

import 'package:tranquil_life/pages/wallet/wallet_page.dart';
import 'package:tranquil_life/pages/profile/profile_page.dart';

import 'package:tranquil_life/routes/app_pages.dart';
import 'package:tranquil_life/helpers/constants.dart';

import '../main.dart';

class DashboardController extends GetxController {

  //RxString userType = "".obs;
  String? userType;

  String? user;

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
  static DashboardController get to => Get.find();

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
  GetStorage? _getStorage;

  String? username,
      firstName,
      lastName,
      workPlace,
      discount,
      phoneNum,
      dob,
      gender,
      pin;
  RxDouble? balance;
  RxInt? myTotalConsultations;
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

  Future clientProfile() async{
    String url = baseUrl + getClientProfilePath;

    var response = await post(
        Uri.parse(url),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer ${sharedPreferences!.getString(
              "accessToken")}",
        });

    return jsonDecode(response.body);
  }

  @override
  void onInit() {
    super.onInit();
    clientProfile();

    //WidgetsBinding.instance!.addObserver(this);
  }

}