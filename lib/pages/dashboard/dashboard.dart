// ignore_for_file: prefer_const_constructors, must_be_immutable, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/routes/app_pages.dart';

import '../chat/chatroom.dart';
import 'widgets/fab_bottom_app_bar.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Get.toNamed(Routes.CHAT_ROOM);
      },
      tooltip: 'Increment',
      child: Icon(Icons.chat_bubble),
      elevation: 2.0,
      backgroundColor: Color(0xFFFFC400),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(()
      => Center(
          child: dashboardController.tabView()
      )),
      bottomNavigationBar: FABBottomAppBar(
        centerItemText: 'Chat',
        color: grey,
        selectedColor: active,
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: dashboardController.selectedTab,
        items: [
          FABBottomAppBarItem(iconData: Icons.home, text: 'Home'),
          FABBottomAppBarItem(iconData: Icons.account_balance_wallet, text: 'Wallet'),
          FABBottomAppBarItem(iconData: Icons.note_add, text: 'Journal'),
          FABBottomAppBarItem(iconData: Icons.person, text: 'Profile'),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFab(
          context), // Th
    );
  }



}


