/*............. Consultant List Controller ...............*/

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tranquil_life/models/consultant_model.dart';
import 'package:tranquil_life/models/consultant_porfolio_model.dart';
import 'package:tranquil_life/models/consultant_profile_model.dart';

class ConsultantListController extends GetxController {
static ConsultantListController instance = Get.find();

///Demo List of Consultants
final RxList<Consultant> consultantList = <Consultant>[].obs;
late Consultant consultantModel;
final List<Map<String, String>> answers = [];
RxBool consultantListLoaded = false.obs;
late ConsultantPortfolioModel consultantPortfolio;

ConsultantProfileModel consultantProfileModel = ConsultantProfileModel(preferredLangs: "Yoruba", yearsOfExperience: "2",
    areaOfExpertise: "5", uid: "1", fee: 5000, firstName: "Barry", lastName: "allen", );




@override
void onInit() {
super.onInit();

}

@override
void onClose() {}
}