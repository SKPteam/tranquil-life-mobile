import 'package:get/get.dart';
import 'package:tranquil_life/controllers/dashboard_controller.dart';
import 'package:tranquil_life/controllers/onboarding_controller.dart';
import 'package:tranquil_life/controllers/wallet_controller.dart';
import 'package:tranquil_life/pages/onboarding/onboarding_one.dart';
import 'package:tranquil_life/pages/onboarding/onboarding_two.dart';
import 'package:tranquil_life/pages/registration/registration_one.dart';
import 'package:tranquil_life/pages/sign_in/sign_in.dart';

import '../dashboard.dart';

class AllControllerBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => OnBoardingOne());
    Get.lazyPut(() => OnBoardingTwo());
    Get.lazyPut(() => OnBoardingController());
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => AddNewCardController());
    Get.lazyPut(() => Dashboard());
    Get.lazyPut(() => SignIn());
    Get.lazyPut(() => RegistrationOneView());
  }

}