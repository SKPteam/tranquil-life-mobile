// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tranquil_app/app/getx_controllers/on_boarding_one_controller.dart';
import 'package:tranquil_app/app/utils/constants.dart';
import 'package:tranquil_app/app/utils/sizes_helpers.dart';
import 'package:tranquil_app/app/routes/app_pages.dart';

import 'components/on_boarding_content.dart';


// ignore: must_be_immutable
class OnBoardingOneView extends GetView<OnBoardingOneController> {
  OnBoardingOneController onBoardingOneController = Get.put(OnBoardingOneController());

  OnBoardingOneView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SizedBox(
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: PageView.builder(
                      onPageChanged: (value) {
                        onBoardingOneController.currentPage.value = value;
                        print(onBoardingOneController.currentPage.value);
                      },
                      itemCount: onBoardingOneController.onBoardingData.length,
                      itemBuilder: (context, index) => OnBoardingContent(
                        image: onBoardingOneController.onBoardingData[index]["image"].toString(),
                        text: onBoardingOneController.onBoardingData[index]['text'].toString(),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: displayWidth(context)*0.16),
                        child: Column(
                          children: <Widget>[
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                onBoardingOneController.onBoardingData.length,
                                    (index) => buildDot(index: index),
                              ),
                            ),
                            Spacer(flex: 2),
                            SizedBox(
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamedAndRemoveUntil(context, Routes.SIGN_IN, (route) => false);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0,
                                            vertical: 20
                                        ),
                                        primary: kPrimaryColor,
                                      ),
                                      child: Text(
                                        'Next',
                                        style: TextStyle(
                                            fontSize: displayWidth(context) / 28
                                        ),
                                      )
                                  ),
                                )
                            ),

                            Spacer(),
                          ],
                        ),
                      )
                  )

                ],
              )
          ),
        )
    );
  }

  Widget buildDot({int? index}) {
    return Obx(() =>
        AnimatedContainer(
          duration: kAnimationDuration,
          margin: const EdgeInsets.only(right: 5),
          height: 6,
          width: onBoardingOneController.currentPage == index ? 20 : 6,
          decoration: BoxDecoration(
            color: onBoardingOneController.currentPage == index ? kPrimaryColor : const Color(0xFFD8D8D8),
            borderRadius: BorderRadius.circular(3),
          ),
        )
    );
  }
}
