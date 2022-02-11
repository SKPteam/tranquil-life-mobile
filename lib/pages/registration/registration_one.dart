// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/onboarding_controller.dart';
import 'package:tranquil_life/controllers/registration_one_controller.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/routes/app_pages.dart';
import 'package:tranquil_life/widgets/custom_snackbar.dart';

class RegistrationOneView extends GetView<RegistrationOneController> {
  final OnBoardingController obc = Get.put(OnBoardingController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      responsiveBuilder: (context, size)=>
          Obx(() =>
              Scaffold(
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
                                SizedBox(height: size.height * 0.08),
                                // 4%
                                Text("Register Account",
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
                                          borderRadius: BorderRadius.circular(4),
                                          child: buildEmailFormField(size),
                                        ),
                                        SizedBox(
                                            height: size.height * 0.02),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: Container(
                                              width: double.infinity,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: size.width * 0.024),
                                                child: Row(
                                                  children: [
                                                    countryCodePicker(size),
                                                    Flexible(
                                                        flex: 2,
                                                        child: TextFormField(
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter.digitsOnly
                                                          ],
                                                          keyboardType:
                                                          TextInputType.number,
                                                          controller: registrationOneController.phoneNumTextEditingController,
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              color: Colors.black
                                                          ),
                                                          decoration: InputDecoration(
                                                            hintText: 'phone number',
                                                            hintStyle:
                                                            TextStyle(fontSize: 18, color: Colors.grey),
                                                            fillColor: Colors.white,
                                                            border: InputBorder.none,
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        SizedBox(
                                            height: size.height * 0.020),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: buildPasswordFormField(size),
                                        ),
                                        SizedBox(
                                            height: size.height * 0.020),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: buildConformPassFormField(size),
                                        ),
                                        SizedBox(
                                            height: size.height * 0.045),
                                        SizedBox(
                                          width: size.width * 0.6,
                                          height: 60,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                //  registrationOneController.phoneNumber =
                                                //      '${registrationOneController.countryCode}'
                                                //     '${registrationOneController.phoneNumTextEditingController.text
                                                //     .replaceAll(RegExp(r'^0+(?=.)'), '')}';
                                                //
                                                // if(registrationOneController
                                                //     .emailTextEditingController.text.isEmpty) {
                                                //   displaySnackBar(kEmailNullError, context);
                                                // }
                                                // else if(!emailValidatorRegExp
                                                //     .hasMatch(registrationOneController
                                                //     .emailTextEditingController
                                                //     .text)) {
                                                //   displaySnackBar(kInvalidEmailError, context);
                                                // }
                                                // else if(registrationOneController
                                                //     .passwordTextEditingController.text.isEmpty) {
                                                //   displaySnackBar(kPassNullError, context);
                                                // }
                                                // else if(registrationOneController
                                                //     .passwordTextEditingController.text
                                                //     .length < 6) {
                                                //   displaySnackBar(
                                                //       kShortPassError, context);
                                                // }
                                                // else if (registrationOneController
                                                //     .passwordTextEditingController
                                                //     .text != registrationOneController
                                                //     .confirmPwdTextEditingController.text) {
                                                //   displaySnackBar(
                                                //       kMatchPassError, context);
                                                // }
                                                // else if (!passwordValidatorRegExp
                                                //     .hasMatch(registrationOneController
                                                //     .passwordTextEditingController
                                                //     .text)) {
                                                //   registrationOneController.displaySnackBar(
                                                //       kInvalidPassError, context);
                                                // } else if (registrationOneController
                                                //     .countryCode == null) {
                                                //   displaySnackBar(
                                                //       'Select a country code',
                                                //       context);
                                                // } else {
                                                //   Get.toNamed(Routes.REGISTRATION_TWO);
                                                // }

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
                                                  fontSize: 18,
                                                ),
                                              )),
                                        ),
                                        SizedBox(
                                            height: size.height * 0.06),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              //TODO: USE richtext widget instead

                                            child: Column(
                                                children: [
                                                  Text(
                                                      'By clicking Next, you are indicating that you have ',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16)),
                                                  Row(
                                                    children: [
                                                      Text(' read and agreed to the ',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: 16)),
                                                      Text('Terms of Service ',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              color: kSecondaryColor,
                                                              fontSize: 16)),
                                                      Text('and ',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: 16)),
                                                    ],
                                                  ),
                                                  Text('Privacy Policy',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: kSecondaryColor,
                                                          fontSize:
                                                          18)),
                                                  SizedBox(
                                                      height:
                                                      size.height * 0.04)
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
              )
          )
    );
  }

  CountryCodePicker countryCodePicker(Size size) {
    return CountryCodePicker(
      //when the picker is created for first time this is executed, we set the empty countryCode variable to the initial value
      onInit: (_countryCode) {
        registrationOneController.countryCode = _countryCode.toString();
      },
      flagWidth: size.width / 18,
      initialSelection: 'NG',
      favorite: const ['+234', 'NG'],
      onChanged: (_countryCode) {
        registrationOneController.countryCode = _countryCode.toString();
        print("New Country selected: " + registrationOneController.countryCode.toString());
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

  TextFormField buildEmailFormField(Size size) {
    return TextFormField(
      style: TextStyle(
          fontSize: 18,
          color: Colors.black
      ),
      controller: registrationOneController.emailTextEditingController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        hintText: "email",
        hintStyle: TextStyle(
            fontSize: 18, color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(
            vertical: 25.0, horizontal: size.width * 0.04),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

// Toggles to make password visible

  TextFormField buildPasswordFormField(Size size) {
    return TextFormField(
      style: TextStyle(
          fontSize: 18,
          color: Colors.black
      ),
      controller: registrationOneController.passwordTextEditingController,
      obscureText: registrationOneController.obscureText.value,
      decoration: InputDecoration(
        suffix: InkWell(
            onTap: () {
              registrationOneController.togglePassword();
            },
            child: Icon(registrationOneController.obscureText.value
                ? Icons.visibility
                : Icons.visibility_off)),
        hintText: "password",
        hintStyle: TextStyle(
            fontSize: 18, color: Colors.grey),
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
            vertical: 20.0, horizontal: size.width * 0.04),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildConformPassFormField(Size size) {
    return TextFormField(
      style: TextStyle(
          fontSize: 18,
          color: Colors.black
      ),
      controller: registrationOneController.confirmPwdTextEditingController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "re-enter your password",
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
        //prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }
}




