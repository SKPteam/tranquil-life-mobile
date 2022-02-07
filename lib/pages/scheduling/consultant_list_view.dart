// ignore_for_file: prefer_const_constructors, avoid_print, avoid_unnecessary_containers

import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/consultant_list_controller.dart';
import 'package:tranquil_life/controllers/consultant_registration_controller.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';
import 'package:tranquil_life/models/consultant_profile_model.dart';
import 'package:tranquil_life/models/schedule_date_model.dart';
import 'package:tranquil_life/pages/profile/widgets/consultantProfile.dart';


class ConsultantListView extends StatefulWidget {
  // final List<Map<String, String>> answerOfQuestionaire;
  //
  // const ConsultantListView({Key? key, required this.answerOfQuestionaire})
  //     : super(key: key);

  @override
  _ConsultantListViewState createState() => _ConsultantListViewState();
}

class _ConsultantListViewState extends State<ConsultantListView> {
  @override
  Widget build(BuildContext context) {
    ConsultantListController _ = Get.put(ConsultantListController());

    //print(widget.answerOfQuestionaire[]);

    return Scaffold(
        body: SafeArea(
          child: true
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
                  icon: const Icon(Icons.arrow_back,
                      color: kPrimaryDarkColor),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              const SizedBox(
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
                      fontSize: displayWidth(context) * 0.064,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              //------------------------
              // Actual List of consultants
              //------------------------
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: displayWidth(context) * 0.12),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      height: 20,
                    ),
                    physics: BouncingScrollPhysics(),
                    itemCount: _.consultantList.length,
                    //------------------------
                    // Individual consultant container
                    //------------------------
                    itemBuilder: (context, index) => Container(
                      height: 150,
                      padding: const EdgeInsets.all(12),
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
                                    child: _.consultantList[index]
                                        .avatarUrl !=
                                        ''
                                        ? Image.network(
                                        _.consultantList[index]
                                            .avatarUrl,
                                        fit: BoxFit.cover,
                                        height: displayHeight(
                                            context) *
                                            0.55)
                                        : Image.asset(
                                      'assets/images/default_img.png',
                                      fit: BoxFit.cover,
                                      height: displayHeight(
                                          context) *
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
                                    backgroundColor: _
                                        .consultantList[index]
                                        .onlineStatus!
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
                                  left: displayWidth(context) * 0.05),
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
                                      _.consultantList[index]
                                          .firstName +
                                          " " +
                                          _.consultantList[index]
                                              .lastName,
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
                                      shape:
                                      MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(4),
                                          )),
                                      elevation:
                                      MaterialStateProperty.all(
                                          2),
                                    ),
                                    onPressed: ()  {

                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            ConsultantProfile(
                                              // _.consultantProfileModel,
                                              // heroTag: 'consultant$index',
                                              // key: null,
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
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Expanded(
                                            child: FittedBox(
                                              alignment:
                                              Alignment.centerLeft,
                                              child: Text(
                                                'View profile',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: kPrimaryColor,
                                                ),
                                              ),
                                              fit: BoxFit.none,
                                            ))
                                      ],
                                    ),
                                  ),

                                  //button with schedule a meeting text
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(
                                          Color(0xff434343)),
                                      shape:
                                      MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(4),
                                          )),
                                      elevation:
                                      MaterialStateProperty.all(
                                          2),
                                    ),
                                    onPressed: ()  {},
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
                                        Expanded(
                                            child: FittedBox(
                                              alignment:
                                              Alignment.centerLeft,
                                              child: Text(
                                                'Schedule a Meeting',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: kPrimaryColor,
                                                ),
                                              ),
                                              fit: BoxFit.contain,
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
              : const Center(
            child: CircularProgressIndicator(),
          ),
        ));
  }
}
