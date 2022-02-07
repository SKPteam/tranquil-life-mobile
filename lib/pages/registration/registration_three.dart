
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/consultant_registration_controller.dart';
import 'package:tranquil_life/controllers/onboarding_controller.dart';
import 'package:tranquil_life/controllers/client_registration_controller.dart';
import 'package:tranquil_life/routes/app_pages.dart';
import 'package:tranquil_life/helpers/constants.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';
import 'package:tranquil_life/widgets/custom_snackbar.dart';
import 'package:tranquil_life/widgets/custom_form_field.dart';



import 'package:tranquil_life/widgets/custom_form_field.dart';
import 'package:tranquil_life/widgets/progress_dialog.dart';

class RegistrationThreeView extends GetView<ClientRegistrationController> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


  final ClientRegistrationController _ = Get.put(ClientRegistrationController());

  final ConsultantRegistrationController consult = Get.put(ConsultantRegistrationController());

  final OnBoardingController obc = Get.put(
      OnBoardingController());

  RegistrationThreeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Obx(() => Scaffold(
            key: scaffoldKey,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text(
                "Sign Up",
                style: TextStyle(color: Color(0xffBEBEBE)),
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: Get.find<OnBoardingController>().userType.value ==
                        client
                        ? const AssetImage('assets/images/bg_img1.png')
                        : const AssetImage('assets/images/bg_img2.png'),
                    colorFilter: const ColorFilter.mode(
                        Color(0xff777474), BlendMode.multiply),
                    fit: BoxFit.cover),
              ),
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: displayWidth(context) * 0.1),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: displayHeight(context) * 0.08), // 4%
                          Text("Register Account",
                              style: TextStyle(
                                fontSize: displayWidth(context) / 14,
                                color: Colors.white,
                                height: displayHeight(context) * 0.0015,
                              )),
                          SizedBox(height: displayHeight(context) * 0.01),
                          Text("Build your biography",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: const Color(0xffDDDDDD),
                                  fontSize: displayWidth(context) / 32)),
                          SizedBox(height: displayHeight(context) * 0.08),
                          Form(
                              child: Get.find<OnBoardingController>()
                                  .userType
                                  .value ==
                                  client
                                  ? Column(
                                children: [
                                  Container(
                                      height:
                                      displayHeight(context) * 0.070,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white),
                                        borderRadius:
                                        BorderRadius.circular(4.0),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: displayWidth(
                                                    context) *
                                                    0.04),
                                            child: Text(
                                              _.country.value,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: displayWidth(
                                                    context) /
                                                    25,
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                  SizedBox(
                                      height:
                                      displayHeight(context) * 0.02),
                                  ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(4.0),
                                    child: CustomFormField(
                                      textEditingController:
                                      _.companyEditingController,
                                      hint: "Name of your organisation",
                                      readOnly: true,
                                      onTap: () {
                                        _showModalBottomSheet(
                                            Get.context!);
                                      },
                                      obscureText: false,
                                      togglePassword: () {},
                                      textInputType: TextInputType.text,
                                      formatters: const [],
                                      showCursor: false,
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                      displayHeight(context) * 0.02),
                                  Visibility(
                                    visible: _.orgSelected.value,
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(4.0),
                                      child: CustomFormField(
                                        textEditingController: _
                                            .staffIDEditingController
                                            .value,
                                        hint: "Staff ID",
                                        readOnly: false,
                                        onTap: () {
                                          //..
                                        },
                                        obscureText: false,
                                        togglePassword: () {},
                                        textInputType: TextInputType.text,
                                        formatters: const [],
                                        showCursor: true,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                      displayHeight(context) * 0.03),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          print(
                                              "${controller.dobTextEditingController.text.trim()},"
                                                  " ${controller.currentLocation.toString()}, "
                                                  "${controller.country} ${controller.phoneTextEditingController.text}");
                                          if (_.companyEditingController
                                              .text.isNotEmpty) {
                                            if (_.companyEditingController
                                                .text !=
                                                'None' &&
                                                _.staffIDEditingController
                                                    .value.text.isEmpty) {
                                              displaySnackBar(
                                                  'Type in your staff ID ',
                                                  context);
                                            } else if (_.companyEditingController
                                                .text ==
                                                'None' &&
                                                _.staffIDEditingController
                                                    .value.text.isEmpty) {
                                              // _.registerNewClient(
                                              //     context);
                                            }
                                            else {}
                                          } else {
                                            displaySnackBar(
                                                'Select your company or organisation',
                                                context);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 0,
                                                vertical: 20),
                                            primary: kPrimaryColor),
                                        child: Text(
                                          'Sign Up',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                            displayWidth(context) /
                                                28,
                                          ),
                                        )),
                                  ),
                                ],
                              )
                                  : Column(
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(4),
                                    child: CustomFormField(
                                      hint: 'Areas Of Expertise',
                                      readOnly: true,
                                      textEditingController:
                                      _.areaOfExpertiseTEC,
                                      onTap: () {
                                        print("mdkkggd");
                                        _.areaOfExpertiseTEC.text = '';
                                        // ignore: prefer_const_constructors
                                        consult.showAOEModalBottomSheet(
                                            context);
                                      },
                                      textInputType: TextInputType.text,
                                      togglePassword: () {},
                                      formatters: [],
                                      obscureText: false,
                                      showCursor: false,
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                      displayHeight(context) * 0.020),
                                  ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(4),
                                    child: CustomFormField(
                                      hint: 'Years Of Experience',
                                      textEditingController:
                                      _.yearsOfExpTEC,
                                      readOnly: true,
                                      onTap: () {
                                        consult.showYOEModalBottomSheet(
                                            context);
                                      },
                                      textInputType: TextInputType.text,
                                      togglePassword: () {},
                                      formatters: [],
                                      obscureText: false,
                                      showCursor: false,
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                      displayHeight(context) * 0.020),
                                  ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(4),
                                    child: CustomFormField(
                                      hint: 'Preferred Languages',
                                      textEditingController:
                                      _.preferredLangTEC,
                                      showCursor: false,
                                      readOnly: true,
                                      onTap: () {
                                        consult.openCupertinoLanguagePicker();
                                      },
                                      textInputType: TextInputType.text,
                                      togglePassword: () {},
                                      formatters: [],
                                      obscureText: false,
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                      displayHeight(context) * 0.020),
                                  ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(4),
                                      child: Container(
                                        width:
                                        displayWidth(context) * 0.80,
                                        padding:
                                        const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        color: Colors.white,
                                        child:
                                        DropdownButtonHideUnderline(
                                          child: ButtonTheme(
                                              alignedDropdown: true,
                                              child: DropdownButton(
                                                hint: const Text(
                                                  'Work Status',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                value: _
                                                    .selectedWorkStatus
                                                    .value,
                                                onChanged: (newValue) {
                                                  _.selectedWorkStatus
                                                      .value =
                                                      newValue.toString();
                                                },
                                                items: _.workStatusList
                                                    .map((value) {
                                                  return DropdownMenuItem(
                                                      value: value,
                                                      onTap: () {
                                                        _.selectedWorkStatus
                                                            .value =
                                                            value;

                                                        print(_
                                                            .selectedWorkStatus
                                                            .value);
                                                      },
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: displayWidth(
                                                                context) *
                                                                0.06,
                                                          ),
                                                          Container(
                                                            margin: const EdgeInsets
                                                                .only(
                                                                left: 10),
                                                            child: Text(
                                                                value),
                                                          )
                                                        ],
                                                      ));
                                                }).toList(),
                                              )),
                                        ),
                                      )),
                                  SizedBox(
                                      height:
                                      displayHeight(context) * 0.020),
                                  ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(4.0),
                                    child: CustomFormField(
                                      textEditingController:
                                      _.companyEditingController,
                                      hint: "Your current workplace",
                                      readOnly: false,
                                      onTap: () {
                                        //..
                                      },
                                      obscureText: false,
                                      togglePassword: () {},
                                      textInputType: TextInputType.text,
                                      formatters: const [],
                                      showCursor: true,
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                      displayHeight(context) * 0.026),
                                  SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            // if(_.areaOfExpertiseTEC.text.isEmpty
                                            //     || _.yearsOfExpTEC.text.isEmpty
                                            //     || _.preferredLangTEC.text.isEmpty
                                            //     || _.selectedWorkStatus.value.isEmpty
                                            //     || _.companyEditingController.text.isEmpty){
                                            //   displaySnackBar("A field is empty", context);
                                            // }
                                            // else{
                                            //   Get.toNamed(Routes.REGISTRATION_FOUR);
                                            // }

                                            Get.toNamed(Routes.REGISTRATION_FOUR);

                                          },
                                          style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 0,
                                                  vertical: 20),
                                              primary: kPrimaryColor),
                                          child: Text(
                                            'Next',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                              displayWidth(context) /
                                                  28,
                                            ),
                                          )))
                                ],
                              ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ))));
  }

  //Display consultant code entry field
  void _showModalBottomSheet(
      BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(displayWidth(context) * 0.08),
            height: displayHeight(context) * 0.42,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Consultant Entry \nCode',
                    style: TextStyle(
                        fontSize: displayWidth(context) * 0.048,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor)),
                SizedBox(height: displayHeight(context) * 0.04),
                TextFormField(
                    controller: consult.entryCodeTEC,
                    decoration: InputDecoration(
                      labelText: 'Entry Code',
                      fillColor: Colors.transparent,
                      filled: true,
                      hintText: "Enter consultant entry code: code411",
                      hintStyle: TextStyle(
                          fontSize: displayWidth(context) / 25,
                          color: Colors.grey),
                      // If  you are using latest version of flutter then lable text and hint text shown like this
                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      //prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
                    )),
                SizedBox(height: displayHeight(context) * 0.03),
                Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: displayHeight(context) * 0.06,
                      child: ElevatedButton(
                          onPressed: () {
                            if (consult.entryCodeTEC.text.isNull) {
                              //..
                            } else if (consult.entryCodeTEC.text.trim() != 'code411') {
                             // _showMyDialog();
                            } else {
                              Navigator.pushNamed(context, Routes.REGISTRATION_ONE);
                              _.userType.value = consultant;
                            }
                          },
                          child: Text('Next',
                              style: TextStyle(
                                  fontSize: displayWidth(context) * 0.040))),
                    ))
              ],
            ),
          );
        });
  }
}
