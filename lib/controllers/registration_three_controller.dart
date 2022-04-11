// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:language_picker/language_picker.dart';
import 'package:language_picker/languages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tranquil_life/constants/app_font.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/controllers/registration_one_controller.dart';
import 'package:tranquil_life/controllers/registration_two_controller.dart';
import 'package:tranquil_life/models/partner.dart';
import 'package:tranquil_life/routes/app_pages.dart';
import 'package:tranquil_life/widgets/custom_snackbar.dart';

import '../constants/style.dart';
import '../helpers/flush_bar_helper.dart';
import '../helpers/progress-dialog_helper.dart';
import '../main.dart';
import '../pages/registration/widgets/areaOfExpertiseModal.dart';

class RegistrationThreeController extends GetxController {
  static RegistrationThreeController instance = Get.find();

  RegistrationOneController _registrationOneController = Get.put(
      RegistrationOneController());
  RegistrationTwoController _registrationTwoController = Get.put(
      RegistrationTwoController());

  Size size = MediaQuery
      .of(Get.context!)
      .size;

  /*For client*/
  TextEditingController companyEditingController = TextEditingController();
  TextEditingController staffIDEditingController = TextEditingController();
  RxBool orgSelected = false.obs;

  //Company? _companyModel;

  /*For consultant*/
  TextEditingController areaOfExpertiseTEC = TextEditingController();
  TextEditingController yearsOfExpTEC = TextEditingController();
  TextEditingController preferredLangTEC = TextEditingController();
  RxString selectedWorkStatus = "Self-employed".obs;
  RxList aoeArray = [].obs;

  RxList expertiseArr = [].obs;


  RxList areaOfExpertiseList = [].obs;
  RxList yearsOfExperienceList = [].obs;
  List workStatusList = ['Self-employed', 'Employed'];

  RxList languagesArr = [].obs;

  RxString languageModalTitle = "Select".obs;

  // RxList searchedAOEList = [].obs;
  // RxList aoeList = [].obs;
  //String? selectedAOE;

  Rx<Language> selectedCupertinoLanguage = Languages.english.obs;

  RxString company_id = "".obs;
  Map mapData = {};

