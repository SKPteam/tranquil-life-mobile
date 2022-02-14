// ignore_for_file: unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tranquil_life/models/notification_history_model.dart';

class NotificationHistoryController extends GetxController {
  static NotificationHistoryController instance = Get.find();

  RxBool dataLoaded = true.obs;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  GlobalKey<AnimatedListState> get listKey => _listKey;

  ///list containing the notifications from the database
  List<NotificationModel> notifications = [
    NotificationModel(id: '1', userName: 'mike', uid: '1', msg: "Hi", imageUrl: "assets/images/avatar_img2.png"),
    NotificationModel(id: '2', userName: 'mick', uid: '2', msg: "Hello", imageUrl: "assets/images/avatar_img2.png"),
    NotificationModel(id: '3', userName: 'tom', uid: '3', msg: "are you coming", imageUrl: "assets/images/avatar_img2.png"),
    NotificationModel(id: '4', userName: 'tommy', uid: '4', msg: "have you left? ", imageUrl: "assets/images/avatar_img2.png"),
    NotificationModel(id: '5', userName: 'tomi', uid: '5', msg: "don't give up ", imageUrl: "assets/images/avatar_img2.png")];

  ///the last Notification document from the 10 extracted documents

  ///scroll controlling for checking whether the screen is scrolled to the end
  final ScrollController scrollController = ScrollController();

  ///boolean to check if there are more pagination is required
  bool moreNotificationsAvailableInDatabase = true;

  GetStorage prefs = GetStorage();

  ///getting notifications data from the firebase

  @override
  void onInit() {
    super.onInit();
    //adding a scroll controller and add a listener to listen when the scroll reaches to maximum extent
    scrollController.addListener(_scrollListener);
    //getJournalHistory();
  }

  ///handling the snapshots to convert them to Notification Models and add them to the list

  void _scrollListener() {
    //checking if there are more notifications in Database and then check if the scrollController attached to the listView
    //offset is greater than the max Offset the listView has.. and if that happens call the getting data function again for getting
    //further notifications from db
    if (moreNotificationsAvailableInDatabase &&
        (scrollController.offset >= scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange)) {
      print("at the end of list");
    }
  }
}