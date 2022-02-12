// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, must_be_immutable, use_key_in_widget_constructors

import 'dart:html';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/consultant_list_controller.dart';
import 'package:tranquil_life/controllers/consultant_registration_controller.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/models/consultant_porfolio_model.dart';
import 'package:tranquil_life/models/consultant_profile_model.dart';
import 'package:tranquil_life/models/schedule_date_model.dart';
import 'package:tranquil_life/pages/profile/widgets/consultantProfile.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:http/http.dart' as http;
import 'package:tranquil_life/pages/scheduling/scheduling_time/widgets/schedule_meeting_dialog.dart';


class ConsultantListView extends StatefulWidget {
  Size size = MediaQuery.of(Get.context!).size;

  // final List<Map<String, String>> answerOfQuestionaire;
  //
  //  ConsultantListView({Key? key, required this.answerOfQuestionaire})
  //     : super(key: key);

  @override
  _ConsultantListViewState createState() => _ConsultantListViewState();
}

class _ConsultantListViewState extends State<ConsultantListView> {

  @override
  void initState() {
    // print(jsonArray.map((e) => print(e['f_name'])).toList());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConsultantListController _ = Get.put(ConsultantListController());

    //print();

    return ResponsiveSafeArea(
      responsiveBuilder: (context, size) {
        return Scaffold(
            body: true
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //------------------------
                      //Back button
                      //------------------------
                      Container(
                        // padding: EdgeInsets.only(left: 10),
                        child: IconButton(
                          icon:
                              Icon(Icons.arrow_back, color: kPrimaryDarkColor),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),

                      //------------------------
                      //Heading of the page
                      //------------------------

                      Center(
                        child: Text(
                          'Speak with a Consultant',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      //------------------------
                      // Actual List of consultants
                      //------------------------
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.12),
                          child: ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                              height: 20,
                            ),
                            physics: BouncingScrollPhysics(),
                            itemCount: jsonArray.length,
                            itemBuilder: (context, index) {
                              //${jsonArray[index]['f_name']}
                              return Container(
                                height: 150,
                                padding: EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          //image of consultant
                                          Hero(
                                            tag: 'consultant$index',
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: true
                                                  ? Image.asset(
                                                      'assets/images/avatar_img1.png',
                                                      fit: BoxFit.cover,
                                                      height: size.height *
                                                          0.55)
                                                  : Image.asset(
                                                      'assets/images/default_img.png',
                                                      fit: BoxFit.cover,
                                                      height: size.height *
                                                          0.55,
                                                    ),
                                            ),
                                          ),
                                          //online sign
                                          Positioned(
                                            bottom: -5,
                                            right: -5,
                                            child: CircleAvatar(
                                              radius: 8,
                                              backgroundColor: true
                                                  // _
                                                  //     .consultantList[index]
                                                  //     .onlineStatus!
                                                  ? Colors.green
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Expanded(
                                      flex: 6,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: size.width * 0.05),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            //name of consultant
                                            FittedBox(
                                              fit: BoxFit.none,
                                              child: Text(
                                                "${jsonArray[index]["l_name"]} ${jsonArray[index]["f_name"]} ",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),

                                            //button with view profile text
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                MaterialStateProperty.all(
                                                    Color(0xff434343)),
                                                shape: MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(4),
                                                    )),
                                                elevation: MaterialStateProperty.all(2),
                                              ),
                                              onPressed: () {

                                                _.consultantPortfolio = ConsultantPortfolioModel(f_name: jsonArray[index]["f_name"].toString(),
                                                    l_name: jsonArray[index]["l_name"].toString());
                                                Navigator.of(context)
                                                    .pushReplacement( MaterialPageRoute(
                                                builder: (context) =>
                                                ConsultantProfile(
                                                _.consultantPortfolio,
                                                heroTag: 'consultant$index',
                                                key: null,
                                                ),
                                                ));

                                              },
                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/icons/metro-profile.svg',
                                                    fit: BoxFit.none,
                                                    color: kPrimaryColor,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  FittedBox(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      'View profile',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: kPrimaryColor,
                                                      ),
                                                    ),
                                                    fit: BoxFit.none,
                                                  )
                                                ],
                                              ),
                                            ),

                                            //button with schedule a meeting text
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                MaterialStateProperty.all(
                                                    Color(0xff434343)),
                                                shape: MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(4),
                                                    )),
                                                elevation: MaterialStateProperty.all(2),
                                              ),
                                              onPressed: () async {



                                                ///list of schedules containing schedule model for creating container templates
                                                ///of weekDay and date
                                                ///dates from tom to next 7 days generated from DateTime
                                                final List<Schedule> schedules =
                                                List.generate(
                                                  7,
                                                      (index) => Schedule(
                                                    DateTime.now().add(
                                                      Duration(days: index + 1),
                                                    ),
                                                  ),
                                                );

                                                //show modal sheet for Date Selecting
                                                bool result =
                                                await showModalBottomSheet<
                                                    bool>(
                                                  isDismissible: true,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius
                                                              .circular(
                                                              40))),
                                                  context: context,
                                                  builder: (context) =>
                                                      ScheduleMeetingDialog(
                                                        schedules: schedules,
                                                        consultantProfileModel: _
                                                            .consultantProfileModel,
                                                        isUserClient: true,
                                                        key: null,
                                                        reScheduleMeetingID: '',
                                                      ),
                                                ).then((value) {
                                                  print(value);
                                                  return value!;
                                                });
                                                print(result);
                                                if (result) {
                                                  Navigator.of(context)
                                                      .pop(result);
                                                }
                                                // if (result ?? false) {
                                                //   Navigator.of(context)
                                                //       .pop(result ?? false);
                                                // }


                                              },
                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: const [
                                                  Icon(Icons.schedule,
                                                      color: kPrimaryColor),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  FittedBox(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      'Schedule a Meeting',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: kPrimaryColor,
                                                      ),
                                                    ),
                                                    fit: BoxFit.contain,
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),


                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ));
      },
    );
  }

  Future<List> ConsultantListData() async {
    return jsonArray.map((e) => (e)).toList();
  }
}