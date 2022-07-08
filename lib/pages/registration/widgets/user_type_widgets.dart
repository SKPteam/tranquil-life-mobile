import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/app_font.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/general_widgets/custom_form_field.dart';
import 'package:tranquil_life/general_widgets/custom_snackbar.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';
import 'package:tranquil_life/routes/app_pages.dart';
import 'package:tranquil_life/services/media_service.dart';

Widget userTypeWidgets(){
  if(onBoardingController.userType.value == client)
  {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: CustomFormField(
            textInputType: TextInputType.text,
            formatters: [],
            hint: 'Username',
            onTap: () {},
            showCursor: true,
            obscureText: false,
            onSuffixTap: () {},
            textEditingController: registrationTwoController
                .userNameTextEditingController,
            icon: const SizedBox(),
          ),
        ),
        SizedBox(
            height: displayHeight(Get.context!) * 0.02),
        ClipRRect(
          borderRadius: BorderRadius.circular(
              4),
          child: CustomFormField(
            textInputType: TextInputType.text,
            formatters: [],
            hint: 'Date of birth',
            onTap: () {},
            showCursor: true,
            obscureText: false,
            onSuffixTap: () {},
            textEditingController: registrationTwoController
                .dobTextEditingController,
            icon: const SizedBox(),
          ),
        ),
        SizedBox(height: displayHeight(Get.context!) * 0.03),
        SizedBox(
          width: displayWidth(Get.context!) * 0.6,
          height: 60,
          child: ElevatedButton(
              onPressed: () async{
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
                  CustomSnackBar.showSnackBar(
                      context: Get.context!,
                      title: "Error",
                      message: kFirstNameNullError,
                      backgroundColor: Colors.red);
                }
                else
                if (registrationTwoController
                    .lastNameTextEditingController
                    .text.isEmpty) {
                  CustomSnackBar.showSnackBar(
                      context: Get.context!,
                      title: "Error",
                      message: kLastNameNullError,
                      backgroundColor: Colors.red);
                }
                else
                if (registrationTwoController
                    .userNameTextEditingController
                    .text.isEmpty) {
                  CustomSnackBar.showSnackBar(
                      context: Get.context!,
                      title: "Error",
                      message: kUserNameNullError,
                      backgroundColor: Colors.red);
                }
                else
                if (registrationTwoController
                    .usernameExists.value) {
                  CustomSnackBar.showSnackBar(
                      context: Get.context!,
                      title: "Error",
                      message: kUserNameExists,
                      backgroundColor: Colors.red);
                }
                else
                if (registrationTwoController
                    .age.value < 16) {
                  CustomSnackBar.showSnackBar(
                      context: Get.context!,
                      title: "Error",
                      message: kTooYoungError,
                      backgroundColor: Colors.red);
                }
                else {
                  //Get.toNamed(Routes.REGISTRATION_THREE);
                }
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 20),
                  primary: kPrimaryColor),
              child: const Text(
                'Next',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              )),
        ),
        SizedBox(height: displayHeight(Get.context!) * 0.040),
      ],
    );
  }
  else{
    return Column(
      children: [
        SizedBox(height: displayHeight(Get.context!) * 0.002),
        ClipRRect(
          borderRadius: BorderRadius.circular(
              4),
          child: CustomFormField(
            textInputType: TextInputType.text,
            formatters: [],
            hint: 'Date of birth',
            onTap: () {
              registrationTwoController.selectDate(Get.context!);
            },
            showCursor: true,
            obscureText: false,
            onSuffixTap: () {},
            textEditingController: registrationTwoController
                .dobTextEditingController,
            icon: const SizedBox(),
          ),
        ),
        SizedBox(height: displayHeight(Get.context!) * 0.020),

        //Diriver's license
        ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: TextFormField(
            style: const TextStyle(fontSize: 18, color: Colors.black),
            enabled: true,
            controller: registrationTwoController.passportOrDriverTEC,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: () async{
                  registrationTwoController.passportImageFile =
                  await MediaService().selectImageFromGallery();
                  registrationTwoController.passportOrDriverTEC.text
                  = registrationTwoController.passportImageFile!.path
                      .substring(registrationTwoController
                      .passportImageFile!.path.lastIndexOf('/')+1);
                },
              ),
              fillColor: const Color(0xFFF3F3F3),
              border: InputBorder.none,
              filled: true,
              hintText: "Passport or Driver\'s license",
              hintStyle: TextStyle(fontSize: 18, color: grey),
              contentPadding:
              EdgeInsets.symmetric(vertical: 25.0, horizontal: displayWidth(Get.context!) * 0.035),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
        ),

        SizedBox(height: displayHeight(Get.context!) * 0.020),

        ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: TextFormField(
            style: const TextStyle(fontSize: 18, color: Colors.black),
            enabled: true,
            controller: registrationTwoController.resumeTEC,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: () async{
                  registrationTwoController.cvFile =
                  await MediaService().pickDocument();
                  registrationTwoController.resumeTEC.text
                  = registrationTwoController.cvFile!.path
                      .substring(registrationTwoController
                      .cvFile!.path.lastIndexOf('/')+1);
                },
              ),
              fillColor: const Color(0xFFF3F3F3),
              border: InputBorder.none,
              filled: true,
              hintText: "CV or Resume",
              hintStyle: TextStyle(fontSize: 18, color: grey),
              contentPadding:
              EdgeInsets.symmetric(vertical: 25.0, horizontal: displayWidth(Get.context!) * 0.035),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
        ),

        SizedBox(height: displayHeight(Get.context!) * 0.03),
        SizedBox(
          width: displayWidth(Get.context!) * 0.6,
          height: 60,
          child: ElevatedButton(
              onPressed: () async{
                if (registrationTwoController
                    .firstNameTextEditingController
                    .text.isEmpty) {

                  CustomSnackBar.showSnackBar(
                      context: Get.context!,
                      title: "Error",
                      message: kFirstNameNullError,
                      backgroundColor: Colors.red);
                }
                else if (registrationTwoController
                    .lastNameTextEditingController
                    .text.isEmpty) {

                  CustomSnackBar.showSnackBar(
                      context: Get.context!,
                      title: "Error",
                      message: kLastNameNullError,
                      backgroundColor: Colors.red);
                }
                else if (registrationTwoController
                    .passportOrDriverTEC
                    .text.isEmpty) {

                  CustomSnackBar.showSnackBar(
                      context: Get.context!,
                      title: "Error",
                      message: "Passport or Driver's license is required",
                      backgroundColor: Colors.red);
                }
                // else if (registrationTwoController
                //     .cvPath.value.isEmpty) {
                //   CustomSnackBar.showSnackBar(
                //       context: Get.context!,
                //       title: "Error",
                //       message: "Resumé is required",
                //       backgroundColor: Colors.red);
                // }
                else if (registrationTwoController
                    .age.value < 16) {

                  CustomSnackBar.showSnackBar(
                      context: Get.context!,
                      title: "Error",
                      message: kTooYoungError,
                      backgroundColor: Colors.red);
                }
                else {
                  Get.toNamed(Routes.REGISTRATION_THREE);
                }
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 20),
                  primary: kPrimaryColor),
              child: const Text(
                'Next',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              )),
        ),
        SizedBox(height: displayHeight(Get.context!) * 0.040),
      ],
    );
  }
}