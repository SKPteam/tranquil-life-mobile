// ignore_for_file: constant_identifier_names, prefer_const_constructors, prefer_const_literals_to_create_immutables
library app_pages;

import 'package:get/get.dart';
import 'package:tranquil_life/dashboard.dart';
import 'package:tranquil_life/models/journal_model.dart';
import 'package:tranquil_life/pages/chat/chat_history.dart';
import 'package:tranquil_life/pages/chat/chatroom.dart';
import 'package:tranquil_life/pages/journal/journal_history_page.dart';
import 'package:tranquil_life/pages/journal/journal_page.dart';
import 'package:tranquil_life/pages/journal/selected_note_page.dart';
import 'package:tranquil_life/pages/notification/notification_history/notification_history_view.dart';

import 'package:tranquil_life/pages/onboarding/onboarding_one.dart';
import 'package:tranquil_life/pages/onboarding/onboarding_two.dart';
import 'package:tranquil_life/pages/profile/edit_profile_page.dart';
import 'package:tranquil_life/pages/profile/settings_page.dart';
import 'package:tranquil_life/pages/registration/registration_four.dart';
import 'package:tranquil_life/pages/registration/registration_one.dart';
import 'package:tranquil_life/pages/registration/registration_three.dart';
import 'package:tranquil_life/pages/registration/registration_two.dart';
import 'package:tranquil_life/pages/scheduling/consultant_list/consultant_list_view.dart';
import 'package:tranquil_life/pages/sign_in/sign_in.dart';
import 'package:tranquil_life/pages/timeout/timeout_screen.dart';
import 'package:tranquil_life/pages/wallet/add_new_card.dart';
import 'package:tranquil_life/pages/wallet/wallet_page.dart';

import '../splash_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.DASHBOARD;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => SplashScreenView(),
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
    GetPage(
      name: _Paths.TIMEOUT_SCREEN,
      page: () => TimeoutView(),
    ),
    GetPage(
      name: _Paths.WALLET,
      page: () => WalletView(reloadWalletPage: (int index) {  },),
    ),
    GetPage(
      name: _Paths.ADD_NEW_CARD,
      page: () =>  AddNewCard(reloadWalletPage: (int index) {  },),
    ),
    GetPage(
      name: _Paths.JOURNAL,
      page: () =>  JournalView(moodSvgUrl: '',),
    ),
    GetPage(
      name: _Paths.JOURNAL_HISTORY,
      page: () =>  JournalHistoryView(),
    ),
    // GetPage(
    //   name: _Paths.SELECTED_NOTE,
    //   page: () =>  SelectedNoteView(journalModel: JournalModel,),
    // ),
    GetPage(
      name: _Paths.CHAT_ROOM,
      page: () =>  ChatScreenPage(consultantUid: "", clientUid: ""),
    ),
    GetPage(
      name: _Paths.CHAT_HISTORY,
      page: () => ChatHistoryView(),
    ),
    GetPage(
      name: _Paths.CONSULTANT_LIST,
      page: () => ConsultantListView(answerOfQuestionaire: []),
    ),
    GetPage(
      name: _Paths.NOTIFICATION_HISTORY,
      page: () => NotificationHistoryScreen(),
    ),
    GetPage(
      name: _Paths.APP_SETTINGS,
      page: () => AppSettingsView(),
    ),
    GetPage(
      name: _Paths.CONSULTANT_LIST,
      page: () => ConsultantListView(answerOfQuestionaire: []),
    ),



  ];
}