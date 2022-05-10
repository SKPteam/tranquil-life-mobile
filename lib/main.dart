import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/routes/app_pages.dart';
import 'constants/all_controller_binding.dart';
import 'constants/app_font.dart';
import 'constants/style.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // firebaseFirestore = FirebaseFirestore.instance;
  //
  // otherConsltRegDetails =
  //     firebaseFirestore!.collection('otherConsultantRegistrationDetails');

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCfRhbEQGzpaDPkpngdUAaJ3Tx2HjIwipA",
          authDomain: "mindscapeproject-ef43d.firebaseapp.com",
          databaseURL: "https://mindscapeproject-ef43d-default-rtdb.firebaseio.com",
          projectId: "mindscapeproject-ef43d",
          storageBucket: "mindscapeproject-ef43d.appspot.com",
          messagingSenderId: "247965418361",
          appId: "1:247965418361:web:14a9331aaf04c462efa5a8",
          measurementId: "G-MRR85QY5GM"
      ),
    );

    // firebaseFirestore = FirebaseFirestore.instance;
    //
    // otherConsltRegDetails =
    //     firebaseFirestore!.collection('otherConsultantRegistrationDetails');
  } else {
    await Firebase.initializeApp();
  }

  firebaseFirestore = FirebaseFirestore.instance;

  otherConsltRegDetails =
      firebaseFirestore!.collection('otherConsultantRegistrationDetails');

  sharedPreferences = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

SharedPreferences? sharedPreferences;
FirebaseFirestore? firebaseFirestore;
CollectionReference? otherConsltRegDetails;
FirebaseStorage? fbStorage;


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
