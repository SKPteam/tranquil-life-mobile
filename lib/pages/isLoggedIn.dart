import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/main.dart';
import 'package:tranquil_life/routes/app_pages.dart';
import 'package:tranquil_life/services/http_services.dart';

import '../constants/style.dart';

class IsLoggedIn extends StatefulWidget {
  @override
  _IsLoggedInState createState() => _IsLoggedInState();
}

class _IsLoggedInState extends State<IsLoggedIn> {
  @override
  void initState() {
    isLoggedIn();

    super.initState();
  }

  //Is user loggedIn
  isLoggedIn(){
    String url = baseUrl + isConsultantAuthenticatedPath;

    HttpClass().httpPostRequest(
        {
          "Authorization": "Bearer ${sharedPreferences!.getString(
              'accessToken')}",
        },
        null, Uri.parse(url)).then((value) {
      var body = jsonDecode(value!.body);

      if (body['message'].toString() == isAuthenticated) {
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        Get.offAllNamed(Routes.SPLASH_SCREEN);
      }

      print("isAUTHENTICATED:POST: ${jsonDecode(value.body)}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      responsiveBuilder: (context, size){
        return Scaffold(
          backgroundColor: light,
          body: Container(),
        );
      },
    );
  }
}
