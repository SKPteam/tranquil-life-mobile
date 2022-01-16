// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';

import 'custom_text.dart';


AppBar topNavigationBar(BuildContext context, GlobalKey<ScaffoldState> key) =>
    AppBar(
      elevation: 0,
      actions: [
        Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0, right: 8.0),
            child: Obx(()=>
                GestureDetector(
                  onTap: (){
                    homeController.toggleValue.value = !homeController.toggleValue.value;
                    print(homeController.toggleValue.value);
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 1000),
                    height: 30.0,
                    width: 60.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35.0),
                        color: homeController.toggleValue.value ? active[100] : Colors.red[100]
                    ),
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.easeIn,
                            top: 2.0,
                            left: homeController.toggleValue.value ? 35.0 : 0.0,
                            right: homeController.toggleValue.value ? 0.0 : 35.0,
                            child: AnimatedSwitcher(
                                duration: Duration(milliseconds: 1000),
                                transitionBuilder: (child, animation){
                                  return RotationTransition(
                                      child: child,
                                      turns: animation
                                  );
                                },
                                child: homeController.toggleValue.value
                                    ? Icon(Icons.check_circle_outline, color: active, size: 22,
                                    key: UniqueKey())
                                    : Icon(Icons.remove_circle_outline, color: Colors.red, size: 22,
                                    key: UniqueKey())
                            ))
                      ],
                    ),
                  ),
                )
            )
        ),
        PopupMenuButton<String>(
            onSelected: optionAction,
            iconSize: 28,
            itemBuilder: (BuildContext context) {
              return menuOptions.map((String option) {
                return PopupMenuItem(value: option, child: Text(option));
              }).toList();
            }),
        SizedBox(width: 16)
      ],
      iconTheme: IconThemeData(color: dark),
      backgroundColor: lightBgColor,

    );

ValueNotifier<bool> anonymous = ValueNotifier(false);

late List<String> menuOptions = <String>["signOut", "blog"];
//menuOptions = <String>[signOut, blog];

//menu icon options
optionAction(String option) {
  print(option);
  if (option == 'Blog') {
    //Navigate to Blog page
    //Get.toNamed(Routes.BLOG);
  } else {
    // PushNotificationHelperController.instance
    //     .updateTokenAfterSigningOut(auth!.currentUser!.uid);
    // auth!.signOut();
    // Navigator.pushNamedAndRemoveUntil(
    //     Get.context!, Routes.SIGN_IN, (route) => false);
  }
}