  Future<void> getConsltRegDataFromDatabase() async {
    await otherConsltRegDetails!.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        mapData = doc.data() as Map;
        print(mapData['areaOfExpertise']);
        List tempList = [];
        //tempList.addAll(mapData['areaOfExpertise']);
        tempList.addAll(mapData.keys.toList().cast<String>());
        //print("DATA: ${tempList}");
        // //uh used tempList[0] which was actually a key and uh were adding the key in aoeList while uh had
        // //to access the mapData[key] so it wasn't working
        areaOfExpertiseList.value = mapData[tempList[0]].cast<String>();
        //areaOfExpertiseList.value = mapData['areaOfExpertise'];
        yearsOfExperienceList.value = mapData[tempList[1]].cast<String>();
        //
        print("AREA OF EXPERTISE: $areaOfExpertiseList");
        print("YEARS OF EXPERIENCE: $yearsOfExperienceList");
      });
    });
  }


  //Language picker builder
  void openCupertinoLanguagePicker() =>
      showCupertinoModalPopup<void>(
          context: Get.context!,
          builder: (BuildContext context) {
            return Obx(()=>
                Container(
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
                              if(languageModalTitle.value == "Select"){
                                languagesArr.add(selectedCupertinoLanguage.value.name);
                                languageModalTitle.value = "Remove";
                              }else{
                                languagesArr.remove(selectedCupertinoLanguage.value.name);
                                languageModalTitle.value = "Select";
                              }

                              preferredLangTEC.text = languagesArr.toString().substring(1, languagesArr.toString().length-1);

                              print(languagesArr);
                              print(preferredLangTEC.text);

                            },
                            child: Text(
                              languageModalTitle.value,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: 18,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: josefinSansRegular
                              ),
                            ),
                          )),

                      LanguagePickerCupertino(
                        pickerSheetHeight: 400.0,
                        itemBuilder: _buildCupertinoItem,
                        onValuePicked: (Language language) async{
                          selectedCupertinoLanguage.value = language;

                          print(languageModalTitle.value);

                          languagesArr
                              .contains(language.name)
                              ? languageModalTitle.value = "Remove"
                              : languageModalTitle.value = "Select";
                        },
                      )
                    ],
                  ),
                ));
          });

  //Language item
  Widget _buildCupertinoItem(Language language) =>
      Container(
        margin: EdgeInsets.only(
          left: size.width * 0.06,
          right: size.width * 0.06,
        ),
        child: Row(
          children: <Widget>[
            Text("+${language.isoCode}"),
            SizedBox(width: 8.0),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(language.name),
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: active),
                      color: light,
                    ),

                    child: Center(
                      child: Container(
                        height: 12,
                        width: 12,
                        color: languagesArr.contains(language.name)
                            ? active
                            : Colors.transparent,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );

  //Areas of experise modal
  showAOEModalBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        //Atish changed here, the time zone list modal sheet is now another
        //widget in the timzonemodalsheet.dart file
        builder: (BuildContext context) => AreaOfExpertiseModalSheet());


    if (areaOfExpertiseTEC.text != '') {
      if (!aoeArray.contains(areaOfExpertiseTEC.text))
        aoeArray.add(areaOfExpertiseTEC.text);

      String aoeArrayToString = aoeArray.map((e) => e.toString()).toString();

      // String brokenString = aoeArrayToString.substring(
      //     0, aoeArrayToString.length - aoeArray.last.length - 1);

      // areaOfExpertiseTEC.text = brokenString.replaceAll('(', '') +
      //     aoeArray.last.substring(0, aoeArray.last.length);

      print('Selected Area Of Expertise: ' + areaOfExpertiseTEC.text);
    }
  }

  var partnerList = [];

  //Display list of organisation
  void partnerListDialog(BuildContext context, Size size) {
    showModalBottomSheet(
        isDismissible: true,
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        builder: (BuildContext context) {
          return FutureBuilder<List<Partner>>(
            future: getPartnerList(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.hasData == false) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.yellow)),
                      // Loader Animation Widget
                      Padding(padding: const EdgeInsets.only(top: 20.0)),
                    ],
                  ),
                );
              }

              //buildCompanyCard()
              if (snapshot.hasData) {
                return SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: snapshot.data!.map((partner) {
                        return GestureDetector(
                          onTap: () {
                            companyEditingController.text = partner.name!;
                            company_id.value = partner.id.toString();

                            if (companyEditingController.text == "None") {
                              orgSelected.value = false;
                            } else {
                              orgSelected.value = true;
                            }

                            getStaffUsingEmail();

                            print(partner.id!);

                            Navigator.of(context).pop();
                          },
                          child: Container(
                              height: 400,
                              alignment: Alignment.bottomCenter,
                              margin: EdgeInsets.only(
                                  left: 8, top: 8, right: 8),
                              child: Column(
                                children: [
                                  // Image.asset('assets/images/logo.jpg', height: 200, width: 200),
                                  partner.logo!.isNotEmpty
                                      ? Image.network(
                                      partner.logo!, height: 200, width: 200)
                                      : Image.asset(
                                      'assets/images/logo.jpg', height: 200,
                                      width: 200),
                                  Text(partner.name!,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18))
                                ],
                              )
                          ),
                        );
                      }).toList(),
                    )
                );
              }


              if (!snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return Text('No Partners');
              }

              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }


              if (snapshot.data! == null || snapshot.data!.length == 0) {
                return Column(
                  children: <Widget>[
                    Center(child: Text("Unable to find any partners"))
                  ],
                );
              }

              return Text('No Data');
            },

          );
        });
  }

  Future getStaff() async {
    String url = baseUrl + getStaffPath;

    var response = await post(Uri.parse(url), headers: {
      "Content-type": "application/json",
      "Accept": "application/json"
    }, body: jsonEncode({
      "staffID": staffIDEditingController.text,
      "company_id": int.parse(company_id.value.toString())
    }));

    var resBody = json.decode(response.body);

    if (resBody["message"] == "does not exist") {
      showDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Contact your company's HR",
                  style: TextStyle(fontFamily: josefinSansSemiBold)),
              content: Text(
                  "Sorry, no staff with this id in ${companyEditingController
                      .text}'s database"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Ok")),
              ],
            );
          });

      return resBody["message"];
    }
    else {
      showDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(resBody["staff"]["company_email"].toString(),
                  style: TextStyle(fontFamily: josefinSansSemiBold)),
              content: Text(
                  "To gain access to your consultation discount, use your company email."),
              actions: [
                TextButton(
                    onPressed: () async {
                      registrationOneController.emailTextEditingController
                          .text = resBody["staff"]["company_email"].toString();

                      displaySnackBar("Email: ${registrationOneController
                          .emailTextEditingController.text}", context);

                      print(
                          "${registrationTwoController.dobTextEditingController
                              .text.trim()}, "
                              "${registrationOneController
                              .phoneNumTextEditingController.text}");

                      if (companyEditingController
                          .text.isNotEmpty) {
                        if (companyEditingController
                            .text !=
                            'None' && staffIDEditingController
                            .value.text.isEmpty) {
                          displaySnackBar(
                              'Type in your staff ID ',
                              context);
                        } else if (companyEditingController.text == 'None'
                            && registrationThreeController
                                .staffIDEditingController
                                .value.text.isEmpty) {
                          Navigator.of(context).pop();
                          //register client
                          // await registerClient()
                          //     .then((value){
                          //   Navigator.of(context).pop();

                          //Get.offAllNamed(Routes.SIGN_IN);
                          // }).onError((error, stackTrace){
                          //   print("REGISTRATION: ERROR $error");
                          // });
                        }
                        else {
                          //register client
                          Navigator.of(context).pop();

                          // await registerClient()
                          //     .then((value) {
                          //   Navigator.of(context).pop();
                          //
                          //   Get.offAllNamed(Routes.SIGN_IN);
                          // }).onError((error, stackTrace){
                          //   print("REGISTRATION: ERROR $error");
                          // });
                        }
                      }
                      else {
                        displaySnackBar(
                            'Select your company or organisation',
                            context);
                      }
                    },
                    child: Text("Accept")),

                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Decline")),
              ],
            );
          });
      return resBody["staff"];
    }
  }

  Future getStaffUsingEmail() async {
    String url = baseUrl + getStaffUsingEmailPath;

    var response = await post(Uri.parse(url), headers: {
      "Content-type": "application/json",
      "Accept": "application/json"
    }, body: jsonEncode({
      "email": registrationOneController.emailTextEditingController.text
          .removeAllWhitespace,
      "company_id": int.parse(company_id.value.toString())
    }));

    var resBody = json.decode(response.body);

    if (resBody["message"] == "does not exist") {
      return resBody["message"];
    } else {
      showDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Your Staff ID: ",
                      style: TextStyle(fontFamily: josefinSansSemiBold)),
                  Text(resBody["staffID"].toString())
                ],
              ),
              content: Text("Is this your staff ID?"),
              actions: [
                TextButton(
                    onPressed: () async {
                      staffIDEditingController.text =
                          resBody["staffID"].toString();

                      Navigator.of(context).pop();
                    },
                    child: Text("Yes")),

                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("No")),
              ],
            );
          });

      return resBody["staffID"];
    }
  }

  Future<List<Partner>> getPartnerList() async {
    List<Partner> _partners = [];

    String url = baseUrl + getAllPartnersPath;

    var response = await get(Uri.parse(url), headers: {
      "Content-type": "application/json",
      "Accept": "application/json"
    });

    if (response != null) {
      var resBody = json.decode(response.body);
      resBody.forEach((partner) {
        var model = Partner();
        model.id = partner['id'];
        model.name = partner['name'];
        model.logo = partner['logo'];
        //model.email = partner['email'];
        //model.phone = partner['phone'];
        model.cities = partner['cities'];
        //model.password = partner['password'];

        _partners.add(model);
      });
    }

    print(_partners);

    partnerList.add(_partners);

    return _partners;
  }

  Future registerClient() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    ProgressDialogHelper().showProgressDialog(
        Get.context!, "Authenticating...");
    String url = baseUrl + clientRegisterPath;

    var requestBody = companyEditingController.text == "None" ?
    {
      "f_name": registrationTwoController.firstNameTextEditingController.text,
      "l_name": registrationTwoController.lastNameTextEditingController.text,
      "username": registrationTwoController.userNameTextEditingController.text,
      "email": registrationOneController.emailTextEditingController.text
          .removeAllWhitespace,
      "password": registrationOneController.passwordTextEditingController.text,
      "phone": registrationOneController.phoneNumTextEditingController.text
          .removeAllWhitespace,
      "day_of_birth": registrationTwoController.day!,
      "month_of_birth": registrationTwoController.month!,
      "year_of_birth": registrationTwoController.year!,
      "company_id": int.parse(company_id.value),
    } : {
      "f_name": registrationTwoController.firstNameTextEditingController.text,
      "l_name": registrationTwoController.lastNameTextEditingController.text,
      "username": registrationTwoController.userNameTextEditingController.text,
      "email": registrationOneController.emailTextEditingController.text
          .removeAllWhitespace,
      "password": registrationOneController.passwordTextEditingController.text,
      "phone": registrationOneController.phoneNumTextEditingController.text
          .removeAllWhitespace,
      "day_of_birth": registrationTwoController.day!,
      "month_of_birth": registrationTwoController.month!,
      "year_of_birth": registrationTwoController.year!,
      "company_id": int.parse(company_id.value),
      "staffID": staffIDEditingController.text
    };
    var response = await post(Uri.parse(url), headers: {
      "Content-type": "application/json",
      "Accept": "application/json"
    }, body: jsonEncode(requestBody));
    var result = json.decode(response.body);

    if (result["user"] != null) {
      sharedPreferences.setString("userName", result["user"]["username"]);
      sharedPreferences.setString("firstName", result["user"]["f_name"]);
      sharedPreferences.setString("lastName", result["user"]["l_name"]);
      sharedPreferences.setString("email", result["user"]["email"]);
      sharedPreferences.setString("phoneNumber", result["user"]["phone"]);
      sharedPreferences.setString("token", result["user"]["auth_token"]);
      ProgressDialogHelper().hideProgressDialog(Get.context!);
      Get.offAllNamed(Routes.SIGN_IN);
      FlushBarHelper(Get.context!).showFlushBar(
          "Registration Successful", color: Colors.green);
    } else if (result["user"] == null) {
      ProgressDialogHelper().hideProgressDialog(Get.context!);
      FlushBarHelper(Get.context!).showFlushBar(
          result["errors"], color: Colors.red);
    } else {
      ProgressDialogHelper().hideProgressDialog(Get.context!);
      throw Exception("Unable to Complete Registration");
    }
  }

  @override
  void onInit() {
    getConsltRegDataFromDatabase();
  }


}
