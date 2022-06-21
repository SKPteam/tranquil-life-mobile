import 'package:get/get.dart';

class MyTimeSlotController extends GetxController{
  static MyTimeSlotController instance = Get.find();

  RxInt selectedSectionIndex = 0.obs;
}