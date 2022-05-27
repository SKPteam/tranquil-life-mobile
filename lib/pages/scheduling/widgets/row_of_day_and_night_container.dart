// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';

class RowOfDayAndNightContainer extends StatefulWidget {
  @override
  _RowOfDayAndNightContainerState createState() =>
      _RowOfDayAndNightContainerState();
}

class _RowOfDayAndNightContainerState extends State<RowOfDayAndNightContainer> {
  final List<Map<String, String>> timeSections = [
    {'svgUrl': 'assets/icons/icon-sunny.svg', 'title': 'Daytime'},
    {'svgUrl': 'assets/icons/icon-partly-sunny.svg', 'title': 'Nightime'}
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: displayWidth(context) * 0.07),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: timeSections.map(
              (timeSectionItem) {
            int index = timeSections.indexOf(timeSectionItem);
            return InkWell(
              onTap: () {

              },
              child: Container(
                width: displayWidth(context) * 0.405,
                height: 70,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 45,
                      height: 45,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: SvgPicture.asset(
                        timeSectionItem['svgUrl']!,
                        color: kPrimaryColor,
                        fit: BoxFit.none,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    //------------------------
                    // TITLE
                    //------------------------
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          timeSectionItem['title']!,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}