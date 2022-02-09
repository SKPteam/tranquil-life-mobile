// ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_import, unnecessary_overrides, non_constant_identifier_names

// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/dashboard_controller.dart';
import 'package:tranquil_life/controllers/profile_controller.dart';

class EditProfileController extends GetxController {
  ProfileController profileController = Get.put(ProfileController());

  GetStorage? getStorage;
  RxBool uploadingPhoto = false.obs;
  RxString firstName = "".obs;
  RxString lastName = "".obs;
  RxString dob = "".obs;
  RxString pin = "".obs;
  RxString gender = "".obs;
  RxString phoneNum = "".obs;
  RxString timeZone = "".obs;
  RxString bankName = "".obs;
  RxString bankAddress = "".obs;
  RxString homeAddress = "".obs;
  RxString swiftCode = "".obs;
  RxString workPlace = "".obs;
  RxString workStatus = "".obs;
  RxString areasOfExpertise = "".obs;
  RxString yearsOfExperience = "".obs;
  RxString preferredLangs = "".obs;
  RxString fee = "".obs;
  RxString IBAN = "".obs;
  RxBool profileDataLoaded = true.obs;
  RxBool imagePickSel = true.obs;
  List<TextEditingController> controllers = [
    TextEditingController(), TextEditingController(),
    TextEditingController(), TextEditingController(),
    TextEditingController(), TextEditingController(),
    TextEditingController(), TextEditingController(),
    TextEditingController(), TextEditingController(),
  ];

