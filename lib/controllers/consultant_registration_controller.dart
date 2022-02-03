import 'package:get/get.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/models/consultant_model.dart';
import 'package:tranquil_life/models/consultant_profile_model.dart';

class ConsultantRegistrationController extends GetxController{
  static ConsultantRegistrationController instance = Get.find();

  // showAOEModalBottomSheet(BuildContext context) async {
  //   await showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
  //       ),
  //       //Atish changed here, the time zone list modal sheet is now another
  //       //widget in the timzonemodalsheet.dart file
  //       builder: (BuildContext context) => AreaOfExpertiseModalSheet(
  //         aoeList: areaOfExpertiseList,
  //         areaOfExpertiseTEC: areaOfExpertiseTEC,
  //         key: null,
  //       ));
  //
  //   if (areaOfExpertiseTEC.text != '') {
  //     if (!aoeArray.contains(areaOfExpertiseTEC.text)) {
  //       aoeArray.add(areaOfExpertiseTEC.text);
  //     }
  //
  //     String aoeArrayToString = aoeArray.map((e) => e.toString()).toString();
  //
  //     String brokenString = aoeArrayToString.substring(
  //         0, aoeArrayToString.length - aoeArray.last.length - 1);
  //
  //     areaOfExpertiseTEC.text = brokenString.replaceAll('(', '') +
  //         aoeArray.last.substring(0, aoeArray.last.length);
  //
  //     print('Selected Area Of Expertise: ' + areaOfExpertiseTEC.text);
  //   }
  // }
  //
  // showYOEModalBottomSheet(BuildContext context) async {
  //   await showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
  //       ),
  //       //Atish changed here, the time zone list modal sheet is now another
  //       //widget in the timzonemodalsheet.dart file
  //       builder: (BuildContext context) => YearsOfExpModalSheet(
  //         yearsOfExpList: yearsOfExperienceList,
  //         yearsOfExpTEC: yearsOfExpTEC,
  //       ));
  //   print('Selected Year Of Experience: ' + yearsOfExpTEC.text);
  // }
  //
  // Rx<Language> selectedCupertinoLanguage = Languages.english.obs;
  //
  // void openCupertinoLanguagePicker() => showCupertinoModalPopup<void>(
  //     context: Get.context!,
  //     builder: (BuildContext context) {
  //       return Container(
  //         height: 500,
  //         decoration: const BoxDecoration(color: Colors.white),
  //         child: Column(
  //           children: [
  //             Container(
  //                 alignment: Alignment.topRight,
  //                 padding: EdgeInsets.only(
  //                     right: displayWidth(context) * 0.06,
  //                     top: displayWidth(context) * 0.06),
  //                 child: GestureDetector(
  //                   onTap: () {
  //                     if (!langArray
  //                         .contains(selectedCupertinoLanguage.value.name)) {
  //                       langArray
  //                           .add(selectedCupertinoLanguage.value.name + '');
  //                     }
  //
  //                     String langArrayToString =
  //                     langArray.map((e) => e.toString()).toString();
  //
  //                     String brokenString = langArrayToString.substring(0,
  //                         langArrayToString.length - langArray.last.length - 1);
  //
  //                     preferredLangTEC.text = brokenString.replaceAll('(', '') +
  //                         langArray.last.substring(0, langArray.last.length);
  //
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: const Text(
  //                     'Select',
  //                     style: TextStyle(
  //                         decoration: TextDecoration.none,
  //                         fontSize: 24,
  //                         color: Colors.blue,
  //                         fontWeight: FontWeight.w500),
  //                   ),
  //                 )),
  //             LanguagePickerCupertino(
  //               pickerSheetHeight: 400.0,
  //               itemBuilder: _buildCupertinoItem,
  //               onValuePicked: (Language language) {
  //                 selectedCupertinoLanguage.value = language;
  //
  //                 //preferredLangTEC.text = _selectedCupertinoLanguage.name;
  //
  //                 print(selectedCupertinoLanguage.value.name);
  //                 print(selectedCupertinoLanguage.value.isoCode);
  //               },
  //             )
  //           ],
  //         ),
  //       );
  //     });
  //
  // Widget _buildCupertinoItem(Language language) => Container(
  //   margin: EdgeInsets.only(left: displayWidth(Get.context!) * 0.06),
  //   child: Row(
  //     children: <Widget>[
  //       Text("+${language.isoCode}"),
  //       const SizedBox(width: 8.0),
  //       Flexible(child: Text(language.name))
  //     ],
  //   ),
  // );

}


/*............. Consultant List Controller ...............*/

class ConsultantListController extends GetxController {
  ///Demo List of Consultants
  final RxList<Consultant> consultantList = <Consultant>[].obs;
  late Consultant consultantModel;
   final List<Map<String, String>> answers = [];
  RxBool consultantListLoaded = false.obs;
  late ConsultantProfileModel consultantProfileModel;

  @override
  void onInit() {
    super.onInit();

  }

  // void getConsultantInfo() async {
  //   print('quering data');
  //   await accountSettingsRef!
  //       .orderByChild('userType')
  //       .equalTo('consultant')
  //       .once()
  //       .then((DataSnapshot snapshot) {
  //     consultantList.clear();
  //     if (snapshot.value != null) {
  //       var keys = snapshot.value.keys;
  //       var values = snapshot.value;
  //       print(keys);
  //       print(values);
  //       for (var key in keys) {
  //         consultantModel = Consultant(
  //           uid: values[key][userUID].toString(),
  //           firstName: values[key][userFirstName],
  //           lastName: values[key][userLastName],
  //           avatarUrl: values[key][userAvatarUrl],
  //           location: values[key][userCurrentLocation],
  //           onlineStatus: values[key][userOnlineStatus],
  //         );
  //         consultantList.add(consultantModel);
  //         print('${consultantModel.uid}: ${consultantModel.firstName}');
  //       }
  //     }
  //     consultantListLoaded.value = true;
  //   });
  // }

  @override
  void onClose() {}
}