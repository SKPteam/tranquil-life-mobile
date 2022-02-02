
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
import 'package:tranquil_life/widgets/custom_snackbar.dart';
import 'package:tranquil_life/widgets/custom_form_field.dart';



import 'package:tranquil_life/widgets/custom_form_field.dart';
import 'package:tranquil_life/widgets/progress_dialog.dart';

class RegistrationThreeView extends GetView<ClientRegistrationController> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final ClientRegistrationController _ = Get.put(ClientRegistrationController());

  final OnBoardingController obc = Get.put(
      OnBoardingController());

  RegistrationThreeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() =>
          Scaffold(
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
                      image: AssetImage('assets/images/bg_img2.png'),
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
                            SizedBox(height: displayHeight(context) * 0.08), // 4%
                            Text("Register Account",
                                style: TextStyle(
                                  fontSize: displayWidth(context) / 14,
                                  color: Colors.white,
                                  height: displayHeight(context) * 0.0015,
                                )),
                            SizedBox(height: displayHeight(context) * 0.01),
                            Text("Build your biography",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xffDDDDDD),
                                    fontSize: displayWidth(context) / 32)),
                            SizedBox(height: displayHeight(context) * 0.08),
                            Form(
                                child: onBoardingController
                                    .userType
                                    .value == client
                                    ? Text(client)
                                    : Text(consultant)
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ))
      )
    );
  }
}