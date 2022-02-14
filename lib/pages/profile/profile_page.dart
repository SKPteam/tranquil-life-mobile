// ignore_for_file:  prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, prefer_const_constructors_in_immutables, sized_box_for_whitespace, avoid_unnecessary_containers, must_be_immutable

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/onboarding_controller.dart';
import 'package:tranquil_life/controllers/profile_controller.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/routes/app_pages.dart';
import 'widgets/cusListTile.dart';
import 'edit_profile_page.dart';

class ProfileView extends StatefulWidget {
  final void Function(int index) setBottomBarIndex;

  Size size = MediaQuery.of(Get.context!).size;

  ProfileView({Key? key, required this.setBottomBarIndex}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileController _ = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      responsiveBuilder: (context, size) => Scaffold(
          backgroundColor: kLightBackgroundColor,
          body: Container(
              child: Column(
            children: [
              Container(
                color: kLightBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      width: size.width,
                      height: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    Get.context!, Routes.APP_SETTINGS);
                              },
                              child: Icon(
                                Icons.settings,
                                color: kPrimaryColor,
                                size: 32,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Center(
                        child: Container(
                          height: 90,
                          width: size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            //color: Colors.white
                          ),
                          child: Center(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child:
                                      //_.loaded.isFalse?
                                      Image.asset(
                                    'assets/images/avatar_img1.png',
                                    fit: BoxFit.cover,
                                    width: 85,
                                    height: 85,
                                  ))
                              // : Image.network(
                              // _.getStorage!
                              //     .read(userAvatarUrl)
                              //     .toString(),
                              // fit: BoxFit.cover,
                              // width: 85,
                              // height: 85)),
                              ),
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
                      width: size.width,
                      // color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Get.find<OnBoardingController>().userType.value ==
                                      client
                                  ? Text(
                                      "Danny ",
                                      // _.username.value != null
                                      //     ? _.username.value.toString()
                                      //     : '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: kPrimaryDarkColor),
                                    )
                                  : Text(
                                      "Dr Julius",
                                      // !DashboardController.to.firstName!.value.isNull
                                      //     ? DashboardController.to.firstName!.value
                                      //     : '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: kPrimaryDarkColor),
                                    ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                "Lekki, Nigeria",
                                // !Get.find<HomeController>()
                                //     .location!.value.substring(
                                //     0,
                                //     Get.find<HomeController>().location!.value.indexOf("/")).isNull
                                //     ? Get.find<HomeController>()
                                //     .location!
                                //     .value
                                //     .substring(
                                //     0, Get.find<HomeController>().location!.value.indexOf("/")).toString()
                                //     : '',
                                style: TextStyle(
                                    fontSize: 14, color: kPrimaryColor),
                              )
                            ],
                          ),
                          SizedBox(
                              height: 40,
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditProfileView()));
                                  // var result = await Get.to<String?>(
                                  //         () => EditProfileView());
                                  // print(result);
                                  // if (result != null &&
                                  //     result.isNotEmpty) {
                                  //   // await _.checkAuthState();
                                  //   // setState(() {});
                                  // }
                                },
                                style: ButtonStyle(
                                  elevation:
                                      MaterialStateProperty.all<double>(4.0),
                                  backgroundColor:
                                      MaterialStateProperty.all(kPrimaryColor),
                                ),
                                child: Center(
                                  child: Text(
                                    "EDIT",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: size.width * 0.2,
                      color: kLightBackgroundColor,
                    ),
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        color: Colors.grey[300],
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CusListTile(
                                icon: Icons.credit_card_outlined,
                                title: 'Transaction History',
                                onTap: () {
                                  widget.setBottomBarIndex(1);
                                },
                              ),
                              CusListTile(
                                icon: Icons.history_outlined,
                                title: 'Chat History',
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, Routes.CHAT_HISTORY);
                                },
                              ),
                              CusListTile(
                                icon: Icons.account_balance_wallet_outlined,
                                title: 'My Wallet',
                                onTap: () {
                                  widget.setBottomBarIndex(1);
                                },
                              ),
                              CusListTile(
                                icon: Icons.schedule_outlined,
                                title: 'Scheduled Meetings',
                                onTap: () {
                                  widget.setBottomBarIndex(0);
                                },
                              ),
                              //DashboardController.to.userType!.value == client ?
                              CusListTile(
                                icon: Icons.favorite_outline,
                                title: 'Favourite consultants',
                                onTap: () {
                                  //TODO: clicked on favourite consultants
                                },
                              ),
                              //   : SizedBox(),
                              SizedBox(
                                height: 90,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ))),
    );
  }
}
