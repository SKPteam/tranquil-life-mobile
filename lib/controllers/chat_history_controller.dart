
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class ChatHistoryController extends GetxController {
  static ChatHistoryController instance = Get.find();

  RxBool dataLoaded = RxBool(false);



  ///the last chatRoom document from the 10 extracted documents

  ///scroll controlling for checking whether the screen is scrolled to the end

  ///boolean to check if there are more pagination is required
  bool moreChatRoomAvailableInDatabase = true;

  GetStorage prefs = GetStorage();


  @override
  void onInit() {
    super.onInit();

  }





  final timeFormat = DateFormat.Hm();
  final dateFormat = DateFormat('dd-MM-yyyy');

  String username = "";
  String avatarUrl = "";
}