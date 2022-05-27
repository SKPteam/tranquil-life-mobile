// ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_import, unnecessary_overrides, non_constant_identifier_names

// ignore: avoid_web_libraries_in_flutter

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/dashboard_controller.dart';
import 'package:tranquil_life/controllers/profile_controller.dart';

class EditProfileController extends GetxController {
  static EditProfileController instance = Get.find();

  ProfileController profileController = Get.put(ProfileController());


  bool profileDataLoaded = true;
  bool imagePickSel = true;
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



  Widget profilePic(BuildContext context) {
    return Container(
      child:
      // !imagePickSel.value
      //     ? CircleAvatar(
      //   radius: 20,
      //   backgroundImage:
      //   NetworkImage(getStorage!.read(userAvatarUrl).toString()),
      // )
          //:
      CircleAvatar(
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