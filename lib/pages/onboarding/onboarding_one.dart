// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/onboarding_controller.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/pages/onboarding/onboarding_two.dart';
import 'package:tranquil_life/pages/sign_in/sign_in.dart';
import 'package:tranquil_life/routes/app_pages.dart';

import 'widgets/onBoardingContent.dart';

class OnBoardingOne extends GetView<OnBoardingController> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
        responsiveBuilder: (context, size){
          return Scaffold(
            body: Obx(()=>
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: PageView.builder(
                          onPageChanged: (value) {
                            onBoardingController.currentPage.value = value;
                          },
                          itemCount: onBoardingController.onBoardingData.length,
                          itemBuilder: (context, index) => OnBoardingContent(
                            image: onBoardingController.onBoardingData[index]["image"],
                            text: onBoardingController.onBoardingData[index]['text'],
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 32),
                            child: Column(
                              children: <Widget>[
                                Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    onBoardingController.onBoardingData.length,
                                        (index) => buildDot(index: index),
                                  ),
                                ),
                                Spacer(flex: 2),
                                SizedBox(
                                  width: size.width * 0.6,
                                  height: 60,
                                  child: ElevatedButton(onPressed: () {

                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        Routes.SIGN_IN,
                                            (route) => false);
                                  },
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 20),
                                          primary: active),
                                      child: Text('Next', style: TextStyle(fontSize: 22))
                                  ),
                                ),

                                Spacer(),
                              ],
                            ),
                          )
                      )
                    ],
                  ),
                )),
          );
        }
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: onBoardingController.currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: onBoardingController.currentPage == index ? active : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
