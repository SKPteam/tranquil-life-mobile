// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/onboarding_controller.dart';
import 'package:tranquil_life/controllers/registration_two_controller.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/routes/app_pages.dart';
import 'package:tranquil_life/widgets/custom_snackbar.dart';
import 'package:tranquil_life/widgets/custom_form_field.dart';
import 'package:tranquil_life/widgets/custom_text.dart';

class RegistrationTwoView extends GetView<RegistrationTwoController> {
  final OnBoardingController obc = Get.put(OnBoardingController());

  RegistrationTwoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
        responsiveBuilder: (context, size) =>
            Obx(() =>
                Scaffold(
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
                                Text("Complete Profile",
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      height: size.height * 0.0015,
                                    )),
                                SizedBox(height: size.height * 0.02),
                                Text("Complete your details",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xffDDDDDD),
                                        fontSize: 18)),
                                SizedBox(height: size.height * 0.08),
                                Form(
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              4),
                                          child: buildFirstNameFormField(
                                              Get.put(
                                                  RegistrationTwoController()),
                                              size),
                                        ),
                                        SizedBox(height: size.height * 0.020),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              4),
                                          child: buildLastNameFormField(Get.put(
                                              RegistrationTwoController()),
                                              size),
                                        ),
                                        SizedBox(height: size.height * 0.020),
                                        onBoardingController.userType.value ==
                                            client
                                            ?
                                        Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius
                                                  .circular(4),
                                              child: buildUserNameFormField(
                                                  Get.put(
                                                      RegistrationTwoController()),
                                                  size),
                                            ),
                                            SizedBox(
                                                height: size.height * 0.02),
                                          ],
                                        )
                                            :
                                        SizedBox(height: size.height * 0.002),

                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              4),
                                          child: buildDOBFormField(Get.put(
                                              RegistrationTwoController()),
                                              size),
                                        ),
                                        SizedBox(height: size.height * 0.020),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              4),
                                          child: identityDocField(size),
                                        ),
                                        SizedBox(height: size.height * 0.020),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              4),
                                          child: cvDocField(size),
                                        ),
                                        // ClipRRect(
                                        //   borderRadius: BorderRadius.circular(4),
                                        //   child: CustomFormField(
                                        //     textEditingController:
                                        //     _.timeZoneEditingController,
                                        //     hint: 'Time zone',
                                        //     showCursor: false,
                                        //     readOnly: true,
                                        //     onTap: () {
                                        //       //_showModalBottomSheet(context);
                                        //     },
                                        //     obscureText: false,
                                        //     textInputType: TextInputType.text,
                                        //     formatters: [],
                                        //     togglePassword: () {},
                                        //   ),
                                        // ),
                                        SizedBox(height: size.height * 0.03),
                                        SizedBox(
                                          width: size.width * 0.6,
                                          height: 60,
                                          child: ElevatedButton(
                                              onPressed: () async {
                                                await registrationTwoController
                                                    .checkForUsername()
                                                    .then((value) {
                                                  if (kUserNameExists ==
                                                      value) {
                                                    registrationTwoController
                                                        .usernameExists.value =
                                                    true;
                                                  } else {
                                                    registrationTwoController
                                                        .usernameExists.value =
                                                    false;
                                                  }
                                                }).onError((error, stackTrace) {
                                                  print(
                                                      "CHECK FOR USERNAME: ERROR: $error");
                                                });


                                                if (registrationTwoController
                                                    .firstNameTextEditingController
                                                    .text.isEmpty) {
                                                  displaySnackBar(
                                                      kFirstNameNullError,
                                                      context);
                                                }
                                                else
                                                if (registrationTwoController
                                                    .lastNameTextEditingController
                                                    .text.isEmpty) {
                                                  displaySnackBar(
                                                      kLastNameNullError,
                                                      context);
                                                }
                                                else
                                                if (registrationTwoController
                                                    .userNameTextEditingController
                                                    .text.isEmpty) {
                                                  displaySnackBar(
                                                      kUserNameNullError,
                                                      context);
                                                }
                                                else
                                                if (registrationTwoController
                                                    .usernameExists.value) {
                                                  displaySnackBar(
                                                      kUserNameExists, context);
                                                }
                                                else
                                                if (registrationTwoController
                                                    .age.value < 16) {
                                                  displaySnackBar(
                                                      kTooYoungError, context);
                                                }
                                                else {
                                                  Get.toNamed(
                                                      Routes
                                                          .REGISTRATION_THREE);
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 20),
                                                  primary: kPrimaryColor),
                                              child: Text(
                                                'Next',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                              )),
                                        ),
                                        SizedBox(height: size.height * 0.040),
                                      ],
                                    ))
                              ],
                            ),
                            //end
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
    );
  }


  TextFormField buildFirstNameFormField(RegistrationTwoController _,
      Size size) {
    return TextFormField(
      controller: _.firstNameTextEditingController,
      style: TextStyle(
          fontSize: 18, color: Colors.black),
      decoration: InputDecoration(
        hintText: "first name",
        hintStyle: TextStyle(
            fontSize: 18, color: Colors.grey),
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
            vertical: 25.0, horizontal: size.width * 0.04),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildLastNameFormField(RegistrationTwoController _, Size size) {
    return TextFormField(
      controller: _.lastNameTextEditingController,
      style: TextStyle(
          fontSize: 18, color: Colors.black),
      decoration: InputDecoration(
        hintText: "last name",
        hintStyle: TextStyle(
            fontSize: 18, color: Colors.grey),
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
            vertical: 25.0, horizontal: size.width * 0.04),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }


  TextFormField buildUserNameFormField(RegistrationTwoController _, Size size) {
    return TextFormField(
      controller: _.userNameTextEditingController,
      style: TextStyle(
          fontSize: 18, color: Colors.black),
      decoration: InputDecoration(
        hintText: "username",
        hintStyle: TextStyle(
            fontSize: 18, color: Colors.grey),
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
            vertical: 25.0, horizontal: size.width * 0.04),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildDOBFormField(RegistrationTwoController _, Size size) {
    return TextFormField(
      controller: _.dobTextEditingController,
      showCursor: false,
      readOnly: true,
      onTap: () {
        _.selectDate(Get.context!);
      },
      style: TextStyle(
          fontSize: 18, color: Colors.black),
      decoration: InputDecoration(
        hintText: "age",
        hintStyle: TextStyle(
            fontSize: 18, color: Colors.grey),
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
            vertical: 25.0, horizontal: size.width * 0.04),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  Container identityDocField(Size size) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: light,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 25.0, horizontal: size.width * 0.04
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Passport or Driver's License",
                size: 18,
                weight: FontWeight.normal,
                align: TextAlign.start,
                key: null,
                color: Colors.grey,
              ),

              Icon(
                Icons.attach_file,
              )
            ],
          ),
        )
    );
  }

  Container cvDocField(Size size) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: light,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 25.0, horizontal: size.width * 0.04
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Upload your resumé",
                size: 18,
                weight: FontWeight.normal,
                align: TextAlign.start,
                key: null,
                color: Colors.grey,
              ),

              Icon(
                Icons.attach_file,
              )
            ],
          ),
        )
    );
  }

}

// ClipRRect(
//                                         borderRadius: BorderRadius.circular(4),
//                                         child: CustomFormField(
//                                           hint: 'Current Location',
//                                           textEditingController:
//                                           _.locationEditingController,
//                                           showCursor: false,
//                                           onTap: () {},
//                                           togglePassword: () {},
//                                           formatters: [],
//                                           obscureText: false,
//                                           readOnly: true,
//                                           textInputType: TextInputType.text,
//                                         ),
