
// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, avoid_unnecessary_containers

import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/helpers/constants.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';
import 'package:tranquil_life/models/consultant_porfolio_model.dart';
import 'package:tranquil_life/models/consultant_profile_model.dart';
import 'package:tranquil_life/pages/scheduling/widgets/consultantProfile_info_widget.dart';


class ConsultantProfile extends StatelessWidget {
  //final ConsultantProfileModel consultantProfileModel;
  final ConsultantPortfolioModel consultantPortfolio;
  final String heroTag;

  ConsultantProfile(this.consultantPortfolio,
      {required Key? key, required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      responsiveBuilder: (context, size) {
        return Scaffold(
          //------------------------
          // STACK FOR PROFILE PICTURE AND CONSULTANT INFO
          //------------------------
          body: Stack(
            children: [
              //------------------------
              // STACK FOR PROFILE PICTURE AND BACK BUTTON
              //------------------------
              Stack(
                alignment: Alignment.topLeft,
                children: [
                  //------------------------
                  // PROFILE IMAGE
                  //------------------------
                  Hero(
                    tag: heroTag,
                    child: Container(
                        alignment: Alignment.topLeft,
                        width: displayWidth(context),
                        height: displayHeight(context) * 0.55,
                        child: true
                        //consultantProfileModel.avatarUrl != ''
                            ? Image.asset(
                          'assets/images/avatar_img1.png',
                          // consultantProfileModel.avatarUrl.toString(),
                          fit: BoxFit.cover,
                          height: displayHeight(context) * 0.55,
                        )
                            : Image.asset(
                          'assets/images/default_img.png',
                          fit: BoxFit.cover,
                          height: displayHeight(context) * 0.55,
                        )),
                  ),
                  SafeArea(
                    child:
                    //------------------------
                    // BACK BUTTON
                    //------------------------
                    Container(
                      // padding: EdgeInsets.only(left: 10),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: kPrimaryDarkColor),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              //------------------------
              // PROFILE INFO CONTAINER
              //------------------------
              Align(
                alignment: Alignment.bottomCenter,
                child: ConsultantProfileInfoWidget(
                  consultantProfileModel: consultantPortfolio, key: null,
                  //consultantProfileModel: consultantProfileModel, key: null,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
