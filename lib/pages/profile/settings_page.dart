// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/app_settings_controller.dart';
import 'package:tranquil_life/pages/profile/widgets/settings_tile.dart';
import 'package:tranquil_life/routes/app_pages.dart';
import 'package:tranquil_life/widgets/custom_snackbar.dart';

class AppSettingsView extends GetView<AppSettingsController> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: light,
      body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding:  EdgeInsets.symmetric(horizontal: 16.0),
                  width: size.width,
                  height: 80,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Icon(Icons.arrow_back, color: kPrimaryColor),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding:  EdgeInsets.symmetric(vertical: 12),
                  margin:  EdgeInsets.only(left: 16, bottom: 16),
                  decoration:  BoxDecoration(
                    color: Colors.white70,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          SizedBox(width: size.width*0.01,),
                          SettingTile(
                            svgUrl: 'assets/icons/material-share.svg',
                            text: 'Invite Friends via..',
                            onTap: () async{
                              //share app link to other apps on the device, e.g whatsapp...
                              await Share.share('check out my website https://example.com', subject: 'Look what I made!');
                            },
                          ),
                        ]),
                        Row(children: [
                          SizedBox(width: size.width*0.01,),
                           SettingTile(
                              svgUrl: 'assets/icons/material-help.svg',
                              text: 'Help'),
                        ]),
                         SettingTile(svgUrl: 'assets/icons/awesome-readme.svg', text: 'About'),
                        Row(children: [
                          SizedBox(width: size.width*0.01),
                           SettingTile(
                              svgUrl: 'assets/icons/awesome-palette.svg',
                              text: 'Light theme'),
                        ]),
                         SizedBox(
                          height: 30,
                        ),
                        Row(children: [
                          SizedBox(width: size.width*0.02,),
                           SettingTile(
                              svgUrl: 'assets/icons/awesome-file-contract.svg',
                              text: 'Privacy Policy'),
                        ]),
                        Row(children: [
                          SizedBox(width: size.width*0.02),
                           SettingTile(
                              svgUrl: 'assets/icons/icon-document.svg',
                              text: 'Terms and Conditions'),
                        ]),
                         SizedBox(
                          height: 40,
                        ),
                        Row(children: [
                          SizedBox(width: size.width*0.02,),
                          SettingTile(
                            svgUrl: 'assets/icons/icon-metro-exit.svg',
                            text: 'Log out',
                            color: Colors.black,
                            onTap: (){
                              appSettingsController.logOut().then((value) => Navigator.pushNamedAndRemoveUntil(context, Routes.SIGN_IN, (route) => false));
                            },
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}