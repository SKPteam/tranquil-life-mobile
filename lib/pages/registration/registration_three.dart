// ignore_for_file: prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/consultant_registration_controller.dart';
import 'package:tranquil_life/controllers/onboarding_controller.dart';
import 'package:tranquil_life/controllers/registration_three_controller.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/routes/app_pages.dart';
import 'package:tranquil_life/widgets/custom_snackbar.dart';
import 'package:tranquil_life/widgets/custom_form_field.dart';
import 'package:tranquil_life/widgets/custom_form_field.dart';
import 'package:tranquil_life/widgets/progress_dialog.dart';

class RegistrationThreeView extends GetView<RegistrationThreeController> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final OnBoardingController obc = Get.put(
      OnBoardingController());
  
  RegistrationThreeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
        responsiveBuilder: (context, size)
        => Obx(() => Scaffold(
            key: scaffoldKey,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                "Sign Up",
                style: TextStyle(color: Color(0xffBEBEBE)),
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: onBoardingController.userType.value ==
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
                        horizontal: size.width * 0.1),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: size.height * 0.08), // 4%
                          Text("Register Account",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                height: size.height * 0.0015,
                              )),
                          SizedBox(height: size.height * 0.02),
                          Text("Build your biography",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: const Color(0xffDDDDDD),
                                  fontSize: 18)),
                          SizedBox(height: size.height * 0.08),
                          Form(
                              child: onBoardingController
                                  .userType
                                  .value ==
                                  client
                                  ? Column(
                                children: [
                                  //Country
                                  // Container(
                                  //     height:
                                  //     size.height * 0.070,
                                  //     decoration: BoxDecoration(
                                  //       border: Border.all(
                                  //           color: Colors.white),
                                  //       borderRadius:
                                  //       BorderRadius.circular(4.0),
                                  //     ),
                                  //     alignment: Alignment.centerLeft,
                                  //     child: Row(
                                  //       children: [
                                  //         Padding(
                                  //           padding: EdgeInsets.symmetric(
                                  //               horizontal: size.width *
                                  //                   0.04),
                                  //           child: Text(
                                  //             _.country.value,
                                  //             style: TextStyle(
                                  //               color: Colors.white,
                                  //               fontSize: 18,
                                  //             ),
                                  //           ),
                                  //         )
                                  //       ],
                                  //     )),
                                  // SizedBox(
                                  //     height:
                                  //     size.height * 0.02),
                                  ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(4.0),
                                    child: CustomFormField(
                                      textEditingController:
                                      registrationThreeController
                                          .companyEditingController,
                                      hint: "Name of your organisation",
                                      readOnly: true,
                                      onTap: () {
                                        registrationThreeController
                                            .partnerListDialog(Get.context!, size);
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
                                      size.height * 0.02),
                                  Visibility(
                                    visible: registrationThreeController
                                        .orgSelected.value,
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(4.0),
                                      child: CustomFormField(
                                        textEditingController: registrationThreeController.staffIDEditingController,
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
                                      size.height * 0.03),
                                  SizedBox(
                                    width: size.width * 0.6,
                                    height: 60,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          // print(
                                          //     "${registrationThreeController.dobTextEditingController.text.trim()},"
                                          //         " ${registrationThreeController.currentLocation.toString()}, "
                                          //         "${registrationThreeController.country} ${registrationThreeController.phoneTextEditingController.text}");
                                          if (registrationThreeController
                                              .companyEditingController
                                              .text.isNotEmpty) {
                                            if (registrationThreeController
                                                .companyEditingController
                                                .text !=
                                                'none' &&
                                                registrationThreeController
                                                    .staffIDEditingController
                                                    .value.text.isEmpty) {
                                              displaySnackBar(
                                                  'Type in your staff ID ',
                                                  context);
                                            } else if (registrationThreeController
                                                .companyEditingController
                                                .text ==
                                                'None' &&
                                                registrationThreeController
                                                    .staffIDEditingController
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
                                            fontSize: 18
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
                                      registrationThreeController
                                          .areaOfExpertiseTEC,
                                      onTap: () {
                                        print("mdkkggd");
                                        registrationThreeController
                                            .areaOfExpertiseTEC.text = '';
                                        // ignore: prefer_const_constructors
                                        // registrationThreeController
                                        //     .showAOEModalBottomSheet(
                                        //     context);
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
                                      size.height * 0.020),
                                  ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(4),
                                    child: CustomFormField(
                                      hint: 'Years Of Experience',
                                      textEditingController:
                                      registrationThreeController
                                          .yearsOfExpTEC,
                                      readOnly: true,
                                      onTap: () {
                                        // registrationThreeController
                                        //     .showYOEModalBottomSheet(
                                        //     context);
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
                                      size.height * 0.020),
                                  ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(4),
                                    child: CustomFormField(
                                      hint: 'Preferred Languages',
                                      textEditingController:
                                      registrationThreeController
                                          .preferredLangTEC,
                                      showCursor: false,
                                      readOnly: true,
                                      onTap: () {
                                        registrationThreeController
                                            .openCupertinoLanguagePicker();
                                      },
                                      textInputType: TextInputType.text,
                                      togglePassword: () {},
                                      formatters: [],
                                      obscureText: false,
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                      size.height * 0.020),
                                  ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(4),
                                      child: Container(
                                        width:
                                        size.width * 0.80,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        color: Colors.white,
                                        child:
                                        DropdownButtonHideUnderline(
                                          child: ButtonTheme(
                                              alignedDropdown: true,
                                              child: DropdownButton(
                                                hint: Text(
                                                  'Work Status',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                value: registrationThreeController
                                                    .selectedWorkStatus
                                                    .value,
                                                onChanged: (newValue) {
                                                  registrationThreeController.selectedWorkStatus
                                                      .value =
                                                      newValue.toString();
                                                },
                                                items: registrationThreeController
                                                    .workStatusList
                                                    .map((value) {
                                                  return DropdownMenuItem(
                                                      value: value,
                                                      onTap: () {
                                                        registrationThreeController
                                                            .selectedWorkStatus
                                                            .value =
                                                            value;

                                                        print(registrationThreeController
                                                            .selectedWorkStatus
                                                            .value);
                                                      },
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: size.width *
                                                                0.06,
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
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
                                      size.height * 0.020),
                                  ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(4.0),
                                    child: CustomFormField(
                                      textEditingController:
                                      registrationThreeController
                                          .companyEditingController,
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
                                      size.height * 0.026),
                                  SizedBox(
                                      width: size.width * 0.6,
                                      height: 60,
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
                                              padding: EdgeInsets
                                                  .symmetric(
                                                  horizontal: 0,
                                                  vertical: 20),
                                              primary: kPrimaryColor),
                                          child: Text(
                                            'Next',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
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
            )))
    );
  }
}
