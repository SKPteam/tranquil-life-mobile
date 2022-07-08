// ignore_for_file: prefer__ructors, prefer__literals_to_create_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/sign_in_controller.dart';
import 'package:tranquil_life/general_widgets/custom_form_field.dart';
import 'package:tranquil_life/general_widgets/custom_loader.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/routes/app_pages.dart';
import 'package:tranquil_life/general_widgets/custom_snackbar.dart';
import '../../general_widgets/custom_flushbar.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: ResponsiveSafeArea(
        responsiveBuilder: (context, size)=>
            Container(
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
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text("Welcome Back",
                              style: TextStyle(fontSize: 30, color: Colors.white, height: 4,)),
                          SizedBox(height: size.height * 0.01),
                          Text("Sign in with your email and password", textAlign: TextAlign.center, style: TextStyle(color: Color(0xffDDDDDD), fontSize: 18)),
                          SizedBox(height: size.height * 0.08),
                          Form(
                              key: signInController.formKey,
                              child: Column(
                                children: [
                                  CustomFormField(
                                    textInputType: TextInputType.emailAddress,
                                    formatters: [],
                                    hint: 'Email address',
                                    onTap: () {},
                                    showCursor: true,
                                    obscureText: false,
                                    onSuffixTap: () {},
                                    textEditingController: signInController
                                        .emailTextEditingController,
                                    icon: const SizedBox(),
                                  ),

                                  SizedBox(height: size.height * 0.02),

                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4.0),
                                    child: CustomFormField(
                                      textInputType: TextInputType.visiblePassword,
                                      formatters: [],
                                      hint: 'Password',
                                      onTap: () {},
                                      showCursor: true,
                                      obscureText: signInController.obscureText.value,
                                      onSuffixTap: () {
                                        signInController.togglePassword();
                                      },
                                      textEditingController: signInController.passwordTextEditingController,
                                      icon: Icon(signInController.obscureText.value
                                          ? Icons.visibility : Icons.visibility_off),
                                    ),
                                  ),

                                  SizedBox(height: size.height * 0.020),

                                  //FORGOT Password
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          // signInController.emailTextEditingController.text
                                          //     .isEmpty
                                          //     ? signInController.displaySnackBar(
                                          //     kEmailNullError, context)
                                          //     : signInController.firebaseAuth
                                          //     .sendPasswordResetEmail(
                                          //     email: _
                                          //         .emailTextEditingController
                                          //         .text)
                                          //     .then((value) {
                                          //   signInController.displaySnackBar(
                                          //       'Check your inbox!',
                                          //       context);
                                          // }).catchError((error) =>
                                          //     signInController.displaySnackBar(
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
                                          if (signInController.emailTextEditingController.text
                                              .isEmpty) {
                                            CustomSnackBar.showSnackBar(
                                                context: context,
                                                title: "Error",
                                                message: kEmailNullError,
                                                backgroundColor: active);

                                          } else if (signInController
                                              .passwordTextEditingController
                                              .text
                                              .isEmpty) {
                                            CustomSnackBar.showSnackBar(
                                                context: context,
                                                title: "Error",
                                                message: kPassNullError,
                                                backgroundColor: active);

                                          } else if (signInController
                                              .passwordTextEditingController
                                              .text
                                              .length <
                                              6) {
                                            CustomSnackBar.showSnackBar(
                                                context: context,
                                                title: "Error",
                                                message: kShortPassError,
                                                backgroundColor: active);

                                          } else {
                                            signInController.login(
                                                signInController.emailTextEditingController.text,
                                                signInController.passwordTextEditingController.text
                                            ).then((value){
                                              if(value != null){
                                                CustomLoader.cancelDialog();

                                                Get.offAllNamed(Routes.DASHBOARD);
                                              }else{
                                                CustomLoader.cancelDialog();
                                                FlushBarHelper(Get.context!).showFlushBar(value["errors"], color: Colors.red);
                                                print("Unable to login");
                                              }
                                            }).onError((error, stackTrace){
                                              CustomLoader.cancelDialog();
                                              print("Oops an Error occurred, failed to login $error");
                                            }).timeout(Duration(seconds: 90),onTimeout: (){
                                              CustomLoader.cancelDialog();
                                              FlushBarHelper(Get.context!)
                                                  .showFlushBar("TimeOut Error. Please try again", color: Colors.red);
                                            });
                                          }
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
                              )
                          ),
                          SizedBox(height: size.height * 0.10),
                          //Don't have an account, Sign UP
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.ON_BOARDING_TWO);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Don\'t have an account?',
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
      ),
    );
  }
}


