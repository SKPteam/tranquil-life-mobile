// ignore_for_file: file_names, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
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

class DashboardController extends GetxController {

  RxString userType = "".obs;
  static DashboardController instance = Get.find();

  late PersistentTabController ptController;

  List<Widget> buildScreens() {

    return [
      Home(),
      WalletView(reloadWalletPage: setBottomBarIndex),
      ChatScreenPage(),
      JournalView(moodSvgUrl: '',),
      ProfileView(setBottomBarIndex: (int index) {}),

    ];
  }

  List<PersistentBottomNavBarItem> navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: active,
        inactiveColorPrimary: grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.account_balance_wallet),
        title: ("Wallet"),
        activeColorPrimary: active,
        inactiveColorPrimary: grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.chat_bubble),
        title: ("Chat"),
        activeColorPrimary: active,
        inactiveColorPrimary: grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.note),
        title: ("Journal"),
        activeColorPrimary: active,
        inactiveColorPrimary: grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: ("Profile"),
        activeColorPrimary: active,
        inactiveColorPrimary: grey,
      ),
    ];
  }

  RxInt currentIndex = RxInt(0);
  RxBool pageLoaded = RxBool(false);
  static DashboardController get to => Get.find();
  void setBottomBarIndex(int index, [String? moodSvgUrl = '']) {
    if (moodSvgUrl!.isNotEmpty) {
      selectedMoodSvgUrl.value = moodSvgUrl;
    } else {
      selectedMoodSvgUrl.value = '';
    }
    print('Changing Index');
    currentIndex.value = index;
  }

  ValueNotifier<String> selectedMoodSvgUrl = ValueNotifier('');
  Timer? inactiveTimer;
  Timer? pausedTimer;
  RxList<Widget>? tabs = <Widget>[].obs;
  GetStorage? _getStorage;

  RxString? username,
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

  displaySnackBar(String message, BuildContext context) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
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

  @override
  void onInit() {
    super.onInit();
    ptController = PersistentTabController(initialIndex: 0);
    userType = "client".obs;
    //WidgetsBinding.instance!.addObserver(this);

    //WidgetsBinding.instance!.addObserver(this);
  }


}