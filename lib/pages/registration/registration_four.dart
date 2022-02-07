// ignore_for_file: implementation_imports, must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

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

import 'package:tranquil_life/widgets/custom_form_field.dart';
import 'package:tranquil_life/widgets/progress_dialog.dart';

class RegistrationFourView extends GetView<ClientRegistrationController> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  RegistrationFourView({Key? key}) : super(key: key);

  final ClientRegistrationController _ =
      Get.put(ClientRegistrationController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
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
                image: Get.find<OnBoardingController>().userType.value == client
                    ? AssetImage('assets/images/bg_img1.png')
                    : AssetImage('assets/images/bg_img2.png'),
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
                      Text("Register Account",
                          style: TextStyle(
                            fontSize: displayWidth(context) / 14,
                            color: Colors.white,
                            height: displayHeight(context) * 0.0015,
                          )),
                      SizedBox(height: displayHeight(context) * 0.01),
                      Text("Provide your account details for payment",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xffDDDDDD),
                              fontSize: displayWidth(context) / 32)),
                      SizedBox(height: displayHeight(context) * 0.08),
                      Form(
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: CustomFormField(
                                textInputType: TextInputType.streetAddress,
                                formatters: [],
                                hint: 'Home address',
                                onTap: () {},
                                showCursor: true,
                                obscureText: false,
                                togglePassword: () {},
                                textEditingController: _.homeAddressTEC,
                              ),
                            ),
                            SizedBox(height: displayHeight(context) * 0.020),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: CustomFormField(
                                textInputType: TextInputType.text,
                                formatters: [],
                                hint: 'Bank name',
                                onTap: () {},
                                showCursor: true,
                                obscureText: false,
                                togglePassword: () {},
                                textEditingController: _.bankNameTEC,
                              ),
                            ),
                            SizedBox(height: displayHeight(context) * 0.020),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: CustomFormField(
                                textInputType: TextInputType.streetAddress,
                                formatters: [],
                                hint: 'Bank address',
                                onTap: () {},
                                showCursor: true,
                                obscureText: false,
                                togglePassword: () {},
                                textEditingController: _.bankAddressTEC,
                              ),
                            ),
                            SizedBox(height: displayHeight(context) * 0.020),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: CustomFormField(
                                textInputType: TextInputType.text,
                                formatters: [],
                                hint:
                                    'International bank account number (IBAN)',
                                onTap: () {},
                                showCursor: true,
                                obscureText: false,
                                togglePassword: () {},
                                textEditingController:
                                    _.ibanTextEditingController,
                              ),
                            ),
                            SizedBox(height: displayHeight(context) * 0.020),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: CustomFormField(
                                textInputType: TextInputType.text,
                                formatters: [],
                                hint: 'Swift code',
                                onTap: () {},
                                showCursor: true,
                                obscureText: false,
                                togglePassword: () {},
                                textEditingController: _.swiftCodeTEC,
                              ),
                            ),
                            SizedBox(height: displayHeight(context) * 0.020),
                            SizedBox(height: displayHeight(context) * 0.026),
                            SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (_.homeAddressTEC.text.isEmpty ||
                                          _.bankAddressTEC.text.isEmpty ||
                                          _.bankAddressTEC.text.isEmpty ||
                                          _.ibanTextEditingController.text
                                              .isEmpty ||
                                          _.swiftCodeTEC.text.isEmpty) {
                                        displaySnackBar(
                                            "A field is empty", context);
                                      } else {
                                        print(Get.find<
                                                ClientRegistrationController>()
                                            .emailTextEditingController
                                            .text);
                                        // _.registerNewConsultant();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 20),
                                        primary: kPrimaryColor),
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: displayWidth(context) / 28,
                                      ),
                                    )))
                          ],
                        ),
                      )
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
