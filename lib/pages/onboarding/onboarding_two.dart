// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/onboarding_controller.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/routes/app_pages.dart';

class OnBoardingTwo extends StatelessWidget {
  final OnBoardingController _ = Get.put(OnBoardingController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      responsiveBuilder: (context, size){
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/bg_img1.png'),
                    colorFilter: ColorFilter.mode(bgFilter, BlendMode.multiply),
                    fit: BoxFit.cover
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      flex:3,
                      child: Align(
                        child: Image.asset("assets/images/tranquil_logo.png",
                            width: 240,
                            height: 240),
                      )
                  ),
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8),
                        child: Column(
                          children: [
                            SizedBox(
                              width: size.width * 0.6,
                              height: 60,
                              child: ElevatedButton(onPressed: (){
                                onBoardingController.userType.value = client;
                                print("The value of my serach is ${onBoardingController.userType.value}");
                                Get.offNamed(Routes.REGISTRATION_ONE);
                              }, style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                                  primary: active
                              ),
                                  child: Text('Client',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18
                                      )
                                  )
                              ),

                            ),

                            SizedBox(
                                height: size.height * 0.020),

                            SizedBox(
                              width: size.width * 0.6,
                              height: 60,
                              child: ElevatedButton(onPressed: (){
                                //_showModalBottomSheet(context);
                                onBoardingController.userType.value = consultant;
                                Get.offNamed(Routes.REGISTRATION_ONE);
                              },
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                                      primary: Colors.white
                                  ),
                                  child: Text('Consultant',style: TextStyle(
                                      color: active,
                                      fontSize: 18
                                  ),)),

                            ),

                            Spacer(),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    child: InkWell(
                                      onTap:(){
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            Routes.SIGN_IN,
                                                (route) => false);
                                      },
                                      child: Row(
                                        children: [
                                          Text('Already have an account? ', textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18
                                            ),),
                                          Text('Login', textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: yellow,
                                                fontSize: 18
                                            ),),
                                        ],
                                      ),
                                    )
                                )
                              ],
                            ),

                            Spacer(),
                          ],
                        ),
                      )
                  )
                ],
              )
          ),
        );
      },
    );
  }
}
