import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RegistrationFourController extends GetxController {
  static RegistrationFourController instance = Get.find();

  TextEditingController accountNameTEC = TextEditingController();
  TextEditingController accountNumberTEC = TextEditingController();
  TextEditingController homeAddressTEC = TextEditingController();
  TextEditingController bankNameTEC = TextEditingController();
  TextEditingController bankAddressTEC = TextEditingController();
  TextEditingController ibanTextEditingController = TextEditingController();
  TextEditingController swiftCodeTEC = TextEditingController();

}