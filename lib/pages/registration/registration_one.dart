// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tranquil_life/controllers/client_registration_controller.dart';

// import 'package:tranquil_app/app/getx_controllers/on_boarding_two_controller.dart';
// import 'package:tranquil_app/app/getx_controllers/registration_one_controller.dart';
// import 'package:tranquil_app/app/routes/app_pages.dart';
// import 'package:tranquil_app/app/utils/constants.dart';
// import 'package:tranquil_app/app/utils/sizes_helpers.dart';

class RegistrationOneView extends GetView<ClientRegistrationController> {

  final ClientRegistrationController _ = Get.put(
      ClientRegistrationController());

  RegistrationOneView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
        ));
  }
}