// ignore_for_file: preferructors, prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/dashboard_controller.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/models/journal_model.dart';

class SelectedNoteView extends StatelessWidget {
  Size size = MediaQuery.of(Get.context!).size;
  // final JournalModel journalModel;
  //
  // SelectedNoteView({Key? key, required this.journalModel}) : super(key: key);

  // final SelectedNoteController _ = Get.put(SelectedNoteController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      responsiveBuilder: (context, size) => Scaffold(
        backgroundColor: kLightBackgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //------------------------
            // APPBAR
            //------------------------
            Center(
              child: Container(
                width: size.width * 0.95,
                padding: EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //------------------------
                    // BACK BUTTON
                    //------------------------
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back, color: kPrimaryColor),
                        ),
                      ),
                    ),
                    Spacer(),
                    DashboardController.to.userType == client
                        ? InkWell(
                            onTap: () {
                              displayConsultantList(context);
                            },
                            child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                //------------------------
                                // Edit SVG
                                //------------------------
                                child: Icon(
                                  Icons.share,
                                  color: kPrimaryColor,
                                )))
                        : SizedBox()
                  ],
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    //------------------------
                    // HEADING OF THE JOURNAL CONTAINER
                    //------------------------
                    Container(
                      padding: EdgeInsets.only(left: 24, right: 40, top: 10),
                      child: Text(
                        'journalModel.heading',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    //------------------------
                    // DATE AND EMOJI CONTAINER
                    //------------------------
                    Container(
                      padding: EdgeInsets.all(24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "TimeManipulativeHelperController",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          //------------------------
                          // MOOD CONTAINER
                          //------------------------
                          //if there is a mood attached to the journal element then the mood
                          //container in the topRight corner will be created
                          // if (journalModel.moodSvgUrl.isNotEmpty)
                          //   Center(
                          //     child: Image.network(
                          //       journalModel.moodSvgUrl,
                          //       fit: BoxFit.contain,
                          //       height: 60,
                          //       width: 60,
                          //     ),
                          //   ),
                        ],
                      ),
                    ),
                    //------------------------
                    // CONTENT OF THE JOURNAL ENTRY
                    //------------------------
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      child: Text(
                        'journalModel.body',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void displayConsultantList(BuildContext context) {
    Get.bottomSheet(Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 16.0),
              child: Text(
                "Share this with your consultant",
                style: TextStyle(fontSize: 16.0, color: kPrimaryDarkColor),
              ),
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  height: 10,
                ),
                physics: BouncingScrollPhysics(),
                itemCount: 4,
                // .consultantList.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Get.back();
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return AlertDialog(
                            content: Text("Share with Consultalts"),
                            // "${_.consultantList[index].firstName} ${ _.consultantList[index].lastName}"
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () async {},
                                    child: Text(
                                      "Yes",
                                      style: TextStyle(
                                          color: kPrimaryDarkColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => Get.back(),
                                    child: Text(
                                      "No",
                                      style: TextStyle(
                                          color: kPrimaryDarkColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              )
                            ],
                          );
                        });
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //image of consultant
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  width: 2.0, color: kSecondaryColor)),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                  "_.consultantList[index].avatarUrl",
                                  fit: BoxFit.cover,
                                  width: 55,
                                  height: 55),
                              // Image.asset(
                              //   'assets/images/avatar_img1.png',
                              //   fit: BoxFit.cover,
                              //   width: 55,
                              //   height: 55,
                              // ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Show Consultant Firstname and Lastname",
                          style: TextStyle(fontSize: 18.0),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )));
  }
}