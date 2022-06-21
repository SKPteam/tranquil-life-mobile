import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/models/mood.dart';

import '../constants/app_strings.dart';


class HomeController extends GetxController{
  static HomeController instance = Get.find();

  String blog = 'Blog';
  String signOut = 'Sign out';
  ValueNotifier<bool> anonymous = ValueNotifier(isAnonymousInTheApp);
  List<String>? menuOptions;
  bool _permissionGranted = false;
  RxString? username;
  Rx<UniqueKey>? meetingKey;

  Rx<Position>? currentPosition;
  var geoLocator = Geolocator(); // geoLocator is an instance of GeoLocator
  RxString? country, administrativeArea;
  RxString? location;

  final count = 0.obs;

  int? selectedIndex;

  navigateToNextPage({ required int index}) {
    selectedIndex = index;
  }

  getSelectedItem() {
    return moodsList.elementAt(selectedIndex!);
  }

  final List<Mood> moodsList = [
    Mood('Happy', 'assets/emojis/happy.png'),
    Mood('Sad', 'assets/emojis/sad.png'),
    Mood('Angry', 'assets/emojis/angry.png'),
    Mood('Frustrated', 'assets/emojis/frustrated.png'),
    Mood('Proud', 'assets/emojis/proud.png'),
    Mood('Fear', 'assets/emojis/fear.png'),
    Mood('Embarrassed', 'assets/emojis/embarrassed.png'),
    Mood('shock', 'assets/emojis/shock.png')
  ];

  @override
  void onInit() {
    super.onInit();

    print("HOME!!!!!!");

    menuOptions = <String>[blog];
  }



}