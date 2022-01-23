// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/helpers/constants.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';
import '../../../main.dart';
import '../consultantList/components/consultantProfile.dart';

class ConsultantListView extends StatefulWidget {
  final List<Map<String, String>> answerOfQuestionaire;

  const ConsultantListView({Key? key, required this.answerOfQuestionaire})
      : super(key: key);

  @override
  _ConsultantListViewState createState() => _ConsultantListViewState();
}

class _ConsultantListViewState extends State<ConsultantListView> {
  @override
  Widget build(BuildContext context) {
    ConsultantListController _ = Get.put(ConsultantListController());

    print(widget.answerOfQuestionaire[2]);

    return Scaffold(
        body: Obx(() => SafeArea(
          child: _.consultantListLoaded.isTrue
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
                                    onPressed: () async {
                                      await accountSettingsRef!
                                          .child(_
                                          .consultantList[index]
                                          .uid)
                                          .child('profile')
                                          .once()
                                          .then((DataSnapshot
                                      snapshot) {
                                        var values = snapshot.value;

                                        print('uid ' +
                                            _.consultantList[index]
                                                .uid);
                                        _.consultantProfileModel = ConsultantProfileModel(
                                            uid: _
                                                .consultantList[index]
                                                .uid,
                                            areaOfExpertise:
                                            values['areaOfExpertise'] ??
                                                '',
                                            email: values[userEmail] ??
                                                '',
                                            avatarUrl: _
                                                .consultantModel
                                                .avatarUrl
                                                .isEmpty
                                                ? ''
                                                : _.consultantModel
                                                .avatarUrl,
                                            firstName: _
                                                .consultantList[index]
                                                .firstName,
                                            lastName: _
                                                .consultantList[index]
                                                .lastName,
                                            description:
                                            values['description'] ??
                                                '',
                                            fee: values['fee'] ?? 0,
                                            preferredLangs: values['preferredLangs'] ?? '',
                                            location: _.consultantList[index].location.isEmpty ? " " :
                                            _.consultantList[index]
                                                .location
                                                .substring(
                                                0,  _.consultantList[index]
                                                .location.indexOf("/")).toString(),
                                            yearsOfExperience: values['yearsOfExperience'] ?? '',
                                            timeZone: '',
                                            phoneNum: values["phoneNumber"] ?? "");
                                      });
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            ConsultantProfile(
                                              _.consultantProfileModel,
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
                                    onPressed: () async {
                                      await accountSettingsRef!
                                          .child(_
                                          .consultantList[index]
                                          .uid)
                                          .child('profile')
                                          .once()
                                          .then((DataSnapshot
                                      snapshot) {
                                        var keys =
                                            snapshot.value.keys;
                                        var values = snapshot.value;
                                        print(keys);
                                        print(values);
                                        _.consultantProfileModel =
                                            ConsultantProfileModel(
                                              uid: _.consultantList[index]
                                                  .uid,
                                              areaOfExpertise: values[
                                              'areaOfExpertise'] ??
                                                  '',
                                              avatarUrl: _.consultantModel
                                                  .avatarUrl.isEmpty
                                                  ? " "
                                                  : _.consultantModel
                                                  .avatarUrl,
                                              firstName: _
                                                  .consultantList[index]
                                                  .firstName,
                                              lastName: _
                                                  .consultantList[index]
                                                  .lastName,
                                              description:
                                              values['description'] ??
                                                  '',
                                              fee: values['fee'] ?? 0,
                                              preferredLangs: values[
                                              'preferredLangs'] ??
                                                  '',
                                              location: _
                                                  .consultantList[
                                              index]
                                                  .location
                                                  .isEmpty
                                                  ? ''
                                                  : _
                                                  .consultantList[
                                              index]
                                                  .location,
                                              yearsOfExperience: values[
                                              'yearsOfExperience'] ??
                                                  '',
                                              timeZone: '',
                                              email: '',
                                              phoneNum: '',
                                            );
                                      });

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
        )));
  }
}
