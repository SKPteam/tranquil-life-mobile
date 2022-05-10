// ignore_for_file: prefer__ructors, prefer__literals_to_create_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/dashboard_controller.dart';
import 'package:tranquil_life/controllers/sign_in_controller.dart';
import 'package:tranquil_life/main.dart';
import 'package:tranquil_life/pages/dashboard/dashboard.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/routes/app_pages.dart';
import 'package:tranquil_life/widgets/custom_snackbar.dart';
import '../../helpers/flush_bar_helper.dart';
import '../../helpers/progress-dialog_helper.dart';
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
                                              ProgressDialogHelper().hideProgressDialog(Get.context!);
                                              Get.offAllNamed(Routes.DASHBOARD);
                                            }else{
                                              ProgressDialogHelper().hideProgressDialog(Get.context!);
                                              FlushBarHelper(Get.context!).showFlushBar(value["errors"], color: Colors.red);
                                              print("Unable to login");
                                            }
                                          }).onError((error, stackTrace){
                                            ProgressDialogHelper().hideProgressDialog(Get.context!);
                                            print("Oops an Error occurred, failed to login $error");
                                          }).timeout(Duration(seconds: 90),onTimeout: (){
                                            ProgressDialogHelper().hideProgressDialog(Get.context!);
                                            FlushBarHelper(Get.context!).showFlushBar("TimeOut Error. Please try again", color: Colors.red);
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
