import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/registration_four_controller.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';
import 'package:tranquil_life/general_widgets/custom_form_field.dart';

import '../../helpers/responsive_safe_area.dart';

class RegistrationFourView extends GetView<RegistrationFourController> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      responsiveBuilder: (context, size){
        return Obx(()=> Scaffold(
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
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.1),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image:
                      onBoardingController.userType.value == client
                          ? AssetImage('assets/images/bg_img1.png')
                          : AssetImage('assets/images/bg_img2.png'),
                      colorFilter: ColorFilter.mode(
                          Color(0xff777474), BlendMode.multiply),
                      fit: BoxFit.cover)),
              child: ListView(
                children: [
                  SizedBox(height: size.height * 0.08), // 4%
                  Text("Register Account",
                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        height: size.height * 0.0015,
                      )),
                  SizedBox(height: size.height * 0.02),
                  Text("Complete your registration",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: const Color(0xffDDDDDD),
                          fontSize: 18)),
                  SizedBox(height: size.height * 0.08),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: CustomFormField(
                      textInputType: TextInputType.streetAddress,
                      formatters: [],
                      hint: 'Home address',
                      onTap: () {},
                      showCursor: true,
                      obscureText: false,
                      onSuffixTap: () {},
                      textEditingController: registrationFourController.homeAddressTEC,
                      icon: const SizedBox(),
                    ),
                  ),
                  SizedBox(height: displayHeight(context) * 0.020),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: CustomFormField(
                      textInputType: TextInputType.number,
                      formatters: [],
                      hint: 'Account number',
                      onTap: () {},
                      showCursor: true,
                      obscureText: false,
                      onSuffixTap: () {},
                      textEditingController: registrationFourController.accountNumberTEC,
                      icon: const SizedBox(),
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
                      onSuffixTap: () {},
                      textEditingController: registrationFourController.bankNameTEC,
                      icon: const SizedBox()
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
                      onSuffixTap: () {},
                      textEditingController: registrationFourController.bankAddressTEC,
                      icon: const SizedBox(),
                    ),
                  ),
                  SizedBox(height: displayHeight(context) * 0.020),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: CustomFormField(
                      textInputType: TextInputType.text,
                      formatters: [],
                      hint:
                      'IBAN (International bank account number)',
                      onTap: () {},
                      showCursor: true,
                      obscureText: false,
                      onSuffixTap: () {},
                      textEditingController:
                      registrationFourController.ibanTextEditingController,
                      icon: const SizedBox(),

                    ),
                  ),
                  SizedBox(height: displayHeight(context) * 0.020),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: CustomFormField(
                      textInputType: TextInputType.text,
                      formatters: [],
                      hint: 'SWIFT/BIC',
                      onTap: () {},
                      showCursor: true,
                      obscureText: false,
                      onSuffixTap: () {},
                      textEditingController: registrationFourController.swiftCodeTEC,
                      icon: const SizedBox(),
                    ),
                  ),

                  SizedBox(height: displayHeight(context) * 0.046),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            registrationFourController.saveConsultantProfile();

                            // if (registrationFourController.homeAddressTEC.text.isEmpty ||
                            //     registrationFourController.bankAddressTEC.text.isEmpty ||
                            //     registrationFourController.bankAddressTEC.text.isEmpty ||
                            //     registrationFourController.ibanTextEditingController.text
                            //         .isEmpty ||
                            //     registrationFourController.swiftCodeTEC.text.isEmpty) {
                            //   CustomSnackBar.showSnackBar(
                            //       context: context,
                            //       title: "Error",
                            //       message: "A field is empty",
                            //       backgroundColor: active);
                            // } else {
                            //   print(Get.find<
                            //       RegistrationOneController>()
                            //       .emailTextEditingController
                            //       .text);
                            //   registrationFourController.saveConsultantProfile();
                            //   print("registering consultant");
                            // }
                          },
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 20),
                              primary: kPrimaryColor),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ))),
                  SizedBox(height: displayHeight(context) * 0.020),                ],
              ),
            )));
      },
    );
  }

  TextFormField buildFirstNameFormField(Size size) {
    return TextFormField(
      //validator: (value) => (value!.isEmpty? "Please enter your first name" : null),
      // onChanged: (value){
      //   regOneController.firstname = value;
      // },
      controller: registrationTwoController.firstNameTextEditingController,
      style: TextStyle(
          fontSize: 18, color: Colors.black),
      decoration: InputDecoration(
        hintText: "first name",
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
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
