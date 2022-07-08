// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/registration_four_controller.dart';
import 'package:tranquil_life/controllers/registration_one_controller.dart';
import 'package:tranquil_life/controllers/registration_two_controller.dart';
import 'package:tranquil_life/general_widgets/custom_form_field.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/routes/app_pages.dart';
import 'package:tranquil_life/general_widgets/custom_text.dart';
import 'package:tranquil_life/services/media_service.dart';

import '../../general_widgets/custom_snackbar.dart';
import 'widgets/user_type_widgets.dart';



class RegistrationTwoView extends StatefulWidget {
  const RegistrationTwoView({Key? key}) : super(key: key);

  @override
  State<RegistrationTwoView> createState() => _RegistrationTwoViewState();
}

class _RegistrationTwoViewState extends State<RegistrationTwoView> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
        responsiveBuilder: (context, size) =>
            Obx(() =>
                Scaffold(
                  key: registrationTwoController.scaffoldKey,
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
                                SizedBox(height: size.height * 0.08), // 4%
                                Text("Complete Profile",
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
                                  key: registrationTwoController.formKey,
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              4),
                                          child:  CustomFormField(
                                            textInputType: TextInputType.text,
                                            formatters: [],
                                            hint: 'First name',
                                            onTap: () {},
                                            showCursor: true,
                                            obscureText: false,
                                            onSuffixTap: () {},
                                            textEditingController: registrationTwoController
                                                .firstNameTextEditingController,
                                            icon: const SizedBox(),
                                          ),
                                        ),
                                        SizedBox(height: size.height * 0.020),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              4),
                                          child:  CustomFormField(
                                            textInputType: TextInputType.text,
                                            formatters: [],
                                            hint: 'Last name',
                                            onTap: () {},
                                            showCursor: true,
                                            obscureText: false,
                                            onSuffixTap: () {},
                                            textEditingController: registrationTwoController
                                                .lastNameTextEditingController,
                                            icon: const SizedBox(),
                                          ),
                                        ),
                                        SizedBox(height: size.height * 0.020),


                                        userTypeWidgets()
                                      ],
                                    ))
                              ],
                            ),
                            //end
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
    );
  }

}
