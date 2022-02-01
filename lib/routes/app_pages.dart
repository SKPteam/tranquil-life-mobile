// ignore_for_file: constant_identifier_names
library app_pages;

import 'package:get/get.dart';
import 'package:tranquil_life/dashboard.dart';

import 'package:tranquil_life/pages/onboarding/onboarding_one.dart';
import 'package:tranquil_life/pages/onboarding/onboarding_two.dart';
import 'package:tranquil_life/pages/registration/registration_four.dart';
import 'package:tranquil_life/pages/registration/registration_one.dart';
import 'package:tranquil_life/pages/registration/registration_three.dart';
import 'package:tranquil_life/pages/registration/registration_two.dart';
import 'package:tranquil_life/pages/sign_in/sign_in.dart';

import '../splash_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ON_BOARDING_ONE;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: _Paths.ON_BOARDING_ONE,
      page: () => OnBoardingOne(),
    ),
    GetPage(
      name: _Paths.ON_BOARDING_TWO,
      page: () => OnBoardingTwo(),
    ),
    GetPage(
      name: _Paths.SIGN_IN,
      page: () => SignIn(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => Dashboard(),
    ),
    GetPage(
      name: _Paths.REGISTRATION_ONE,
      page: () => RegistrationOneView(),
    ),
    GetPage(
      name: _Paths.REGISTRATION_TWO,
      page: () => RegistrationTwoView(),
    ),
    GetPage(
      name: _Paths.REGISTRATION_THREE,
      page: () => RegistrationThreeView(),
    ),
    GetPage(
      name: _Paths.REGISTRATION_FOUR,
      page: () => RegistrationFourView(),
    ),

  ];
}