  RxString photoUrl = "".obs;
  RxString imgUrl = "".obs;

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
  }

  @override
  void onInit() {

    super.onInit();
  }

  // checkAuthState() async {
  //   getStorage = GetStorage();
  //
  //   DateTime dateTime = DateTime.now();
  //   timeZone = RxString(
  //       '${dateTime.timeZoneOffset.isNegative ? '' : '+'}${_printDuration(dateTime.timeZoneOffset)}');
  //
  //   print('checking out status');
  //
  //   if (auth!.currentUser != null) {
  //     firstName.value = DashboardController.to.firstName!.value;
  //     lastName.value = DashboardController.to.lastName!.value;
  //     dob.value = DashboardController.to.dob!.value;
  //     phoneNum.value = DashboardController.to.phoneNum!.value;
  //     gender.value = DashboardController.to.gender!.value;
  //     pin.value = DashboardController.to.pin!.value;
  //
  //     if (DashboardController.to.userType!.value == consultant) {
  //       await accountSettingsRef!
  //           .child(auth!.currentUser!.uid)
  //           .child('profile')
  //           .once()
  //           .then((snapshot1) {
  //         bankName = RxString(snapshot1.value[userBankName].toString());
  //         IBAN = RxString(snapshot1.value["IBAN"].toString());
  //         bankAddress = RxString(snapshot1.value["bankAddress"].toString());
  //         homeAddress = RxString(snapshot1.value["homeAddress"].toString());
  //         swiftCode = RxString(snapshot1.value["swiftCode"].toString());
  //         workPlace = RxString(snapshot1.value["workPlace"].toString());
  //         workStatus = RxString(snapshot1.value["workStatus"].toString());
  //         areasOfExpertise = RxString(snapshot1.value["workStatus"].toString());
  //         yearsOfExperience = RxString(snapshot1.value["yearsOfExperience"].toString());
  //         preferredLangs = RxString(snapshot1.value["preferredLangs"].toString());
  //         fee = RxString(snapshot1.value["fee"].toString());
  //       });
  //     }
  //   } else {
  //     PushNotificationHelperController.instance
  //         .updateTokenAfterSigningOut(auth!.currentUser!.uid);
  //     auth!.signOut();
  //     Navigator.pushNamedAndRemoveUntil(
  //         Get.context!, Routes.SPLASH_SCREEN, (route) => false);
  //   }
  //   print('$firstName $lastName $dob');
  //
  //   ///List of controllers used for the textfields in the edit section
  //   controllers = [
  //     TextEditingController(
  //         text: firstName.value.isNotEmpty ? firstName.value.toString() : ''),
  //     TextEditingController(
  //         text: lastName.value.isNotEmpty ? lastName.value.toString() : ''),
  //     TextEditingController(
  //         text: dob.value.isNotEmpty ? dob.value.toString() : ''),
  //     TextEditingController(
  //         text: gender.value.isNotEmpty ? gender.value.toString() : ''),
  //     TextEditingController(
  //         text: Get.find<HomeController>()
  //             .location!.value.substring(
  //             0,
  //             Get.find<HomeController>().location!.value.indexOf("/")).isNotEmpty
  //             ?
  //         Get.find<HomeController>()
  //             .location!.value.substring(
  //             0, Get.find<HomeController>().location!.value.indexOf("/"))
  //             :
  //         ''),
  //     TextEditingController(
  //         text: phoneNum.value.isNotEmpty ? phoneNum.value.toString() : ''),
  //     TextEditingController(
  //         text: timeZone.value.isNotEmpty ? 'GMT ${timeZone.value}' : ''),
  //     TextEditingController(text: pin.value.isNotEmpty ? pin.value : ''),
  //   ];
  //   if (DashboardController.to.userType!.value == consultant) {
  //     controllers.addAll([
  //       TextEditingController(
  //           text: bankName.value.isNotEmpty ? bankName.value.toString() : ''),
  //       TextEditingController(
  //           text: IBAN.value.isNotEmpty ? IBAN.value : ''),
  //       TextEditingController(
  //           text: IBAN.value.isNotEmpty ? IBAN.value : ''),
  //     ]);
  //   }
  //
  //   profileDataLoaded.value = true;
  // }

  Widget profilePic(BuildContext context) {
    return Container(
      child: !imagePickSel.value
          ? CircleAvatar(
        radius: 20,
        backgroundImage:
        NetworkImage(getStorage!.read(userAvatarUrl).toString()),
      )
          : CircleAvatar(
        backgroundImage: photoUrl.value.isEmpty
            ?  AssetImage('assets/images/avatar_img1.png')
            : AssetImage(""),
        //FileImage(File(photoUrl.value)) as ImageProvider,
        radius: 20,
      ),
    );
  }

  ///Widget for creating the edit photo component
  Widget editPhoto(BuildContext context) {
    return Container(
      height: 60,
      margin:  EdgeInsets.only(
        left: 8,
        right: 24,
      ),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(6),
      ),
      padding:  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Expanded(
              flex: 9,
              child: Text(
                'Edit Photo',
                style: TextStyle(
                    fontSize: 18,
                    color: kPrimaryDarkColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              flex: 8,
              child: Center(
                child: CircleAvatar(
                    backgroundColor: Colors.yellowAccent,
                    radius: 22,
                    child: profilePic(context)),
              ),
            ),
          ],
        ),
        onTap: () async
        {
        //   var status = await Permission.storage.isGranted;
        //   if (!status) {
        //     await Permission.storage.request();
        //     status = await Permission.storage.isGranted;
        //   }
        //   print(status);
        //   if (status) {
        //     var result = await Navigator.of(context).push(MaterialPageRoute(
        //         builder: (context) => Platform.isIOS
        //             ?  ImagePickerPageIOS()
        //             :  ImagePickerAndroid()));
        //
        //     if (result != null) {
        //       print('setting state edit photo onTapped');
        //       imagePickSel.value = true;
        //       photoUrl.value =
        //       Platform.isAndroid ? result as String : (result as File).path;
        //     }
        //   }
        //
          },
      ),
    );
  }

  ///Creates individual fields with certain properties
  ///[controller] is required and is used to set and retrieve the text
  ///[title] property specifies what should be the display text,
  ///[readOnly] is the property that makes the textfield either readonly or typable
  Widget editField(BuildContext context,
      {required TextEditingController controller,
        required String title,
        required Function() onTapped,
        List<TextInputFormatter> inputFormattors = const [],
        bool readOnly = false}) {
    print(controller.text);
    return Container(
      height: 60,
      margin:  EdgeInsets.only(
        left: 8,
        right: 24,
      ),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(6),
      ),
      padding:  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: onTapped,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 9,
              child: Text(
                title,
                style:  TextStyle(
                    fontSize: 18,
                    color: kPrimaryDarkColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              flex: 8,
              child: Center(
                  child: TextField(
                    textAlignVertical: TextAlignVertical.top,
                    controller: controller,
                    decoration:  InputDecoration(
                      disabledBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    readOnly: readOnly,
                    inputFormatters: inputFormattors,
                    textAlign: TextAlign.center,
                    style:  TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onClose() {}


}