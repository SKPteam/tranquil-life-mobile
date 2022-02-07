// ignore_for_file: avoid_print

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/onboarding_controller.dart';
import 'package:tranquil_life/controllers/client_registration_controller.dart';
import 'package:tranquil_life/routes/app_pages.dart';
import 'package:tranquil_life/helpers/constants.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';
import 'package:tranquil_life/widgets/custom_snackbar.dart';
import 'package:tranquil_life/widgets/custom_form_field.dart';

class RegistrationTwoView extends GetView<ClientRegistrationController> {
  final ClientRegistrationController _ =
      Get.put(ClientRegistrationController());
  final OnBoardingController _b = Get.put(OnBoardingController());

  RegistrationTwoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx( () =>
         Scaffold(
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
                  image:
                      _b.userType.value ==
                              "client"
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
                        Text("Complete Profile",
                            style: TextStyle(
                              fontSize: displayWidth(context) / 14,
                              color: Colors.white,
                              height: displayHeight(context) * 0.0015,
                            )),
                        SizedBox(height: displayHeight(context) * 0.01),
                        Text("Complete your details",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: const Color(0xffDDDDDD),
                                fontSize: displayWidth(context) / 32)),
                        SizedBox(height: displayHeight(context) * 0.08),
                        Form(
                            child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: buildFirstNameFormField(_),
                            ),
                            SizedBox(height: displayHeight(context) * 0.020),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: buildLastNameFormField(_),
                            ),
                            SizedBox(height: displayHeight(context) * 0.020),
                            _b.userType.value ==
                                    "client"
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: buildUserNameFormField(_),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: CustomFormField(
                                      hint: 'Current Location',
                                      textEditingController:
                                          _.locationEditingController,
                                      showCursor: false,
                                      onTap: () {},
                                      togglePassword: () {},
                                      formatters: const [],
                                      obscureText: false,
                                      readOnly: true,
                                      textInputType: TextInputType.text,
                                    ),
                                  ),
                            SizedBox(height: displayHeight(context) * 0.020),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: buildDOBFormField(_),
                            ),
                            SizedBox(height: displayHeight(context) * 0.020),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: CustomFormField(
                                textEditingController:
                                    _.timeZoneEditingController,
                                hint: 'Time zone',
                                showCursor: false,
                                readOnly: true,
                                onTap: () {
                                  //_showModalBottomSheet(context);
                                },
                                obscureText: false,
                                textInputType: TextInputType.text,
                                formatters: [],
                                togglePassword: () {},
                              ),
                            ),
                            SizedBox(height: displayHeight(context) * 0.03),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () {
                                    print(_.getAge());

                                    ///if client
                                    if (onBoardingController.userType.value ==
                                        client) {
                                      if (_.firstNameTextEditingController.text
                                          .isEmpty) {
                                        displaySnackBar(
                                            kFirstNameNullError, context);
                                      } else if (_.lastNameTextEditingController
                                          .text.isEmpty) {
                                        displaySnackBar(
                                            kLastNameNullError, context);
                                      } else if (_.userNameTextEditingController
                                          .text.isEmpty) {
                                        displaySnackBar(
                                            kUserNameNullError, context);
                                      } else if (_.dobTextEditingController.value
                                          .text.isEmpty) {
                                        displaySnackBar(kAgeNullError, context);
                                      } else if (_.age < 16) {
                                        displaySnackBar(kTooYoungError, context);
                                      } else {
                                        _.usernames.contains(_
                                                .userNameTextEditingController
                                                .text)
                                            ? displaySnackBar(
                                                kUserNameExists, context)
                                            : Get.toNamed(
                                                Routes.REGISTRATION_THREE);

                                      }
                                    } else {
                                      /// if consultant
                                      if (_.firstNameTextEditingController.text
                                          .isEmpty) {
                                        displaySnackBar(
                                            kFirstNameNullError, context);
                                      } else if (_.lastNameTextEditingController
                                          .text.isEmpty) {
                                        displaySnackBar(
                                            kLastNameNullError, context);
                                      }
                                      // else if (_.locationEditingController.text
                                      //     .isEmpty) {
                                      //   displaySnackBar(
                                      //       'Location Unavailable', context);
                                      // }
                                      else if (_.dobTextEditingController.value
                                          .text.isEmpty) {
                                        displaySnackBar(kAgeNullError, context);
                                      } else if (_.age < 16) {
                                        displaySnackBar(kTooYoungError, context);
                                      } else {
                                        _.usernames.contains(_
                                                .userNameTextEditingController
                                                .text)
                                            ? displaySnackBar(
                                                kUserNameExists, context)
                                            : Get.toNamed(Routes.REGISTRATION_THREE);
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 20),
                                      primary: kPrimaryColor),
                                  child: Text(
                                    'Next',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: displayWidth(context) / 28,
                                    ),
                                  )),
                            ),
                            SizedBox(height: displayHeight(context) * 0.040),
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
        ),
      ),
    );
  }

  TextFormField buildFirstNameFormField(ClientRegistrationController controller) {
    return TextFormField(
      controller: controller.firstNameTextEditingController,
      style: TextStyle(
          fontSize: displayWidth(Get.context!) / 30, color: Colors.black),
      decoration: InputDecoration(
        hintText: "first name",
        hintStyle: TextStyle(
            fontSize: displayWidth(Get.context!) / 30, color: Colors.grey),
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
            vertical: 25.0, horizontal: displayWidth(Get.context!) * 0.04),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildLastNameFormField(ClientRegistrationController controller) {
    return TextFormField(
      controller: controller.lastNameTextEditingController,
      style: TextStyle(
          fontSize: displayWidth(Get.context!) / 30, color: Colors.black),
      decoration: InputDecoration(
        hintText: "last name",
        hintStyle: TextStyle(
            fontSize: displayWidth(Get.context!) / 30, color: Colors.grey),
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
            vertical: 25.0, horizontal: displayWidth(Get.context!) * 0.04),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildUserNameFormField(ClientRegistrationController controller) {
    return TextFormField(
      controller: controller.userNameTextEditingController,
      style: TextStyle(
          fontSize: displayWidth(Get.context!) / 30, color: Colors.black),
      decoration: InputDecoration(
        hintText: "username",
        hintStyle: TextStyle(
            fontSize: displayWidth(Get.context!) / 30, color: Colors.grey),
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
            vertical: 25.0, horizontal: displayWidth(Get.context!) * 0.04),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildDOBFormField(ClientRegistrationController controller) {
    return TextFormField(
      controller: controller.dobTextEditingController,
      showCursor: false,
      readOnly: true,
      onTap: () {
        controller.selectDate(Get.context!);
      },
      style: TextStyle(
          fontSize: displayWidth(Get.context!) / 30, color: Colors.black),
      decoration: InputDecoration(
        hintText: "age",
        hintStyle: TextStyle(
            fontSize: displayWidth(Get.context!) / 30, color: Colors.grey),
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
            vertical: 25.0, horizontal: displayWidth(Get.context!) * 0.04),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
