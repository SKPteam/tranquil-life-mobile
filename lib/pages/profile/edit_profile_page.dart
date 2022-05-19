// ignore_for_file: must_be_immutable, unrelated_type_equality_checks, prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/edit_profile_controller.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
class EditProfileView extends StatelessWidget {
  final EditProfileController _ = Get.put(EditProfileController());

  EditProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      responsiveBuilder: (context, size) => Scaffold(
          backgroundColor: kLightBackgroundColor,
          body: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Icon(Icons.arrow_back, color: kPrimaryColor),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // print('PHOTOOOOOO: ${_.photoUrl.value}');
                            // await _.updateToUserDatabase();
                            // Get.back(result: _.photoUrl.value);
                            Navigator.of(context).pop('done');
                          },
                          child: Text(
                            'Done',
                            style:
                                TextStyle(color: kPrimaryColor, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20, bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white70,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 32, top: 12),
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: true
                                //_.profileDataLoaded.isTrue
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      _.editPhoto(context),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      _.editField(context,
                                          title: 'First Name',
                                          controller: _.controllers[0],
                                          inputFormattors: [],
                                          onTapped: () {}),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      _.editField(context,
                                          title: 'Last Name',
                                          controller: _.controllers[1],
                                          inputFormattors: [],
                                          onTapped: () {}),
                                      SizedBox(
                                        height: 50,
                                      ),
                                      _.editField(context,
                                          title: 'Date of Birth',
                                          controller: _.controllers[2],
                                          readOnly: true,
                                          inputFormattors: [],
                                          onTapped: () {}),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      _.editField(context,
                                          title: 'Gender',
                                          controller: _.controllers[3],
                                          readOnly: false,
                                          inputFormattors: [],
                                          onTapped: () {}),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      _.editField(context,
                                          title: 'Location',
                                          controller: _.controllers[4],
                                          readOnly: true,
                                          inputFormattors: [],
                                          onTapped: () {}),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      _.editField(
                                        context,
                                        title: 'Phone',
                                        controller: _.controllers[5],
                                        inputFormattors: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        onTapped: () {},
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      _.editField(context,
                                          title: 'Time zone',
                                          controller: _.controllers[6],
                                          readOnly: true,
                                          onTapped: () {},
                                          inputFormattors: []),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      _.editField(context,
                                          title: 'App lock pin',
                                          controller: _.controllers[7],
                                          readOnly: true,
                                          onTapped: () {},
                                          inputFormattors: []),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      if (dashboardController.userType.value ==
                                          consultant)
                                        _.editField(
                                          context,
                                          title: 'Bank Name',
                                          controller: _.controllers[8],
                                          inputFormattors: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r"[a-zA-Z]+|\s"))
                                          ],
                                          onTapped: () {},
                                        ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      if (dashboardController.userType.value ==
                                          consultant)
                                        _.editField(
                                          context,
                                          title: 'IBAN',
                                          controller: _.controllers[9],
                                          inputFormattors: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          onTapped: () {},
                                        ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  )
                                : Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),

              //_.uploadingPhoto.value ?
              // Container(
              //   height: displayHeight(context),
              //   width: displayWidth(context),
              //   color: Colors.black38,
              //   child: Center(
              //     child: Container(
              //       height: 50,
              //       width: 50,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(8),
              //         color: Colors.black87,
              //       ),
              //       child: Center(
              //         child: SizedBox(
              //           height: 30,
              //           width: 30,
              //           child: CircularProgressIndicator(),
              //         ),
              //       ),
              //     ),
              //   ),
              // )
              // : Container()),
            ],
          )),
    );
  }
}
