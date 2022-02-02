// ignore_for_file: file_names, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/pages/home/home.dart';
import 'package:tranquil_life/pages/profile/profile_page.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:tranquil_app/app/modules/home/home_view.dart';
import 'package:tranquil_app/app/modules/journal/journal_view.dart';
import 'package:tranquil_app/app/modules/profile/profile_view.dart';
import 'package:tranquil_life/pages/wallet/wallet_page.dart';
import 'package:tranquil_life/pages/profile/profile_page.dart';

import 'package:tranquil_life/routes/app_pages.dart';
import 'package:tranquil_life/helpers/constants.dart';

class DashboardController extends GetxController {
  static DashboardController instance = Get.find();

  late PersistentTabController ptController;

  List<Widget> buildScreens() {

    return [
      Home(),
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
  RxString? userType;
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
  late QuerySnapshot myTotalConsultationsForThisMonth;

  RxString accountNumber = "".obs;
  RxString bankName = "".obs;

  RxBool locked = false.obs;

  void getTotalConsultatnsforThisMonth() async {
    final _today = DateTime.now().toUtc();
    final _monthStart = DateTime(_today.year, _today.month).toUtc();
    final _monthend = DateTime(
        _today.month == 12 ? _today.year + 1 : _today.year,
        _today.month == 12 ? 1 : _today.month + 1)
        .toUtc();

    myTotalConsultationsForThisMonth = await consultationsRef!
        .where('consultantID', isEqualTo: auth!.currentUser!.uid)
        .where('startingTime',
        isGreaterThan: _monthStart.millisecondsSinceEpoch,
        isLessThan: _monthend.millisecondsSinceEpoch)
        .get();

    myTotalConsultationsForThisMonthLength.value =
        myTotalConsultationsForThisMonth.docs.length;
  }

  checkAuthState() async {
    _getStorage = GetStorage();
    if (auth!.currentUser != null) {
      //added await as it is asynchronous method of accessing data
      await accountSettingsRef!
          .child(auth!.currentUser!.uid)
          .once()
          .then((snapshot) {
        if (snapshot.value != null) {
          _getStorage!.write(
              userAvatarUrl,
              snapshot.value[userAvatarUrl].toString().isEmpty
                  ? ""
                  : EncryptionHelper.handleDecryption(snapshot.value[userAvatarUrl]).toString());
          userType = RxString(EncryptionHelper.handleDecryption(snapshot.value['userType']).toString());
          username = RxString(EncryptionHelper.handleDecryption(snapshot.value[userName]).toString());
          firstName = RxString(EncryptionHelper.handleDecryption(snapshot.value[userFirstName]).toString());
          lastName = RxString(EncryptionHelper.handleDecryption(snapshot.value[userLastName]).toString());
          phoneNum = RxString(EncryptionHelper.handleDecryption(snapshot.value[userPhoneNum]).toString());
          dob = RxString(EncryptionHelper.handleDecryption(snapshot.value[userDOB]).toString());
          gender = RxString(
              snapshot.value[userGender].toString().isEmpty
                  ? ""
                  : EncryptionHelper.handleDecryption(snapshot.value[userGender]).toString());
          pin = RxString(EncryptionHelper.handleDecryption(snapshot.value["pin"]).toString());
          balance =
              RxDouble(double.parse(EncryptionHelper.handleDecryption(snapshot.value["balance"]).toString()));
          workPlace = RxString(EncryptionHelper.handleDecryption(snapshot.value[userWorkPlace]).toString());

          // userType == consultant
          //     ? accountSettingsRef!
          //         .child(auth!.currentUser!.uid)
          //         .child("profile")
          //         .once()
          //         .then((ds) {
          //         myTotalConsultations = RxInt(ds.value["totalConsultations"]);
          //       })
          //     : myTotalConsultations =
          //         RxInt(snapshot.value["totalConsultations"]);
          getTotalConsultatnsforThisMonth();
          print('AUth State in Dashboard');
          DynamicLinkHelper.handleDynamicLinks();
          print(userType!.value);
        } else {
          displaySnackBar('Error: User account settings details doesn\'t exist',
              Get.context!);
        }
      });
    } else {
      PushNotificationHelperController.instance
          .updateTokenAfterSigningOut(auth!.currentUser!.uid);
      auth!.signOut();
      Navigator.pushNamedAndRemoveUntil(
          Get.context!, Routes.SPLASH_SCREEN, (route) => false);
    }
    print(userType!.value);
    //since await is used above, only after executing the THEN part of the above statement
    //this variable assignment will be executed
    tabs!.value = [
      //Homepage
      HomeView(moodOnTap: setBottomBarIndex),
      //WalletPage
      WalletView(reloadWalletPage: setBottomBarIndex),
      // //Journal
      ValueListenableBuilder(
        valueListenable: selectedMoodSvgUrl,
        builder: (context, moodSvgValue, child) => JournalView(
          moodSvgUrl: moodSvgValue.toString(),
        ),
      ),
      ProfileView(setBottomBarIndex: setBottomBarIndex)
    ];
    //used a varibale for page loaded or not...
    //when this variabled is false, center loading screen is visible and when true
    //tabs are loaded

    pageLoaded.value = true;
  }

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

  @override
  void onInit() {
    super.onInit();
    //WidgetsBinding.instance!.addObserver(this);
    checkAuthState();
  }

  @override
  void dispose() {
    super.dispose();
    // WidgetsBinding.instance!.removeObserver();
    // inactiveTimer!.cancel();
    // pausedTimer!.cancel();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      pausedTimer = Timer(const Duration(seconds: 300), () {
        locked.value = true;
      });
    } else if (state == AppLifecycleState.resumed) {
      if (locked.value) {
        Get.to(Routes.LOCK_SCREEN);
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

    //WidgetsBinding.instance!.addObserver(this);
  }

}