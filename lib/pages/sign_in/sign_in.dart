// ignore_for_file: prefer__ructors, prefer__literals_to_create_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/sign_in_controller.dart';
import 'package:tranquil_life/dashboard.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/routes/app_pages.dart';

import 'widgets/sign_in_form_fields.dart';


class SignIn extends StatelessWidget {
  final SignInController _ = Get.put(SignInController());
  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      responsiveBuilder: (context, size){
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title:  Text(
              "Sign In",
              style: TextStyle(color: grey),
            ),
          ),
          body: Container(
            decoration:  BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/bg_img1.png'),
                  colorFilter:
                  ColorFilter.mode(bgFilter, BlendMode.multiply),
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
                        Text("Welcome Back",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              height: 4,
                            )),

                        SizedBox(height: size.height * 0.01),

                        Text("Sign in with your email and password",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xffDDDDDD),
                                fontSize: 18)),
                        SizedBox(height: size.height * 0.08),

                        Form(
                            key: _.formKey,
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4.0),
                                  child: buildEmailFormField(),
                                ),

                                SizedBox(height: size.height * 0.020),

                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4.0),
                                  child: buildPasswordFormField(),
                                ),

                                SizedBox(height: size.height * 0.020),

                                //FORGOT Password
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        // _.emailTextEditingController.text
                                        //     .isEmpty
                                        //     ? _.displaySnackBar(
                                        //     kEmailNullError, context)
                                        //     : _.firebaseAuth
                                        //     .sendPasswordResetEmail(
                                        //     email: _
                                        //         .emailTextEditingController
                                        //         .text)
                                        //     .then((value) {
                                        //   _.displaySnackBar(
                                        //       'Check your inbox!',
                                        //       context);
                                        // }).catchError((error) =>
                                        //     _.displaySnackBar(
                                        //         '${error.toString().substring(30, error.toString().length)}',
                                        //         context));
                                      },
                                      child: Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                            decoration:
                                            TextDecoration.underline,
                                            color: yellow,
                                            fontSize: 18),
                                      ),
                                    )),

                                SizedBox(height: size.height * 0.045),

                                //Sign in button
                                SizedBox(
                                  width: size.width * 0.6,
                                  height: 60,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        // if (_.emailTextEditingController.text
                                        //     .isEmpty) {
                                        //   _.displaySnackBar(
                                        //       kEmailNullError, context);
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
                                        // } else {
                                        //   _.loginAndAuthenticate(context);
                                        // }
                                        //INFO TODO: Return it back to allOffNamed
                                        Get.toNamed(Routes.TIMEOUT_SCREEN);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          padding:  EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 20),
                                          primary: active),
                                      child: Text(
                                        'Sign In',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      )),
                                ),

                                SizedBox(height: size.height * 0.040),
                              ],
                            )),

                        SizedBox(height: size.height * 0.10),

                        //Don't have an account, Sign UP
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, Routes.ON_BOARDING_TWO, (route) => false);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don' + "'t " + 'have an account? ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18),
                              ),
                              Text(
                                ' Sign Up',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: yellow,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.040),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }


}
