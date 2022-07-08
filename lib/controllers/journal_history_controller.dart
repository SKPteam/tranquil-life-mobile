/*........ Journal History Controller ........*/
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tranquil_life/models/journal_list_model.dart';
import 'package:tranquil_life/services/http_services.dart';

import '../constants/app_strings.dart';

class JournalHistoryController extends GetxController {
  static JournalHistoryController instance = Get.find();


  double? prevCrossCount;

  Map map = {};
  RxBool journalsLoaded = false.obs;

  ///scroll controlling for checking whether the screen is scrolled to the end
  final ScrollController scrollController = ScrollController();

  ///boolean to check if there are more pagination is required
  RxBool moreJournalsAvailableInDatabase = true.obs;
  RxBool isFetchingJournal = false.obs;
  showLoading(){
    isFetchingJournal.toggle();
  }

  hideLoading(){
    isFetchingJournal.toggle();
  }

  @override
  void onInit() {
    getJournalHistory();
    super.onInit();
    //adding a scroll controller and add a listener to listen when the scroll reaches to maximum extent
    scrollController.addListener(scrollListener);
  }
  RxList<JournalList> journalList =  <JournalList>[].obs;

  getJournalHistory() async{
    showLoading();
    String url = baseUrl + clientGetJournal;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString("accessToken");
    var header = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    };
    final response = await HttpClass().httpGetRequest(header, Uri.parse(url));
    final result = jsonDecode(response!.body);
    if(result["data"] != null){
      hideLoading();
      journalList.value = JournalListReponse.fromJson(jsonDecode(response.body)).data!;
    }else{
      hideLoading();
      throw Exception("Unable to Load data");
    }
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