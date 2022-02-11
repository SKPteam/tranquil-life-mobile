import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:language_picker/language_picker_cupertino.dart';
import 'package:language_picker/languages.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/models/consultant_model.dart';
import 'package:tranquil_life/models/consultant_profile_model.dart';
import 'package:tranquil_life/pages/registration/widgets/areaOfExpertiseModal.dart';
import 'package:tranquil_life/pages/registration/widgets/yearsOfExpModalSheet.dart';

class ConsultantRegistrationController extends GetxController{
  static ConsultantRegistrationController instance = Get.find();

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController firstNameTextEditingController = TextEditingController();
  TextEditingController lastNameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController dobTextEditingController = TextEditingController();
  TextEditingController companyEditingController = TextEditingController();
  Rx<TextEditingController> staffIDEditingController =
      TextEditingController().obs;
  TextEditingController areaOfExpertiseTEC = TextEditingController();
  TextEditingController yearsOfExpTEC = TextEditingController();
  TextEditingController preferredLangTEC = TextEditingController();

  TextEditingController entryCodeTEC = TextEditingController();

  String newClientEmailTemplate = "";
  String companyName = "";
  String companyID = "";
  String userType = "";
  String myLocation = "";
  RxBool orgSelected = false.obs;

  String staffID = "";

  //Position to get user current position with geoLocator using latitude and longitude
  Position? currentPosition;
  RxString country = "".obs;
  RxString currentLocation = RxString('');
  RxString selectedWorkStatus = "Self-employed".obs;

  var geoLocator = Geolocator(); // geoLocator is an instance of GeoLocator
  List<Placemark>? placemark;

  List<String> langArray = [];
  List<String> aoeArray = [];
  List<String> areaOfExpertiseList = [];
  List<String> yearsOfExperienceList = [];
  List<String> workStatusList = ['Self-employed', 'Employed'];

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

  showYOEModalBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        //Atish changed here, the time zone list modal sheet is now another
        //widget in the timzonemodalsheet.dart file
        builder: (BuildContext context) => YearsOfExpModalSheet(
          yearsOfExpList: yearsOfExperienceList,
          yearsOfExpTEC: yearsOfExpTEC,
        ));
    print('Selected Year Of Experience: ' + yearsOfExpTEC.text);
  }

  Rx<Language> selectedCupertinoLanguage = Languages.english.obs;

  void openCupertinoLanguagePicker() => showCupertinoModalPopup<void>(
      context: Get.context!,
      builder: (BuildContext context) {
        return ResponsiveSafeArea(
          responsiveBuilder: (context, size)
          => Container(
                height: 500,
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.topRight,
                        padding: EdgeInsets.only(
                            right: size.width * 0.06,
                            top: size.width * 0.06),
                        child: GestureDetector(
                          onTap: () {
                            if (!langArray
                                .contains(selectedCupertinoLanguage.value.name)) {
                              langArray
                                  .add(selectedCupertinoLanguage.value.name + '');
                            }

                            String langArrayToString =
                            langArray.map((e) => e.toString()).toString();

                            String brokenString = langArrayToString.substring(0,
                                langArrayToString.length - langArray.last.length - 1);

                            preferredLangTEC.text = brokenString.replaceAll('(', '') +
                                langArray.last.substring(0, langArray.last.length);

                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Select',
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 24,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500),
                          ),
                        )),
                    LanguagePickerCupertino(
                      pickerSheetHeight: 400.0,
                      itemBuilder: _buildCupertinoItem,
                      onValuePicked: (Language language) {
                        selectedCupertinoLanguage.value = language;

                        //preferredLangTEC.text = _selectedCupertinoLanguage.name;

                        print(selectedCupertinoLanguage.value.name);
                        print(selectedCupertinoLanguage.value.isoCode);
                      },
                    )
                  ],
                ),
              ),
        );
      });



  Widget _buildCupertinoItem(Language language) => Container(
    margin: EdgeInsets.only(left: 20),
    child: Row(
      children: <Widget>[
        Text("+${language.isoCode}"),
        const SizedBox(width: 8.0),
        Flexible(child: Text(language.name))
      ],
    ),
  );



}


