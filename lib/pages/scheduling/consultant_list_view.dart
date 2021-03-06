// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, must_be_immutable, use_key_in_widget_constructors

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
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/models/schedule_date_model.dart';
import 'package:tranquil_life/pages/scheduling/widgets/consultantPortfolio.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:http/http.dart' as http;

import '../../models/consultant_model.dart';
import '../../routes/app_pages.dart';


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
  ConsultantListController _ = Get.put(ConsultantListController());

  @override
  Widget build(BuildContext context) {
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
                            Get.offNamedUntil(Routes.DASHBOARD, (route) => false);
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
                              horizontal: 16.0),
                          child: FutureBuilder<List<Consultant>>(
                            future:  _.getConsultantList(),
                            builder: (context, snapshot){
                              if (snapshot.hasError) {
                                return Text(snapshot.error.toString());
                              }

                              if (snapshot.connectionState == ConnectionState.waiting ||
                                  snapshot.hasData == false) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      CircularProgressIndicator(
                                          valueColor:
                                          AlwaysStoppedAnimation<Color>(Colors.yellow)
                                      ),
                                      // Loader Animation Widget
                                      Padding(padding: const EdgeInsets.only(top: 20.0)),
                                    ],
                                  ),
                                );
                              }

                              //if has data
                              if(snapshot.hasData){
                                return ListView(
                                  children: snapshot.data!.map((consultant){
                                    return Container(
                                      height: 150,
                                      padding: EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                //image of consultant
                                                Hero(
                                                  tag: 'consultant$consultant',
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
                                            flex: 2,
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  left: size.width * 0.05),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  //name of consultant
                                                  FittedBox(
                                                    fit: BoxFit.none,
                                                    child: Text(
                                                      "${consultant.fName} ${consultant.lName}",
                                                      textAlign: TextAlign.start,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),

                                                  SizedBox(height: size.height*0.002),


                                                  //button with view profile text
                                                  SizedBox(
                                                    height: 45,
                                                    child: ElevatedButton(
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
                                                        Navigator.of(context)
                                                            .pushReplacement( MaterialPageRoute(
                                                          builder: (context) =>
                                                              ConsultantPortfolio(
                                                                heroTag: 'consultant${consultant}',
                                                                fName: consultant.fName,
                                                                lName: consultant.lName,
                                                                latitude: consultant.latitude,
                                                                longitude: consultant.longitude,
                                                                specialties: consultant.specialties,
                                                                yearsOfExperience: consultant.yearsOfExperience,
                                                                fee: consultant.fee,
                                                                languages: consultant.languages,
                                                                key: null,),
                                                        ));
                                                      },
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.start,
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
                                                  ),

                                                  SizedBox(height: size.height*0.002),

                                                  //button with schedule a meeting text
                                                  SizedBox(
                                                    height: 45,
                                                    child: ElevatedButton(
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
                                                        // final List<Schedule> schedules =
                                                        // List.generate(
                                                        //   7,
                                                        //       (index) => Schedule(
                                                        //     DateTime.now().add(
                                                        //       Duration(days: index + 1),
                                                        //     ),
                                                        //   ),
                                                        // );
                                                        //
                                                        // //show modal sheet for Date Selecting
                                                        // bool result =
                                                        // await showModalBottomSheet<
                                                        //     bool>(
                                                        //   isDismissible: true,
                                                        //   shape: RoundedRectangleBorder(
                                                        //       borderRadius:
                                                        //       BorderRadius.vertical(
                                                        //           top: Radius
                                                        //               .circular(
                                                        //               40))),
                                                        //   context: context,
                                                        //   builder: (context) =>
                                                        //       ScheduleMeetingDialog(
                                                        //         schedules: schedules,
                                                        //         consultantProfileModel: _
                                                        //             .consultantProfileModel,
                                                        //         isUserClient: true,
                                                        //         key: null,
                                                        //         reScheduleMeetingID: '',
                                                        //       ),
                                                        // ).then((value) {
                                                        //   print(value);
                                                        //   return value!;
                                                        // });
                                                        // print(result);
                                                        // if (result) {
                                                        //   Navigator.of(context)
                                                        //       .pop(result);
                                                        // }
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
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),


                                        ],
                                      ),
                                    );
                                  }).toList(),
                                );
                              }


                              if (!snapshot.hasData &&
                                  snapshot.connectionState == ConnectionState.done) {
                                return Text('No Partners');
                              }

                              if (snapshot.connectionState != ConnectionState.done) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }


                              if (snapshot.data! == null || snapshot.data!.length == 0) {
                                return Column(
                                  children: <Widget>[
                                    Center(child: Text("Unable to find any partners"))
                                  ],
                                );
                              }

                              return Text('No Data');
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

}