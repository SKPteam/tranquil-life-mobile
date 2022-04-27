import 'package:get/get.dart';
import 'package:tranquil_life/controllers/add_new_card_controller.dart';
import 'package:tranquil_life/controllers/app_settings_controller.dart';
import 'package:tranquil_life/controllers/chat_controller.dart';
import 'package:tranquil_life/controllers/chat_history_controller.dart';
import 'package:tranquil_life/controllers/consultant_list_controller.dart';
import 'package:tranquil_life/controllers/dashboard_controller.dart';
import 'package:tranquil_life/controllers/edit_profile_controller.dart';
import 'package:tranquil_life/controllers/home_controller.dart';
import 'package:tranquil_life/controllers/journal_controller.dart';
import 'package:tranquil_life/controllers/journal_history_controller.dart';
import 'package:tranquil_life/controllers/notification_history_controller.dart';
import 'package:tranquil_life/controllers/onboarding_controller.dart';
import 'package:tranquil_life/controllers/profile_controller.dart';
import 'package:tranquil_life/controllers/registration_four_controller.dart';
import 'package:tranquil_life/controllers/registration_one_controller.dart';
import 'package:tranquil_life/controllers/registration_three_controller.dart';
import 'package:tranquil_life/controllers/registration_two_controller.dart';
import 'package:tranquil_life/controllers/sign_in_controller.dart';
import 'package:tranquil_life/controllers/splash_screen_controller.dart';
import 'package:tranquil_life/controllers/timeout_controller.dart';
import 'package:tranquil_life/controllers/top_up_history_controller.dart';
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
    Get.lazyPut(() => SplashScreenController());
    Get.lazyPut(() =>  OnBoardingController());
    Get.lazyPut(() => SignInController());
    Get.lazyPut(() => RegistrationOneController());
    Get.lazyPut(() => RegistrationTwoController());
    Get.lazyPut(() => RegistrationThreeController());
    Get.lazyPut(() => RegistrationFourController());
    Get.lazyPut(() => TimeoutController());
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => WalletController());
    Get.lazyPut(() => AddNewCardController());
    Get.lazyPut(() => JournalController());
    Get.lazyPut(() => JournalHistoryController());
    Get.lazyPut(() => NotificationHistoryController());
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => ChatController());
    Get.lazyPut(() => ChatHistoryController());
    Get.lazyPut(() => AppSettingsController());
    Get.lazyPut(() => ConsultantListController());
    Get.lazyPut(() => EditProfileController());
  }

}