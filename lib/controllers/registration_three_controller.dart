// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:language_picker/language_picker.dart';
import 'package:language_picker/languages.dart';
import 'package:tranquil_life/models/company.dart';

class RegistrationThreeController extends GetxController {
  static RegistrationThreeController instance = Get.find();

  Size size = MediaQuery.of(Get.context!).size;

  /*For client*/
  TextEditingController companyEditingController = TextEditingController();
  TextEditingController staffIDEditingController = TextEditingController();
  RxBool orgSelected = false.obs;
  final List<Company> companyList = [];
  Company? _companyModel;

  /*For consultant*/
  TextEditingController areaOfExpertiseTEC = TextEditingController();
  TextEditingController yearsOfExpTEC = TextEditingController();
  TextEditingController preferredLangTEC = TextEditingController();
  RxString selectedWorkStatus = "Self-employed".obs;
  List<String> langArray = [];
  List<String> aoeArray = [];
  List<String> areaOfExpertiseList = [];
  List<String> yearsOfExperienceList = [];
  List<String> workStatusList = ['Self-employed', 'Employed'];
  List<String>? searchedAOEList;
  List<String>? aoeList;
  String? selectedAOE;

  TextEditingController aoeSearchController = TextEditingController();

  Rx<Language> selectedCupertinoLanguage = Languages.english.obs;

  void openCupertinoLanguagePicker() => showCupertinoModalPopup<void>(
      context: Get.context!,
      builder: (BuildContext context) {
        return Container(
          height: 500,
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(
                      right: size.width * 0.06,
                      top: size.height * 0.02),
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
        );
      });

  Widget _buildCupertinoItem(Language language) => Container(
    margin: EdgeInsets.only(left:size.width * 0.06),
    child: Row(
      children: <Widget>[
        Text("+${language.isoCode}"),
        const SizedBox(width: 8.0),
        Flexible(child: Text(language.name))
      ],
    ),
  );


  var partnerList  = [
    {
      'id': 0,
      'name': 'Total',
      'email': 'total@gmail.com',
      'phone': '+2348130308873',
      "logo": ''
    },
    {
      'id': 1,
      'name': 'Chevron',
      'email': 'chevron@gmail.com',
      'phone': '+2348130308873',
      "logo": ''
    },
    {
      'id': 3,
      'name': 'UBA',
      'email': 'uba@gmail.com',
      'phone': '+2348130308873',
      "logo": ''
    },
    {
      'id': 5,
      'name': 'Sahara Energy',
      'email': 'sahara@gmail.com',
      'phone': '+2348130308873',
      "logo": ''
    }
  ];

  //Display list of organisation
  void partnerListDialog(BuildContext context, Size size) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        builder: (BuildContext context) {
          return Container(
              height: 300,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SizedBox(
                height: size.height * 0.08,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: partnerList.length,
                          itemBuilder: (BuildContext context, int index) =>
                              buildCompanyCard(context, index)),
                    )
                  ],
                ),
              ));
        });
  }

  var companyDoc;

  buildCompanyCard(BuildContext context, int index) {
    //final company = partnerList[index];
    companyList.add(Company(
        id: partnerList[index]['id'].toString(),
        name: partnerList[index]['name'].toString(),
        logo: partnerList[index]['logo'].toString(),
        phone: partnerList[index]['phone'].toString(),
        email: partnerList[index]['email'].toString()
    ));

    final company = companyList[index];

    return GestureDetector(
        onTap: () {
          onTapCompanyCard(company);
        },
        child: Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(left: 8, top: 8, right: 8),
          child: Column(
            children: [
              company.logo.isNotEmpty
                  ? Image.network(company.logo, height: 200, width: 200)
                  : Image.asset('', height: 200, width: 200),
              Text(company.name,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18))
            ],
          )
        ));
  }

  onTapCompanyCard(Company company) async {
    var companyID = company.id;
    var companyName = company.name;
    companyEditingController.text = companyName;

    if (companyEditingController.text == 'None') {
      orgSelected.value = false;
      Get.back();
    }

    print("COMPANY NAME: "+company.name);
    orgSelected.value = true;
    Get.back();

  }

  @override
  void onInit() {
    super.onInit();
  }
}