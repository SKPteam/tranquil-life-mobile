import 'package:get/get.dart';

import '../pages/speak_with_consultant.dart';

class ConsultantDetailsController extends GetxController{
  List<ConsultantDetails> consultants = ConsultantDetails.consultantDetails;
  int? selectedIndex;

  navigateToNextPage({ required int index}) {
    selectedIndex = index;
  }

  getSelectedItem() {
    return consultants.elementAt(selectedIndex!);
  }
}