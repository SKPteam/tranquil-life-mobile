// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tranquil_app/app/getx_controllers/dashboard_controller.dart';
import 'package:tranquil_app/app/routes/app_pages.dart';

import 'components/body.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView>
    with WidgetsBindingObserver {
  final DashboardController _ = Get.put(DashboardController());

  Timer? inactiveTimer;
  Timer? pausedTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    inactiveTimer?.cancel();
    pausedTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<DashboardController>(
      builder: (_) => Scaffold(
        backgroundColor: const Color(0xffF8F8F8),
        body:
            //if page has loaded display body else
            // display loading bar
            _.pageLoaded.isTrue
                ? const Body()
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
      ),
    );
  }

  bool locked = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      pausedTimer = Timer(const Duration(seconds: 300), () {
        locked = true;
      });
    } else if (state == AppLifecycleState.resumed) {
      if (locked) {
        Get.toNamed(Routes.LOCK_SCREEN);
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
        locked = true;
      });
      print('Inactive');
    } else if (state == AppLifecycleState.detached) {
      locked = true;
      inactiveTimer!.cancel();
      pausedTimer!.cancel();
    }
  }
}
