// ignore_for_file: implementation_imports, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:tranquil_app/app/getx_controllers/on_boarding_two_controller.dart';
import 'package:tranquil_app/app/getx_controllers/registration_four_controller.dart';
import 'package:tranquil_app/app/getx_controllers/registration_one_controller.dart';
import 'package:tranquil_app/app/routes/app_pages.dart';
import 'package:tranquil_app/app/utils/constants.dart';
import 'package:tranquil_app/app/utils/custom_form_field.dart';
import 'package:tranquil_app/app/utils/sizes_helpers.dart';
import 'package:tranquil_app/app/utils/snackbar.dart';

class RegistrationFourView extends GetView<RegistrationFourController> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  RegistrationFourView({Key? key}) : super(key: key);

  final RegistrationFourController _ = Get.put(RegistrationFourController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(()=>
          Scaffold(
            key: scaffoldKey,
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
                    image: Get.find<OnBoardingTwoController>().userType.value ==
                        client
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
                                  color: const Color(0xffDDDDDD),
                                  fontSize: displayWidth(context) / 32)),
                          SizedBox(height: displayHeight(context) * 0.08),
                          Form(
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(4.0),
                                  child: CustomFormField(
                                    textInputType: TextInputType.streetAddress,
                                    formatters: const [],
                                    hint: 'Home address',
                                    onTap: () {  },
                                    showCursor: true, obscureText: false,
                                    togglePassword: () {  },
                                    textEditingController: _.homeAddressTEC,
                                  ),
                                ),
                                SizedBox(
                                    height:
                                    displayHeight(context) * 0.020),
                                ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(4.0),
                                  child: CustomFormField(
                                    textInputType: TextInputType.text,
                                    formatters: const [],
                                    hint: 'Bank name',
                                    onTap: () {  },
                                    showCursor: true, obscureText: false,
                                    togglePassword: () {  },
                                    textEditingController: _.bankNameTEC,
                                  ),
                                ),
                                SizedBox(
                                    height:
                                    displayHeight(context) * 0.020),
                                ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(4.0),
                                  child: CustomFormField(
                                    textInputType: TextInputType.streetAddress,
                                    formatters: const [],
                                    hint: 'Bank address',
                                    onTap: () {  },
                                    showCursor: true, obscureText: false,
                                    togglePassword: () {  },
                                    textEditingController: _.bankAddressTEC,
                                  ),
                                ),
                                SizedBox(
                                    height:
                                    displayHeight(context) * 0.020),
                                ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(4.0),
                                  child: CustomFormField(
                                    textInputType: TextInputType.text,
                                    formatters: const [],
                                    hint: 'International bank account number (IBAN)',
                                    onTap: () {  },
                                    showCursor: true, obscureText: false,
                                    togglePassword: () {  },
                                    textEditingController: _.ibanTextEditingController,
                                  ),
                                ),
                                SizedBox(
                                    height:
                                    displayHeight(context) * 0.020),
                                ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(4.0),
                                  child: CustomFormField(
                                    textInputType: TextInputType.text,
                                    formatters: const [],
                                    hint: 'Swift code',
                                    onTap: () {  },
                                    showCursor: true, obscureText: false,
                                    togglePassword: () {  },
                                    textEditingController: _.swiftCodeTEC,
                                  ),
                                ),
                                SizedBox(
                                    height:
                                    displayHeight(context) * 0.020),
                                SizedBox(
                                    height:
                                    displayHeight(context) * 0.026),
                                SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          if(_.homeAddressTEC.text.isEmpty
                                              || _.bankAddressTEC.text.isEmpty
                                              || _.bankAddressTEC.text.isEmpty
                                              || _.ibanTextEditingController.text.isEmpty
                                              ||_.swiftCodeTEC.text.isEmpty){
                                            displaySnackBar("A field is empty", context);
                                          }
                                          else{
                                            print(Get.find<RegistrationOneController>().emailTextEditingController.text);
                                            _.registerNewConsultant();
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 0,
                                                vertical: 20),
                                            primary: kPrimaryColor),
                                        child: Text(
                                          'Sign Up',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                            displayWidth(context) /
                                                28,
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
          )
      ),
    );
  }
}