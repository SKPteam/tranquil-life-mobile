// ignore_for_file: prefer_const_constructors

import 'dart:convert';

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

import '../helpers/flush_bar_helper.dart';
import '../helpers/progress-dialog_helper.dart';

class RegistrationThreeController extends GetxController {
  static RegistrationThreeController instance = Get.find();

  RegistrationOneController _registrationOneController = Get.put(RegistrationOneController());
  RegistrationTwoController _registrationTwoController = Get.put(RegistrationTwoController());

  Size size = MediaQuery.of(Get.context!).size;

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

  RxString company_id = "".obs;

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


  var partnerList  = [];

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
            builder: (BuildContext context, snapshot)
            {
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
              if (snapshot.hasData){
                return SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: snapshot.data!.map((partner){
                        return GestureDetector(
                          onTap: (){
                            companyEditingController.text = partner.name!;
                            company_id.value = partner.id.toString();

                            if(companyEditingController.text == "None"){
                              orgSelected.value = false;
                            }else{
                              orgSelected.value = true;
                            }

                            getStaffUsingEmail();

                            print(partner.id!);

                            Navigator.of(context).pop();
                          },
                          child: Container(
                              height: 400,
                              alignment: Alignment.bottomCenter,
                              margin: EdgeInsets.only(left: 8, top: 8, right: 8),
                              child: Column(
                                children: [
                                  // Image.asset('assets/images/logo.jpg', height: 200, width: 200),
                                  partner.logo!.isNotEmpty
                                      ? Image.network(partner.logo!, height: 200, width: 200)
                                      : Image.asset('assets/images/logo.jpg', height: 200, width: 200),
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

  Future getStaff() async{
    String url = baseUrl + getStaffPath;

    var response = await post(Uri.parse(url), headers: {
      "Content-type": "application/json",
      "Accept": "application/json"
    }, body: jsonEncode({
      "staffID": staffIDEditingController.text,
      "company_id": int.parse(company_id.value.toString())
    }));

    var resBody = json.decode(response.body);

    if(resBody["message"] == "does not exist"){
      showDialog(
          context: Get.context!,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text("Contact your company's HR", style: TextStyle(fontFamily: josefinSansSemiBold)),
              content: Text("Sorry, no staff with this id in ${companyEditingController.text}'s database"),
              actions: [
                TextButton(
                    onPressed: (){
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
          builder: (BuildContext context){
            return AlertDialog(
              title: Text(resBody["staff"]["company_email"].toString(), style: TextStyle(fontFamily: josefinSansSemiBold)),
              content: Text("To gain access to your consultation discount, use your company email."),
              actions: [
                TextButton(
                    onPressed: () async{
                      registrationOneController.emailTextEditingController.text = resBody["staff"]["company_email"].toString();

                      displaySnackBar("Email: ${registrationOneController
                          .emailTextEditingController.text}", context);

                      print(
                          "${registrationTwoController.dobTextEditingController.text.trim()}, "
                              "${registrationOneController.phoneNumTextEditingController.text}");

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
                                .value.text.isEmpty)
                        {
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
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: Text("Decline")),
              ],
            );
          });
      return resBody["staff"];
    }
  }

  Future getStaffUsingEmail() async{
    String url = baseUrl + getStaffUsingEmailPath;

    var response = await post(Uri.parse(url), headers: {
      "Content-type": "application/json",
      "Accept": "application/json"
    }, body: jsonEncode({
      "email": registrationOneController.emailTextEditingController.text.removeAllWhitespace,
      "company_id": int.parse(company_id.value.toString())
    }));

    var resBody = json.decode(response.body);

    if(resBody["message"] == "does not exist"){

      return resBody["message"];
    }else {
      showDialog(
          context: Get.context!,
          builder: (BuildContext context){
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Your Staff ID: ", style: TextStyle(fontFamily: josefinSansSemiBold)),
                  Text(resBody["staffID"].toString())
                ],
              ),
              content: Text("Is this your staff ID?"),
              actions: [
                TextButton(
                    onPressed: () async{
                      staffIDEditingController.text = resBody["staffID"].toString();

                      Navigator.of(context).pop();
                    },
                    child: Text("Yes")),

                TextButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: Text("No")),
              ],
            );
          });

      return resBody["staffID"];
    }
  }

  Future<List<Partner>> getPartnerList() async{
    List<Partner> _partners = [];

    String url = baseUrl + getAllPartnersPath;

    var response = await get(Uri.parse(url), headers: {
      "Content-type": "application/json",
      "Accept": "application/json"
    });

    if(response != null){
      var resBody = json.decode(response.body);
      resBody.forEach((partner){
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

  Future registerClient() async{
    SharedPreferences sharedPreferences =  await SharedPreferences.getInstance();
    ProgressDialogHelper().showProgressDialog(Get.context!, "Authenticating...");
    String url = baseUrl + clientRegisterPath;

    var requestBody = companyEditingController.text == "None" ?
    {
      "f_name": registrationTwoController.firstNameTextEditingController.text,
      "l_name": registrationTwoController.lastNameTextEditingController.text,
      "username": registrationTwoController.userNameTextEditingController.text,
      "email": registrationOneController.emailTextEditingController.text.removeAllWhitespace,
      "password": registrationOneController.passwordTextEditingController.text,
      "phone": registrationOneController.phoneNumTextEditingController.text.removeAllWhitespace,
      "day_of_birth": registrationTwoController.day!,
      "month_of_birth": registrationTwoController.month!,
      "year_of_birth": registrationTwoController.year!,
      "company_id": int.parse(company_id.value),
    } : {
      "f_name": registrationTwoController.firstNameTextEditingController.text,
      "l_name": registrationTwoController.lastNameTextEditingController.text,
      "username": registrationTwoController.userNameTextEditingController.text,
      "email": registrationOneController.emailTextEditingController.text.removeAllWhitespace,
      "password": registrationOneController.passwordTextEditingController.text,
      "phone": registrationOneController.phoneNumTextEditingController.text.removeAllWhitespace,
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

    if(result["user"] != null){
      sharedPreferences.setString("userName", result["user"]["username"]);
      sharedPreferences.setString("firstName", result["user"]["f_name"]);
      sharedPreferences.setString("lastName", result["user"]["l_name"]);
      sharedPreferences.setString("email", result["user"]["email"]);
      sharedPreferences.setString("phoneNumber", result["user"]["phone"]);
      sharedPreferences.setString("token", result["user"]["auth_token"]);
      ProgressDialogHelper().hideProgressDialog(Get.context!);
      Get.offAllNamed(Routes.SIGN_IN);
      FlushBarHelper(Get.context!).showFlushBar("Registration Successful", color: Colors.green);
    }else if (result["user"] == null){
      ProgressDialogHelper().hideProgressDialog(Get.context!);
      FlushBarHelper(Get.context!).showFlushBar(result["errors"], color: Colors.red);
    }else{
      ProgressDialogHelper().hideProgressDialog(Get.context!);
      throw Exception("Unable to Complete Registration");
    }
  }


}




