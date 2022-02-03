// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:tranquil_life/controllers/splash_screen_controller.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';

class SplashScreenView extends GetView<SplashScreenController>{
  final SplashScreenController splashScreenController = Get.put(SplashScreenController());

  SplashScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/splash_screen.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: InkWell(
                child: Column(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Align(
                          child: Image.asset("assets/images/concept1_logo.png",
                              width: displayWidth(context) * 0.5,
                              height: displayHeight(context) * 0.5),
                        )),
                    Expanded(
                        flex: 2,
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: displayWidth(context) * 0.16),
                            child: Column(
                              children: [
                                Spacer(),
                                SizedBox(
                                  height: displayHeight(context) * 0.03,
                                  child: FittedBox(
                                    child: Text(
                                      'To a new beginning with Tranquil',
                                      style: TextStyle(
                                        color: Color(0xFFC3C3C3),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: displayHeight(context) * 0.03,
                                  child: FittedBox(
                                    child: Text(
                                      'A safe place to talk and not feel judged',
                                      style: TextStyle(
                                        color: Color(0xFFC3C3C3),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: displayHeight(context) * 0.03,
                                  child: FittedBox(
                                    child: Text(
                                      'Ready for the journey?',
                                      style: TextStyle(
                                        color: Color(0xFFC3C3C3),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Spacer(flex: 1),
                              ],
                            )))
                  ],
                ),
              )),
          //to make stack clickable
        ));
  }
}

