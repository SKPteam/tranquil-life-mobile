import 'package:get/get.dart';

class OnBoardingController extends GetxController{
  static OnBoardingController instance = Get.find();

  RxInt currentPage = 0.obs;
  List<Map<String, String>> onBoardingData = [
    {
      "text": "Let’s connect & get you to a brighter state. \nWhat brings you to Tranquil Life?",
      "image": "assets/images/onboarding_img1.png"
    },
    {
      "text":
      "Tranquil Life creates an all day access to Therapists, \nCounsellors and Psychologists.",
      "image": "assets/images/onboarding_img2.png"
    }
  ];

  RxString userType = ''.obs;
}