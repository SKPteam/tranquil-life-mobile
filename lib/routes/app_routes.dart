// ignore_for_file: constant_identifier_names

part of app_pages;

abstract class Routes {
  Routes._();

  static const HOME = _Paths.HOME;
  static const SPLASH_SCREEN = _Paths.SPLASH_SCREEN;
  static const LOCK_SCREEN = _Paths.LOCK_SCREEN;
  static const ON_BOARDING_ONE = _Paths.ON_BOARDING_ONE;
  static const ON_BOARDING_TWO = _Paths.ON_BOARDING_TWO;
  static const SIGN_IN = _Paths.SIGN_IN;
  static const REGISTRATION_ONE = _Paths.REGISTRATION_ONE;
  static const REGISTRATION_TWO = _Paths.REGISTRATION_TWO;
  static const REGISTRATION_THREE = _Paths.REGISTRATION_THREE;
  static const REGISTRATION_FOUR = _Paths.REGISTRATION_FOUR;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const WALLET = _Paths.WALLET;
  static const JOURNAL = _Paths.JOURNAL;
  static const JOURNAL_HISTORY = _Paths.JOURNAL_HISTORY;
  static const PROFILE = _Paths.PROFILE;
  static const CHAT_ROOM = _Paths.CHAT_ROOM;
  static const BLOG = _Paths.BLOG;
  static const CONSULTATION_QUESTIONNAIRE = _Paths.CONSULTATION_QUESTIONNAIRE;
  static const SCHEDULING = _Paths.SCHEDULING;
  static const NOTIFICATION_HISTORY = _Paths.NOTIFICATION_HISTORY;
  static const ADD_NEW_CARD = _Paths.ADD_NEW_CARD;
  static const APP_SETTINGS = _Paths.APP_SETTINGS;
  static const EDIT_PROFILE = _Paths.EDIT_PROFILE;
  static const CONSULTANT_LIST = _Paths.CONSULTANT_LIST;
  static const SELECTED_NOTE = _Paths.SELECTED_NOTE;
  static const CHAT_HISTORY = _Paths.CHAT_HISTORY;
}

abstract class _Paths {
  static const HOME = '/home';
  static const SPLASH_SCREEN = '/splash_screen';
  static const LOCK_SCREEN = '/lock-screen';
  static const ON_BOARDING_ONE = '/on-boarding-one';
  static const SIGN_IN = '/sign-in';
  static const ON_BOARDING_TWO = '/on-boarding-two';
  static const REGISTRATION_ONE = '/registration-one';
  static const REGISTRATION_TWO = '/registration-two';
  static const REGISTRATION_THREE = '/registration-three';
  static const REGISTRATION_FOUR = '/registration-four';
  static const DASHBOARD = '/dashboard';
  static const WALLET = '/wallet';
  static const JOURNAL = '/journal';
  static const PROFILE = '/profile';
  static const CHAT_ROOM = '/chat-room';
  static const BLOG = '/blog';
  static const CONSULTATION_QUESTIONNAIRE = '/consultation-questionnaire';
  static const SCHEDULING = '/pages.scheduling';
  static const NOTIFICATION_HISTORY = '/notification-history';
  static const ADD_NEW_CARD = '/add-new-card';
  static const APP_SETTINGS = '/app-settings';
  static const EDIT_PROFILE = '/edit-profile';
  static const CONSULTANT_LIST = '/consultant-list';
  static const JOURNAL_HISTORY = '/journal-history';
  static const SELECTED_NOTE = '/selected-note';
  static const CHAT_HISTORY = '/chat-history';
}
