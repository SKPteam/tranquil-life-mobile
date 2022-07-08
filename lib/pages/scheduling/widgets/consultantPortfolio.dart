// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, avoid_unnecessary_containers, must_be_immutable

import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/pages/scheduling/widgets/consultantPortfolio_info_widget.dart';
import 'package:tranquil_life/routes/app_pages.dart';


class ConsultantPortfolio extends StatelessWidget {
  Size size = MediaQuery.of(Get.context!).size;
  final String? heroTag;
  final String? fName;
  final String? lName;
  final double? latitude;
  final double? longitude;
  final List? specialties;
  final String? yearsOfExperience;
  final double? fee;
  final List? languages;

  ConsultantPortfolio({
    Key? key,
    this.heroTag,
    this.fName,
    this.lName,
    this.latitude,
    this.longitude,
    this.specialties,
    this.yearsOfExperience,
    this.fee, this.languages}) : super(key: key);


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
                    tag: heroTag!,
                    child: Container(
                        alignment: Alignment.topLeft,
                        width: size.width,
                        height: size.height * 0.55,
                        child: true
                        //consultantProfileModel.avatarUrl != ''
                            ? Image.asset(
                          'assets/images/avatar_img1.png',
                          // consultantProfileModel.avatarUrl.toString(),
                          fit: BoxFit.cover,
                          height: size.height * 0.55,
                        )
                            : Image.asset(
                          'assets/images/default_img.png',
                          fit: BoxFit.cover,
                          height: size.height * 0.55,
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
                        icon: Icon(Icons.arrow_back, color: light),
                        onPressed: () {
                          Get.offNamed(Routes.CONSULTANT_LIST);
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
                  fName: fName,
                  lName: lName,
                  latitude: latitude,
                  longitude: longitude,
                  specialties: specialties,
                  yearsOfExperience: yearsOfExperience,
                  fee: fee,
                  languages: languages,
                  key: null),
              )
            ],
          ),
        );
      },
    );
  }
}

