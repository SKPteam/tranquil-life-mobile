/*........ Journal History Controller ........*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JournalHistoryController extends GetxController {
  double? prevCrossCount;

  Map map = {};
  RxBool journalsLoaded = false.obs;

  // final RxList<JournalModel> journalList = <JournalModel>[].obs;

  ///the last Notification document from the 10 extracted documents
  // DocumentSnapshot? lastDisplayedJournalDocument;

  ///scroll controlling for checking whether the screen is scrolled to the end
  final ScrollController scrollController = ScrollController();

  ///boolean to check if there are more pagination is required
  RxBool moreJournalsAvailableInDatabase = true.obs;

  @override
  void onInit() {
    super.onInit();
    //adding a scroll controller and add a listener to listen when the scroll reaches to maximum extent
    scrollController.addListener(scrollListener);
    //getJournalHistory();
  }

  @override
  void onClose() {
    scrollController.dispose();
  }

  void scrollListener() {
    //checking if there are more notifications in Database and then check if the scrollController attached to the listView
    //offset is greater than the max Offset the listView has.. and if that happens call the getting data function again for getting
    //further notifications from db
    if (moreJournalsAvailableInDatabase.value &&
        (scrollController.offset >= scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange)) {
      print("at the end of list");
    }
  }






  ///get random color from the primary colors of material
  Color getColor(String text) {
    return Colors.primaries[text.length % Colors.primaries.length].shade800;
  }
}