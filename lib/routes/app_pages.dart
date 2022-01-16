// ignore_for_file: constant_identifier_names
library app_pages;

import 'package:get/get.dart';

import 'package:tranquil_life/pages/onboarding/onboarding_one.dart';
import 'package:tranquil_life/pages/onboarding/onboarding_two.dart';
import 'package:tranquil_life/pages/sign_in/sign_in.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ON_BOARDING_ONE;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => OnBoardingOne(),
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
  ];
}