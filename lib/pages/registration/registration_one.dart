// ignore_for_file: avoid_print, prefer_const_constructors

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

class RegistrationOneView extends StatelessWidget {
  final ClientRegistrationController _ =
      Get.put(ClientRegistrationController());

  final OnBoardingController obc = Get.put(OnBoardingController());


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //resizeToAvoidBottomPadding: false,
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
                    clientRegistrationController.userType.value == "client"
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
          horizontal: displayWidth(context) * 0.1),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: displayHeight(context) * 0.08),
              // 4%
              Text("Register Account",
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
                        child: buildEmailFormField(),
                      ),
                      SizedBox(
                          height: displayHeight(context) * 0.02),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                            width: double.infinity,
                            height: displayHeight(context)* 0.08,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal:
                                  displayWidth(context) *
                                      0.024),
                              child: Row(
                                children: [
                                  countryCodePicker(),
                                  Flexible(
                                      flex: 2,
                                      child: TextFormField(
                                        keyboardType:
                                        TextInputType.number,
                                        controller: _.phoneNumTextEditingController,
                                        style: TextStyle(
                                            fontSize: displayWidth(Get.context!) / 30,
                                            color: Colors.black
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'phone number',
                                          hintStyle:
                                          TextStyle(fontSize: displayWidth(context) / 30, color: Colors.grey),
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                        ),
                                      )),
                                ],
                              ),
                            )),
                      ),
                      SizedBox(
                          height: displayHeight(context) * 0.020),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: buildPasswordFormField(),
                      ),
                      SizedBox(
                          height: displayHeight(context) * 0.020),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: buildConformPassFormField(),
                      ),
                      SizedBox(
                          height: displayHeight(context) * 0.045),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              // String phoneNumber =
                              //     '${_.countryCode}${_.phoneNumTextEditingController.text.replaceAll(RegExp(r'^0+(?=.)'), '')}';
                              //
                              // if (_.emailTextEditingController
                              //     .text.isEmpty) {
                              //   _.displaySnackBar(
                              //       kEmailNullError, context);
                              // } else if (!emailValidatorRegExp
                              //     .hasMatch(_
                              //     .emailTextEditingController
                              //     .text)) {
                              //   _.displaySnackBar(
                              //       kInvalidEmailError, context);
                              // } else if (_
                              //     .passwordTextEditingController
                              //     .text
                              //     .isEmpty) {
                              //   _.displaySnackBar(
                              //       kPassNullError, context);
                              // } else if (_
                              //     .passwordTextEditingController
                              //     .text
                              //     .length <
                              //     6) {
                              //   _.displaySnackBar(
                              //       kShortPassError, context);
                              // } else if (_
                              //     .passwordTextEditingController
                              //     .text !=
                              //     _.confirmPwdTextEditingController
                              //         .text) {
                              //   _.displaySnackBar(
                              //       kMatchPassError, context);
                              // } else if (!passwordValidatorRegExp
                              //     .hasMatch(_
                              //     .passwordTextEditingController
                              //     .text)) {
                              //   _.displaySnackBar(
                              //       kInvalidPassError, context);
                              // } else if (_.countryCode == null) {
                              //   _.displaySnackBar(
                              //       'Select a country code',
                              //       context);
                              // } else {
                              //   Get.toNamed(Routes.REGISTRATION_TWO);
                              // }
                              print("The new value of my serach is ${onBoardingController.userType.value}");
                              Get.toNamed(Routes.REGISTRATION_TWO);

                            },
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 20),
                                primary: kPrimaryColor),
                            child: Text(
                              'Next',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                displayWidth(context) / 28,
                              ),
                            )),
                      ),
                      SizedBox(
                          height: displayHeight(context) * 0.06),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              child: Column(children: [
                                Text(
                                    'By clicking Next, you are indicating that you have ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize:
                                        displayWidth(context) /
                                            30)),
                                Row(
                                  children: [
                                    Text(' read and agreed to the ',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: displayWidth(
                                                context) /
                                                30)),
                                    Text('Terms of Service ',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: kSecondaryColor,
                                            fontSize: displayWidth(
                                                context) /
                                                30)),
                                    Text('and ',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: displayWidth(
                                                context) /
                                                30)),
                                  ],
                                ),
                                Text('Privacy Policy',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: kSecondaryColor,
                                        fontSize:
                                        displayWidth(context) /
                                            30)),
                                SizedBox(
                                    height:
                                    displayHeight(context) * 0.04)
                              ]))
                        ],
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
      ],
    )
    ),
      ),   );
  }

  CountryCodePicker countryCodePicker() {
    return CountryCodePicker(
      //when the picker is created for first time this is executed, we set the empty countryCode variable to the initial value
      onInit: (_countryCode) {
        _.countryCode = _countryCode.toString();
      },
      flagWidth: displayWidth(Get.context!)/18,
      initialSelection: 'NG',
      favorite: const ['+234', 'NG'],
      onChanged: (_countryCode) {
        _.countryCode = _countryCode.toString();
        print("New Country selected: " + _.countryCode.toString());
      },
      // optional. Shows only country name and flag
      showFlag: true,
      showDropDownButton: true,
      showCountryOnly: false,
      // optional. Shows only country name and flag when popup is closed.
      showOnlyCountryWhenClosed: false,
      // optional. aligns the flag and the Text left
      alignLeft: false,
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      style: TextStyle(
          fontSize: displayWidth(Get.context!) / 30,
          color: Colors.black
      ),
      controller: _.emailTextEditingController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        hintText: "email",
        hintStyle: TextStyle(
            fontSize: displayWidth(Get.context!) / 30, color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(
            vertical: 25.0, horizontal: displayWidth(Get.context!) * 0.04),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

// Toggles to make password visible

  TextFormField buildPasswordFormField() {
    return TextFormField(
      style: TextStyle(
          fontSize: displayWidth(Get.context!) / 30,
          color: Colors.black
      ),
      controller: _.passwordTextEditingController,
      obscureText: _.obscureText.value,
      decoration: InputDecoration(
        suffix: InkWell(
            onTap: () {
              _.togglePassword();
            },
            child: Icon(_.obscureText.value
                ? Icons.visibility
                : Icons.visibility_off)),
        hintText: "password",
        hintStyle: TextStyle(
            fontSize: displayWidth(Get.context!) / 30, color: Colors.grey),
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
            vertical: 20.0, horizontal: displayWidth(Get.context!) * 0.04),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      style: TextStyle(
          fontSize: displayWidth(Get.context!) / 30,
          color: Colors.black
      ),
      controller: _.confirmPwdTextEditingController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "re-enter your password",
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
        //prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }
}




