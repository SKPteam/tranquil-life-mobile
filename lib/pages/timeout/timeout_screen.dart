//import 'package:firebase_auth/firebase_auth.dart';
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tranquil_life/constants/style.dart';

import 'package:tranquil_life/controllers/timeout_controller.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';


import 'package:tranquil_life/pages/timeout/widget/keyboard_number.dart';
import 'package:tranquil_life/pages/timeout/widget/pin_number.dart';
import 'package:tranquil_life/general_widgets/top_nav.dart';


class TimeoutView extends GetView<TimeoutController> {

  Size size = MediaQuery.of(Get.context!).size;

  final TimeoutController _ = Get.put(TimeoutController());

  TimeoutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      responsiveBuilder: (context, size) =>
          WillPopScope(
            onWillPop: () async {
              if (_.goBack) {
                return false;
              }
              return true;
            },
            child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Obx(() => Text(
                    "${_.appBarTitle}",
                    style:  TextStyle(color: Color(0xffffffff)),
                  ),),
                  actions: [
                    PopupMenuButton<String>(
                        iconSize: size.width * 0.1,
                        onSelected: _.optionAction,
                        itemBuilder: (BuildContext context) {
                          return _.menuOptions.map((option) {
                            return PopupMenuItem(
                                value: option,
                                child: Text(option));
                          }).toList();
                        })
                  ]),
              body: Container(
                decoration:  BoxDecoration(
                    gradient: LinearGradient(
                        colors: [kPrimaryColor, Color(0xff0C570F)],
                        begin: Alignment.topRight)
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: size.height *0.16),
                      padding:  EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [buildPinRow()],
                      ),
                    ),
                    SizedBox(height: size.height * 0.08),

                    Obx(() =>
                        Text(
                          "${_.nullPinText}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * 0.04),
                        ),),
                    SizedBox(height: size.height * 0.08),
                    buildNumberPad(context),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  buildPinRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        PINNumber(
          outlineInputBorder: _.outlineInputBorder,
          textEditingController: _.pinOneController,
        ),
        PINNumber(
          outlineInputBorder: _.outlineInputBorder,
          textEditingController: _.pinTwoController,
        ),
        PINNumber(
          outlineInputBorder: _.outlineInputBorder,
          textEditingController: _.pinThreeController,
        ),
        PINNumber(
          outlineInputBorder: _.outlineInputBorder,
          textEditingController: _.pinFourController,
        )
      ],
    );
  }

  buildNumberPad(BuildContext context) {
    return Expanded(
        child: Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.01),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          KeyboardNumber(
                              n: 1,
                              onPressed: () {
                                _.pinIndexSetup('1', context);
                              }),
                          KeyboardNumber(
                              n: 2,
                              onPressed: () {
                                _.pinIndexSetup('2', context);
                              }),
                          KeyboardNumber(
                              n: 3,
                              onPressed: () {
                                _.pinIndexSetup('3', context);
                              }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          KeyboardNumber(
                              n: 4,
                              onPressed: () {
                                _.pinIndexSetup('4', context);
                              }),
                          KeyboardNumber(
                              n: 5,
                              onPressed: () {
                                _.pinIndexSetup('5', context);
                              }),
                          KeyboardNumber(
                              n: 6,
                              onPressed: () {
                                _.pinIndexSetup('6', context);
                              }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          KeyboardNumber(
                              n: 7,
                              onPressed: () {
                                _.pinIndexSetup('7', context);
                              }),
                          KeyboardNumber(
                              n: 8,
                              onPressed: () {
                                _.pinIndexSetup('8', context);
                              }),
                          KeyboardNumber(
                              n: 9,
                              onPressed: () {
                                _.pinIndexSetup('9', context);
                              }),
                        ],
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                             SizedBox(width: 60),
                            KeyboardNumber(
                                n: 0,
                                onPressed: () {
                                  _.pinIndexSetup('0', context);
                                }),
                            SizedBox(
                              width: 60.0,
                              child: MaterialButton(
                                height: 60.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60.0)),
                                onPressed: () {
                                  _.clearPin();
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: size.width*0.04,),
                              ),
                            )
                          ])
                    ]))
        )
    );
  }

}