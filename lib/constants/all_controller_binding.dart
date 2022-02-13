import 'package:get/get.dart';
import 'package:tranquil_life/controllers/consultant_registration_controller.dart';
import 'package:tranquil_life/controllers/dashboard_controller.dart';
import 'package:tranquil_life/controllers/onboarding_controller.dart';
import 'package:tranquil_life/controllers/registration_four_controller.dart';
import 'package:tranquil_life/controllers/registration_one_controller.dart';
import 'package:tranquil_life/controllers/registration_three_controller.dart';
import 'package:tranquil_life/controllers/registration_two_controller.dart';
import 'package:tranquil_life/controllers/sign_in_controller.dart';
import 'package:tranquil_life/controllers/wallet_controller.dart';
import 'package:tranquil_life/pages/onboarding/onboarding_one.dart';
import 'package:tranquil_life/pages/onboarding/onboarding_two.dart';
import 'package:tranquil_life/pages/registration/registration_one.dart';
import 'package:tranquil_life/pages/registration/registration_two.dart';
import 'package:tranquil_life/pages/sign_in/sign_in.dart';

import '../pages/dashboard/dashboard.dart';

class AllControllerBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => OnBoardingController());
    Get.lazyPut(() => SignInController());
    Get.lazyPut(() => RegistrationOneController());
    Get.lazyPut(() => RegistrationTwoController());
    Get.lazyPut(() => RegistrationThreeController());
    Get.lazyPut(() => RegistrationFourController());
    Get.lazyPut(() => DashboardController());

  }

}