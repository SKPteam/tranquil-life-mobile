import 'package:get/get.dart';

// ignore_for_file: avoid_print

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
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

class TimeoutController extends GetxController{
  static TimeoutController instance = Get.find();

  TextEditingController pwdTEC = TextEditingController();

  //DashboardController dashboardController = Get.put(DashboardController());

  final bool goBack = false;

  static const String createNewPin = 'Create new pin';
  static const String signOut = 'Sign out';

  List<String> menuOptions = <String>[createNewPin, signOut];

  List<String> currentPin = ["", "", "", ""];
  TextEditingController pinOneController = TextEditingController();
  TextEditingController pinTwoController = TextEditingController();
  TextEditingController pinThreeController = TextEditingController();
  TextEditingController pinFourController = TextEditingController();

  var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Colors.transparent));

  int pinIndex = 0;

  var appBarTitle = 'Enter Your Pin'.obs;
  var nullPinText = "".obs;

  var trial = 0.obs;

  String option = "";
  RxBool obscureText = true.obs;

  optionAction(option) {
    if (option == menuOptions[0]) {
      clearPin();
      Get.bottomSheet(Container(
        //padding: const EdgeInsets.all(8),
        height: displayHeight(Get.context!) * 0.22,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomFormField(
                hint: "Enter your account password",
                textEditingController: pwdTEC,
                showCursor: true,
                formatters: [],
                onTap: () {},
                textInputType: TextInputType.visiblePassword,
                obscureText: true,
                togglePassword: obscureText.value.obs),
            const SizedBox(height: 30),
            SizedBox(
              height: displayHeight(Get.context!) * 0.056,
              width: displayWidth(Get.context!) * 0.8,
              child: ElevatedButton(
                  onPressed: () async
                  {
                    // AuthCredential credential = EmailAuthProvider.credential(
                    //     email: auth!.currentUser!.email.toString(),
                    //     password: pwdTEC.text);
                    //
                    // await auth!.currentUser!
                    //     .reauthenticateWithCredential(credential)
                    //     .then((value) {
                    //   if (!value.isNull) {
                    //     Get.back();
                    //
                    //     appBarTitle.value = "Create New Pin";
                    //     print(appBarTitle.value);
                    //   }
                    // }).catchError((e) async {
                    //   Get.back();
                    //
                    //   displaySnackBar(e.toString(), Get.context!);
                    // });
                  },
                  style: ElevatedButton.styleFrom(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                      primary: kPrimaryColor),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: displayWidth(Get.context!) / 28,
                    ),
                  )),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ));
    } else
      {
      // PushNotificationHelperController.instance
      //     .updateTokenAfterSigningOut(auth!.currentUser!.uid);
      // FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(
          Get.context!, Routes.SPLASH_SCREEN, (route) => false);
      print('Sign out');
    }
  }

  //Get position of pin button clicked
  void pinIndexSetup(String text, BuildContext context) {
    //print(pinIndex);
    //print(text);
    if (pinIndex == 0) {
      pinIndex = 1;
    } else if (pinIndex < 4) {
      pinIndex++;
    }
    setPin(pinIndex, text);
    currentPin[pinIndex - 1] = text;
    String strPin = "";
    for (var e in currentPin) {
      strPin += e;
    }
    if (pinIndex == 4) {
      print(strPin);
      if (appBarTitle.value == 'Create New Pin') {
        // accountSettingsRef!
        //     .child(auth!.currentUser!.uid)
        //     .update({'pin': EncryptionHelper.handleEncryption(strPin)});
        print('Saved to database');
        nullPinText.value = 'Pin created successfully';
        clearPin();
        appBarTitle.value = 'Enter Your Pin';
      } else {
        ifPinExists(strPin, context);
        //print('checking if pin matches or exists in database');
      }
    }
  }

  //Check if Pin exists
  void ifPinExists(String strPin, BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, Routes.DASHBOARD, (route) => false);
    // accountSettingsRef!
    //     .child(auth!.currentUser!.uid)
    //     .child('pin')
    //     .once()
    //     .then((DataSnapshot snapshot) {
    //   if (snapshot.value != null && (EncryptionHelper.handleDecryption(snapshot.value).toString() == strPin)) {
    //     print('Pin exists');
    //
    //     if (goBack) {
    //       Get.back();
    //
    //     } else
    //       {
    //       Navigator.pushNamedAndRemoveUntil(
    //           context, Routes.DASHBOARD, (route) => false);
    //     }
    //   } else {
    //     if (trial.value < 3) {
    //       trial.value++;
    //       nullPinText.value = 'Pin does not exist';
    //       clearPin();
    //     } else {
    //       appBarTitle.value = 'Create New Pin';
    //       nullPinText.value = ' ';
    //       clearPin();
    //     }
    //   }
    // });
  }

  //Set pin in the pin textFields
  void setPin(int n, String text) {
    // setState(() {
    //   nullPinText = "";
    // });
    print("$n = $text");
    switch (n) {
      case 1:
        pinOneController.text = text;
        break;
      case 2:
        pinTwoController.text = text;
        break;
      case 3:
        pinThreeController.text = text;
        break;
      case 4:
        pinFourController.text = text;
        break;
    }
  }

  //Clear pin textFields
  void clearPin() {
    pinIndex = 0;
    currentPin = ["", "", "", ""];
    pinOneController.clear();
    pinTwoController.clear();
    pinThreeController.clear();
    pinFourController.clear();
  }
}