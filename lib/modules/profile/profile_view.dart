import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tranquil_app/app/getx_controllers/dashboard_controller.dart';
import 'package:tranquil_app/app/getx_controllers/home_controller.dart';
import 'package:tranquil_app/app/getx_controllers/profile_controller.dart';
import 'package:tranquil_app/app/modules/profile/edit_profile_view.dart';
import 'package:tranquil_app/app/routes/app_pages.dart';
import 'package:tranquil_app/app/utils/constants.dart';
import 'package:tranquil_app/app/utils/sizes_helpers.dart';

import 'components/cusListTile.dart';

class ProfileView extends StatefulWidget {
  final void Function(int index) setBottomBarIndex;

  const ProfileView({Key? key, required this.setBottomBarIndex})
      : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileController _ = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        backgroundColor: kLightBackgroundColor,
        body: Container(
                margin: EdgeInsets.only(top: displayHeight(context) * 0.05),
                child: Column(
                  children: [
                    Container(
                      color: kLightBackgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.APP_SETTINGS);
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18.0),
                              width: displayWidth(context),
                              height: 80,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
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
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
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
                                      child: _.loaded.isFalse
                                          ? Image.asset(
                                              'assets/images/avatar_img1.png',
                                              fit: BoxFit.cover,
                                              width: 85,
                                              height: 85,
                                            )
                                          : Image.network(
                                              _.getStorage!
                                                  .read(userAvatarUrl)
                                                  .toString(),
                                              fit: BoxFit.cover,
                                              width: 85,
                                              height: 85)),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 100,
                            width: displayWidth(context),
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DashboardController.to.userType!.value == "client"
                                        ? Text(
                                      _.username.value != null
                                          ? _.username.value.toString()
                                          : '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: kPrimaryDarkColor),
                                    ) : Text(
                                        !DashboardController.to.firstName!.value.isNull
                                            ? DashboardController.to.firstName!.value
                                            : '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: kPrimaryDarkColor),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      !Get.find<HomeController>()
                                          .location!.value.substring(
                                          0,
                                          Get.find<HomeController>().location!.value.indexOf("/")).isNull
                                          ? Get.find<HomeController>()
                                          .location!
                                          .value
                                          .substring(
                                          0, Get.find<HomeController>().location!.value.indexOf("/")).toString()
                                          : '',
                                      style: const TextStyle(
                                          fontSize: 14, color: kPrimaryColor),
                                    )
                                  ],
                                ),
                                SizedBox(
                                    height: 40,
                                    width: 100,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        var result = await Get.to<String?>(
                                            () => EditProfileView());
                                        print(result);
                                        if (result != null &&
                                            result.isNotEmpty) {
                                          await _.checkAuthState();
                                          setState(() {});
                                        }
                                      },
                                      style: ButtonStyle(
                                        elevation:
                                            MaterialStateProperty.all<double>(
                                                4.0),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                kPrimaryColor),
                                      ),
                                      child: const Center(
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
                                    DashboardController.to.userType!.value == client
                                    ? CusListTile(
                                      icon: Icons.favorite_outline,
                                      title: 'Favourite consultants',
                                      onTap: () {
                                        //TODO: clicked on favourite consultants
                                      },
                                    )
                                    : SizedBox(),
                                    const SizedBox(
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
    )
    );
  }
}
