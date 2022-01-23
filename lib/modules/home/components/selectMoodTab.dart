// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_app/app/models/mood.dart';
import 'package:tranquil_app/app/utils/sizes_helpers.dart';

class SelectMood extends StatelessWidget {
  final void Function(int index, [String? moodSvgUrl]) moodOnTap;

  final List<Mood> moodsList = [
    Mood('Happy', 'assets/emojis/happy.png'),
    Mood('Sad', 'assets/emojis/sad.png'),
    Mood('Angry', 'assets/emojis/angry.png'),
    Mood('Frustrated', 'assets/emojis/frustrated.png'),
    Mood('Proud', 'assets/emojis/proud.png'),
    Mood('Fear', 'assets/emojis/fear.png'),
    Mood('Embarrassed', 'assets/emojis/embarrassed.png'),
    Mood('shock', 'assets/emojis/shock.png')
  ];

  SelectMood({Key? key, required this.moodOnTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: displayWidth(context) * 0.04,
        right: displayWidth(context) * 0.04,
      ),
      child: SizedBox(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  Text('How are you feeling today?',
                      style: TextStyle(
                          fontSize: displayWidth(context) * 0.042,
                          color: Colors.black)),
                ],
              ),
            ),
            SizedBox(
              height: displayHeight(context) * 0.08,
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
                          itemCount: moodsList.length,
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
    final mood = moodsList[index];
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
                style: const TextStyle(color: Colors.white),
              )
            ],
          )),
    );
  }
}
