// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/my_time_slots_controller.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';

import 'widgets/row_of_day_and_night_container.dart';

class MyTimeSlotsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      responsiveBuilder: (context, size){
        return Scaffold(
          body: SizedBox(
            width: displayWidth(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: displayWidth(context) * 0.97,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //------------------------
                      // BACK BUTTON
                      //------------------------
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: kPrimaryColor,
                        ),
                      ),
                      SizedBox(
                        width: displayWidth(context) * 0.06,
                      ),
                      //------------------------
                      // SCREEN HEADING
                      //------------------------
                      Text(
                        '${dashboardController.firstName} ${dashboardController.lastName}',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                RowOfDayAndNightContainer(),

                Expanded(
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16),
                    children: [
                      Image.network('https://picsum.photos/250?image=1'),
                      Image.network('https://picsum.photos/250?image=2'),
                      Image.network('https://picsum.photos/250?image=3'),
                    ]
                ))
              ],
            ),
          ),
        );
      },
    );
  }
}
