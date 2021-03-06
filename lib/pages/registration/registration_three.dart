// ignore_for_file: prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/registration_one_controller.dart';
import 'package:tranquil_life/controllers/registration_three_controller.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/pages/registration/registration_four.dart';
import 'package:tranquil_life/routes/app_pages.dart';
import 'package:tranquil_life/general_widgets/custom_snackbar.dart';
import 'package:tranquil_life/general_widgets/custom_form_field.dart';

import '../../constants/app_font.dart';
import '../../general_widgets/custom_flushbar.dart';

class RegistrationThreeView extends StatefulWidget {
  const RegistrationThreeView({Key? key}) : super(key: key);

  @override
  State<RegistrationThreeView> createState() => _RegistrationThreeViewState();
}

class _RegistrationThreeViewState extends State<RegistrationThreeView> {
  // _signIn() async {
  //   FocusScope.of(context).unfocus();
  //   if(_formKeySignIn.currentState!.validate()){
  //     _formKeySignIn.currentState!.save();
  //     registrationThreeController.registerClient();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
        responsiveBuilder: (context, size)
        => Obx(() => Scaffold(
            key: registrationThreeController.scaffoldKey,
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
                    image:
                    onBoardingController.userType.value == client
                        ? AssetImage('assets/images/bg_img1.png')
                        : AssetImage('assets/images/bg_img2.png'),
                    colorFilter: ColorFilter.mode(
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
                            key: registrationThreeController.formKey,
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
                                  //             registrationThreeController.country.value,
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
                                      //validator: (value) => (value!.isEmpty? "Please enter your Company Id" : null),
                                      // onChanged: (value){
                                      //   regOneController.companyID = value;
                                      // },
                                      textEditingController: registrationThreeController.companyEditingController,
                                      hint: "Name of your organisation",
                                      readOnly: true,
                                      onTap: () {
                                        registrationThreeController.partnerListDialog(Get.context!, size);
                                      },
                                      obscureText: false,
                                      onSuffixTap: () {},
                                      textInputType: TextInputType.text,
                                      formatters: const [],
                                      showCursor: false,
                                      icon: const SizedBox(),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                      size.height * 0.02),
                                  Visibility(
                                    visible: registrationThreeController.orgSelected.value,
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
                                        onSuffixTap: () {},
                                        textInputType: TextInputType.text,
                                        formatters: const [],
                                        showCursor: true,
                                        icon: const SizedBox(),
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
                                        onPressed: () async{
                                          // registrationThreeController.registerClient();
                                          // print("registering client");

                                          if(registrationThreeController
                                              .companyEditingController.text
                                              .isNotEmpty){
                                            if(registrationThreeController
                                                .companyEditingController
                                                .text !=
                                                'None' &&
                                                registrationThreeController
                                                    .staffIDEditingController
                                                    .value.text.isEmpty)
                                            {
                                              CustomSnackBar.showSnackBar(
                                                  context: context,
                                                  title: "Error",
                                                  message: "Type in your staff ID",
                                                  backgroundColor: active);


                                            } else if (registrationThreeController
                                              .companyEditingController.text ==
                                              'None' &&
                                              registrationThreeController
                                                  .staffIDEditingController
                                                  .value.text.isEmpty)
                                            {
                                              await registrationThreeController.registerClient();
                                              print("registering client");

                                              //Navigator.push(context, MaterialPageRoute(builder: (context)=>SignIn()));
                                              Get.offAllNamed(Routes.SIGN_IN);

                                            }else{
                                              registrationThreeController.getStaff().then((value){
                                                if (value["message"] == "does not exist") {
                                                  showDialog(
                                                      context: Get.context!,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text("Contact your company's HR",
                                                              style: TextStyle(fontFamily: josefinSansSemiBold)),
                                                          content: Text(
                                                              "Sorry, no staff with this id in "
                                                                  "${registrationThreeController.companyEditingController
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

                                                  return value["message"];
                                                }
                                                else {
                                                  showDialog(
                                                      context: Get.context!,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text(value["staff"]["company_email"].toString(),
                                                              style: TextStyle(fontFamily: josefinSansSemiBold)),
                                                          content: Text(
                                                              "To gain access to your consultation discount, use your company email."),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () async {
                                                                  registrationOneController.emailTextEditingController
                                                                      .text = value["staff"]["company_email"].toString();

                                                                  CustomSnackBar.showSnackBar(
                                                                      context: context,
                                                                      title: "Error",
                                                                      message: "Email: ${registrationOneController
                                                                          .emailTextEditingController.text}",
                                                                      backgroundColor: active);

                                                                  print(
                                                                      "${registrationTwoController.dobTextEditingController
                                                                          .text.trim()}, "
                                                                          "${registrationOneController
                                                                          .phoneNumTextEditingController.text}");

                                                                  if (registrationThreeController
                                                                      .companyEditingController
                                                                      .text.isNotEmpty) {
                                                                    if (registrationThreeController
                                                                        .companyEditingController
                                                                        .text !=
                                                                        'None' && registrationThreeController
                                                                        .staffIDEditingController
                                                                        .value.text.isEmpty) {

                                                                      CustomSnackBar.showSnackBar(
                                                                          context: context,
                                                                          title: "Error",
                                                                          message: 'Type in your staff ID',
                                                                          backgroundColor: active);

                                                                    } else if (
                                                                    registrationThreeController
                                                                        .companyEditingController.text == 'None'
                                                                        && registrationThreeController
                                                                        .staffIDEditingController
                                                                        .value.text.isEmpty)
                                                                    {
                                                                      Navigator.of(context).pop();
                                                                      //register client
                                                                      await registrationThreeController.registerClient();

                                                                      Get.offAllNamed(Routes.SIGN_IN);

                                                                    } else {
                                                                      Navigator.of(context).pop();

                                                                      //register client
                                                                      await registrationThreeController.registerClient();

                                                                      Get.offAllNamed(Routes.SIGN_IN);

                                                                    }
                                                                  }
                                                                  else {
                                                                    CustomSnackBar.showSnackBar(
                                                                        context: context,
                                                                        title: "Error",
                                                                        message: 'Select your company or organisation',
                                                                        backgroundColor: active);
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
                                                  return value["staff"];
                                                }
                                              });
                                            }
                                          }
                                          else {
                                            CustomSnackBar.showSnackBar(
                                                context: context,
                                                title: "Error",
                                                message: 'Select your company or organisation',
                                                backgroundColor: active);
                                          }
                                          // if (registrationThreeController
                                          //     .companyEditingController
                                          //     .text.isNotEmpty) {
                                          //   if (registrationThreeController
                                          //       .companyEditingController
                                          //       .text !=
                                          //       'None' &&
                                          //       registrationThreeController
                                          //           .staffIDEditingController
                                          //           .value.text.isEmpty) {
                                          //     displaySnackBar(
                                          //         'Type in your staff ID ',
                                          //         context);
                                          //   } else if (registrationThreeController
                                          //       .companyEditingController.text ==
                                          //       'None' &&
                                          //       registrationThreeController
                                          //           .staffIDEditingController
                                          //           .value.text.isEmpty)
                                          //   {
                                          //     registrationThreeController.registerClient();
                                          //     print("registering client");
                                          //   }
                                          //   else {

                                          //   }
                                          // }
                                          // else {
                                          //   displaySnackBar(
                                          //       'Select your company or organisation',
                                          //       context);
                                          // }
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
                                      registrationThreeController.areaOfExpertiseTEC,
                                      onTap: () {
                                        registrationThreeController
                                            .areaOfExpertiseTEC.text = '';
                                        registrationThreeController
                                            .showAOEModalBottomSheet(context);
                                      },
                                      textInputType: TextInputType.text,
                                      onSuffixTap: () {},
                                      formatters: [],
                                      obscureText: false,
                                      showCursor: false,
                                      icon: const SizedBox(),
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
                                      registrationThreeController.yearsOfExpTEC,
                                      readOnly: true,
                                      onTap: () async{
                                        // registrationThreeController
                                        //     .showYOEModalBottomSheet(
                                        //     context);

                                        ///Years of experience list
                                        await Get.bottomSheet(
                                            Container(
                                              decoration: BoxDecoration(color: Colors.white),
                                              height: size.height * 0.5,
                                              padding: EdgeInsets.fromLTRB(
                                                  16.0, 16.0, 16.0, 0),
                                              child:Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("Years of experience", style: TextStyle(fontSize: 18, fontFamily: josefinSansBold)),

                                                  SizedBox(height: size.height*0.02),
                                                   Expanded(
                                                       child: ListView.builder(
                                                           shrinkWrap: true,
                                                           itemCount: registrationThreeController.yearsOfExperienceList.length,
                                                           itemBuilder: (BuildContext context,
                                                               int index){
                                                             return ListTile(
                                                               title: InkWell(
                                                                 onTap: () async{
                                                                   registrationThreeController.yearsOfExpTEC.text = registrationThreeController.yearsOfExperienceList[index].toString()+" years";
                                                                 },
                                                                 child: Text(registrationThreeController.yearsOfExperienceList[index]+" years"),
                                                               ),
                                                             );
                                                           }
                                                       ),
                                                   )
                                                ],
                                              ),
                                            )
                                        );
                                      },
                                      textInputType: TextInputType.text,
                                      onSuffixTap: () {},
                                      formatters: [],
                                      obscureText: false,
                                      showCursor: false,
                                      icon: const SizedBox(),

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
                                      onSuffixTap: () {},
                                      formatters: [],
                                      obscureText: false,
                                      icon: const SizedBox(),
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
                                      onSuffixTap: () {},
                                      textInputType: TextInputType.text,
                                      formatters: const [],
                                      showCursor: true,
                                      icon: const SizedBox(),
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
                                            // if(registrationThreeController.areaOfExpertiseTEC.text.isEmpty
                                            //     || registrationThreeController.yearsOfExpTEC.text.isEmpty
                                            //     || registrationThreeController.preferredLangTEC.text.isEmpty
                                            //     || registrationThreeController.selectedWorkStatus.value.isEmpty
                                            //     || registrationThreeController.companyEditingController.text.isEmpty){
                                            //   displaySnackBar("A field is empty", context);
                                            // }
                                            // else{
                                            //   Get.toNamed(Routes.REGISTRATION_FOUR);
                                            // }

                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> RegistrationFourView()));

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

