import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/routes/app_pages.dart';

import 'constants/all_controller_binding.dart';
import 'constants/app_font.dart';
import 'constants/style.dart';
import 'pages/dashboard/dashboard.dart';
import 'pages/onboarding/onboarding_one.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

SharedPreferences? sharedPreferences;


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Tranquil Life",
      theme: ThemeData(primarySwatch: active, fontFamily: josefinSansRegular),
      debugShowCheckedModeBanner: false,
      initialBinding: AllControllerBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
