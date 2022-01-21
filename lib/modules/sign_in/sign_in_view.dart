// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tranquil_app/app/routes/app_pages.dart';
import 'package:tranquil_app/app/utils/constants.dart';
import 'package:tranquil_app/app/utils/sizes_helpers.dart';

import '../../getx_controllers/sign_in_controller.dart';

class SignInView extends GetView<SignInController> {
  SignInView({Key? key}) : super(key: key);

  final SignInController _ = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(()
      => Scaffold(
            //resizeToAvoidBottomPadding: false,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text(
                "Sign In",
                style: TextStyle(color: Color(0xffBEBEBE)),
              ),
            ),
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/bg_img1.png'),
                    colorFilter:
                    ColorFilter.mode(Color(0xff777474), BlendMode.multiply),
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
                          Text("Welcome Back",
                              style: TextStyle(
                                fontSize: displayWidth(context) / 14,
                                color: Colors.white,
                                height: displayHeight(context) * 0.0015,
                              )),
                          SizedBox(height: displayHeight(context) * 0.01),
                          Text("Sign in with your email/username \nand password",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: const Color(0xffDDDDDD),
                                  fontSize: displayWidth(context) / 32)),
                          SizedBox(height: displayHeight(context) * 0.08),
                          Form(
                              key: _.formKey,
                              child: Column(
                                children: [
                                  buildEmailFormField(),
                                  SizedBox(
                                      height: displayHeight(context) * 0.020),
                                  buildPasswordFormField(),
                                  SizedBox(
                                      height: displayHeight(context) * 0.020),

                                  //FORGOT Password
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          _.emailTextEditingController.text
                                              .isEmpty
                                              ? _.displaySnackBar(
                                              kEmailNullError, context)
                                              : _.firebaseAuth
                                              .sendPasswordResetEmail(
                                              email: _
                                                  .emailTextEditingController
                                                  .text)
                                              .then((value) {
                                            _.displaySnackBar(
                                                'Check your inbox!',
                                                context);
                                          }).catchError((error) =>
                                              _.displaySnackBar(
                                                  '${error.toString().substring(30, error.toString().length)}',
                                                  context));
                                        },
                                        child: Text(
                                          'Forgot Password?',
                                          style: TextStyle(
                                              decoration:
                                              TextDecoration.underline,
                                              color: kSecondaryColor,
                                              fontSize:
                                              displayWidth(context) / 30),
                                        ),
                                      )),
                                  SizedBox(
                                      height: displayHeight(context) * 0.045),

                                  //Sign in button
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          if (_.emailTextEditingController.text
                                              .isEmpty) {
                                            _.displaySnackBar(
                                                kEmailNullError, context);
                                          } else if (_
                                              .passwordTextEditingController
                                              .text
                                              .isEmpty) {
                                            _.displaySnackBar(
                                                kPassNullError, context);
                                          } else if (_
                                              .passwordTextEditingController
                                              .text
                                              .length <
                                              6) {
                                            _.displaySnackBar(
                                                kShortPassError, context);
                                          } else {
                                            _.loginAndAuthenticate(context);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0, vertical: 20),
                                            primary: kPrimaryColor),
                                        child: Text(
                                          'Sign In',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                            displayWidth(context) / 28,
                                          ),
                                        )),
                                  ),
                                  SizedBox(
                                      height: displayHeight(context) * 0.040),
                                ],
                              )),
                          SizedBox(height: displayHeight(context) * 0.10),

                          //Don't have an account, Sign UP
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, Routes.ON_BOARDING_TWO);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Don' + "'t " + 'have an account? ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: displayWidth(context) / 30),
                                ),
                                Text(
                                  'Sign Up',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: kSecondaryColor,
                                      fontSize: displayWidth(context) / 30),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: displayHeight(context) * 0.040),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }


  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: _.emailTextEditingController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
          fontSize: displayWidth(Get.context!) / 30,
          color: Colors.black
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        hintText: "email address",
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

  // // Toggles to make password visible
  // void _togglePassword() {
  //   print('toggle obscure text');
  //   setState(() {
  //     _obscureText = !_obscureText;
  //   });
  // }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: _.obscureText.value,
      controller: _.passwordTextEditingController,
      style: TextStyle(
          fontSize: displayWidth(Get.context!) / 30,
          color: Colors.black
      ),
      decoration: InputDecoration(
        suffix: InkWell(
            onTap: () {
              _.togglePassword();
            },
            child: Icon(_.obscureText.value ? Icons.visibility : Icons.visibility_off)
        ),
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
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }
}
