// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/pages/home/home.dart';
import 'package:tranquil_life/pages/profile/profile_page.dart';

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

  @override
  void onInit() {
    super.onInit();
    ptController = PersistentTabController(initialIndex: 0);

    //WidgetsBinding.instance!.addObserver(this);
  }

}