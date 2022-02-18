// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/home_controller.dart';
import 'package:tranquil_life/models/mood.dart';
import 'package:tranquil_life/widgets/custom_text.dart';


class SelectMood extends StatelessWidget {
  final void Function(int index, [String? moodSvgUrl]) moodOnTap;

  SelectMood({Key? key, required this.moodOnTap}) : super(key: key);

  final HomeController _homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(
        left: size.width * 0.04,
        right: size.width * 0.04,
      ),
      child: SizedBox(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  CustomText(
                    text: 'How are you feeling today?',
                    color: dark,
                    size: 18,
                    weight: FontWeight.w700,
                    align: TextAlign.start
                  )
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.08,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff404640),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(12, 12),
                        blurRadius: 12,
                        color: Colors.black38,
                        spreadRadius: -4)
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _homeController.moodsList.length,
                          itemBuilder: (BuildContext context, int index) =>
                              buildMoodCard(context, index)),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMoodCard(BuildContext context, int index) {
    final mood = _homeController.moodsList[index];
    return InkWell(
      onTap: () {
        moodOnTap(2, mood.image);
      },
      child: Container(
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.only(left: 8, top: 8, right: 8),
          child: Column(
            children: [
              Image.asset(
                mood.image,
                height: 30,
                width: 30,
              ),
              Text(
                mood.name,
                style: const TextStyle(color: light),
              )
            ],
          )),
    );
  }
}