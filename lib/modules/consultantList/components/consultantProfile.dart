// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tranquil_app/app/models/consultant_profile_model.dart';
import 'package:tranquil_app/app/utils/constants.dart';
import 'package:tranquil_app/app/utils/sizes_helpers.dart';

import 'consultantProfileInfoWidget.dart';

class ConsultantProfile extends StatelessWidget {
  final ConsultantProfileModel consultantProfileModel;
  final String heroTag;
  const ConsultantProfile(this.consultantProfileModel, {required Key? key, required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    child: consultantProfileModel.avatarUrl != ''
                        ? Image.network(
                      consultantProfileModel.avatarUrl.toString(),
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
                    icon: const Icon(Icons.arrow_back, color: kPrimaryDarkColor),
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
              consultantProfileModel: consultantProfileModel, key: null,
            ),
          )
        ],
      ),
    );
  }
}
