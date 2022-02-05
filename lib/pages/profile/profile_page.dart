// ignore_for_file: preferructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/dashboard_controller.dart';
import 'package:tranquil_life/controllers/home_controller.dart';
import 'package:tranquil_life/controllers/profile_controller.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';
import 'package:tranquil_life/routes/app_pages.dart';
import 'widgets/cusListTile.dart';
import 'edit_profile_page.dart';

class ProfileView extends StatefulWidget {
  final void Function(int index) setBottomBarIndex;

  ProfileView({Key? key, required this.setBottomBarIndex})
      : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileController _ = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kLightBackgroundColor,
        body: Container(
            margin: EdgeInsets.only(top: displayHeight(context) * 0.05),
            child: Column(
              children: [
                Container(
                  color: Colors.blue,
                  //kLightBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.APP_SETTINGS);
                        },
                        child: Container(
                          // padding:
                          // EdgeInsets.symmetric(horizontal: 18.0),
                          width: double.infinity,
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
                                  onTap: (){
                                    Navigator.pushNamed(Get.context!, Routes.APP_SETTINGS);
                                  },
                                  child: Icon(
                                    Icons.settings,
                                    color: kPrimaryColor,
                                    size: displayWidth(context) * 0.06,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                            width: 90,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white),
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
                        width: displayWidth(context),
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("")
                                // DashboardController.to.userType!.value == "client"
                                //     ? Text(
                                //   _.username.value != null
                                //       ? _.username.value.toString()
                                //       : '',
                                //   style: TextStyle(
                                //       fontWeight: FontWeight.bold,
                                //       fontSize: 20,
                                //       color: kPrimaryDarkColor),
                                // ) : Text(
                                //   !DashboardController.to.firstName!.value.isNull
                                //       ? DashboardController.to.firstName!.value
                                //       : '',
                                //   style: TextStyle(
                                //       fontWeight: FontWeight.bold,
                                //       fontSize: 20,
                                //       color: kPrimaryDarkColor),
                                // ),
                                // SizedBox(
                                //   height: 3,
                                // ),
                                // Text(
                                //   !Get.find<HomeController>()
                                //       .location!.value.substring(
                                //       0,
                                //       Get.find<HomeController>().location!.value.indexOf("/")).isNull
                                //       ? Get.find<HomeController>()
                                //       .location!
                                //       .value
                                //       .substring(
                                //       0, Get.find<HomeController>().location!.value.indexOf("/")).toString()
                                //       : '',
                                //   style: TextStyle(
                                //       fontSize: 14, color: kPrimaryColor),
                                // )
                              ],
                            ),
                            SizedBox(
                                height: 40,
                                width: 100,
                                child: ElevatedButton(
                                  onPressed: ()  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context)
                                        => EditProfileView()));
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
                                    MaterialStateProperty.all<double>(
                                        4.0),
                                    backgroundColor:
                                    MaterialStateProperty.all(
                                        kPrimaryColor),
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
                        width: displayWidth(context) * 0.2,
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
                                    Navigator.pushNamed(context, Routes.CHAT_HISTORY);
                                  },
                                ),
                                CusListTile(
                                  icon:
                                  Icons.account_balance_wallet_outlined,
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
            ))
    );
  }
}
