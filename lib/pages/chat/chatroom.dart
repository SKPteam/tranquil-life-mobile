// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/helpers/constants.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';
import 'package:tranquil_life/pages/chat/audio_call_screen.dart';
import 'package:tranquil_life/widgets/valueListenableBuilder2.dart';

class ChatScreenPage extends StatelessWidget {

  List<String> menuList = [
    'Invite',
    'Participants',
    'Health Profile',
    'End Session'
  ];

  //menu icon options
  optionAction(String option) {
    print(option);
    if (option == 'Invite') {
     // showInviteMenu(Context, 40);
    } else {
      // PushNotificationHelperController.instance
      //     .updateTokenAfterSigningOut(auth!.currentUser!.uid);
      // auth!.signOut();
      // Navigator.pushNamedAndRemoveUntil(
      //     Get.context!, Routes.SIGN_IN, (route) => false);
    }
  }

  final ValueNotifier<double> heightOfText = ValueNotifier<double>(45.00);

  Size _textSize(String text, TextStyle style) {

    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

   ChatScreenPage({Key? key}) : super(key: key);


  double? textFieldWidth;
  late Size textSize;

  @override
  Widget build(BuildContext context) {
    textSize = _textSize(
      'c',
       TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SizedBox(
            height: size.height,
            width: size.width,
            child: Image.asset(
              'assets/images/chat_screen_bg_image.png',
              fit: BoxFit.cover,
            ),
          ),

            Center(
              child: Container(
                margin:  EdgeInsets.all(16),
                padding:  EdgeInsets.all(16),
                child: true
                    ? Text(
                  "errText",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                      decoration: TextDecoration.none,
                      fontFamily: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .fontFamily),
                )
                    :  CircularProgressIndicator(),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black12,
                         Color(0xff001A07).withOpacity(0.75),
                      ])),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SafeArea(
                  child: Container(
                    height: 60,
                    color: Colors.transparent,
                    padding:  EdgeInsets.only(left: 8),
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            icon:  Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        Stack(
                          children: [
                            CircleAvatar(
                                backgroundColor:  Color(0xffC9D8CD),
                                radius: 22,
                                child: Center(
                                  child: CircleAvatar(
                                    radius: 20,
                                    foregroundImage: AssetImage(
                                      'assets/images/avatar_img1.png',
                                    ),
                                  ),
                                )),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  decoration:  BoxDecoration(
                                    color: kIsOnlineColor,
                                    shape: BoxShape.circle,
                                  ),
                                  width: 12,
                                  height: 12,
                                ))
                          ],
                        ),
                         SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: 'title',
                              child: Text(
                                'Consultants First Lastname',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none,
                                    fontFamily: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .fontFamily),
                              ),
                            ),

                              Text(
                                "scheduledMeeting!.duration",
                                style:  TextStyle(
                                    color: kSecondaryColor, fontSize: 16),
                              )
                          ],
                        ),
                         Spacer(),

                          Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: IconButton(
                              padding:  EdgeInsets.all(4.0),
                              icon:  Icon(
                                Icons.call,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                     AudioCallScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                         SizedBox(
                          width: 5,
                        ),

                          Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: IconButton(
                                padding:  EdgeInsets.all(4.0),
                                icon:  Icon(
                                  Icons.video_call,
                                  color: Colors.white,
                                ),
                                onPressed: () async {}),
                          ),

                        PopupMenuButton<String>(
                          color: Colors.white,
                            onSelected: optionAction,
                            iconSize: 28,
                            itemBuilder: (BuildContext context) {
                              return menuList.map((String option) {
                                return PopupMenuItem(value: option, child: Text(option));
                              }).toList();
                            }),

                      ],
                    ),
                  ),
                ),

                 SizedBox(
                  height: 10,
                )
              ],
            ),
          // GestureDetector(
          //     behavior: HitTestBehavior.opaque,
          //     onTap: ()  {
          //     },
          //     child: SizedBox(
          //       height: size.height,
          //       width: size.width,
          //       child: Align(
          //         alignment: Alignment(6.0, -0.6),
          //         child: SizedBox(
          //           height: 20.0,
          //           child: Container(
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(16),
          //               color: Colors.black,
          //             ),
          //             width: size.width * 0.7,
          //             padding: EdgeInsets.only(
          //                 bottom: 12,
          //                 top: 12,
          //                 left: 12,
          //                 right: size.width * 0.08),
          //             child: Row(
          //               mainAxisAlignment:
          //               MainAxisAlignment.start,
          //               crossAxisAlignment:
          //               CrossAxisAlignment.center,
          //               children: [
          //                 Stack(
          //                   children: [
          //                     CircleAvatar(
          //                         backgroundColor:
          //                         Colors.white,
          //                         radius: 22,
          //                         child: Center(
          //                           child: CircleAvatar(
          //                             radius: 20,
          //                             foregroundImage:
          //                             AssetImage(
          //                               "assets/images/avatar_img1.png",
          //                             ),
          //                           ),
          //                         )),
          //                     Positioned(
          //                         bottom: 0,
          //                         right: 0,
          //                         child: Container(
          //                           decoration: BoxDecoration(
          //                               color: true
          //                                   ? Colors.green
          //                                   : Colors.grey,
          //                               shape: BoxShape
          //                                   .circle),
          //                           width: 12,
          //                           height: 12,
          //                         ))
          //                   ],
          //                 ),
          //                 SizedBox(
          //                   width: 10,
          //                 ),
          //                 Text(
          //                   "e.name",
          //                   style:  TextStyle(
          //                       color: Colors.white,
          //                       fontSize: 14,
          //                       fontWeight:
          //                       FontWeight.bold),
          //                 ),
          //               ],
          //             ),
          //             // SingleChildScrollView(
          //             //   physics:  BouncingScrollPhysics(),
          //             //   child: Column(
          //             //     mainAxisAlignment:
          //             //     MainAxisAlignment.start,
          //             //     crossAxisAlignment:
          //             //     CrossAxisAlignment.start,
          //             //     children: chatRoomModel.participants
          //             //         .map((e) => Row(
          //             //       mainAxisAlignment:
          //             //       MainAxisAlignment.start,
          //             //       crossAxisAlignment:
          //             //       CrossAxisAlignment.center,
          //             //       children: [
          //             //         Stack(
          //             //           children: [
          //             //             CircleAvatar(
          //             //                 backgroundColor:
          //             //                 Colors.white,
          //             //                 radius: 22,
          //             //                 child: Center(
          //             //                   child:
          //             //                   CircleAvatar(
          //             //                     radius: 20,
          //             //                     foregroundImage:
          //             //                     NetworkImage(
          //             //                       e.avatarUrl,
          //             //                     ),
          //             //                   ),
          //             //                 )),
          //             //             Positioned(
          //             //                 bottom: 0,
          //             //                 right: 0,
          //             //                 child: Container(
          //             //                   decoration: BoxDecoration(
          //             //                       color: e.isOnline
          //             //                           ? Colors
          //             //                           .green
          //             //                           : Colors
          //             //                           .grey,
          //             //                       shape: BoxShape
          //             //                           .circle),
          //             //                   width: 12,
          //             //                   height: 12,
          //             //                 ))
          //             //           ],
          //             //         ),
          //             //          SizedBox(
          //             //           width: 10,
          //             //         ),
          //             //         Text(
          //             //           "e.name",
          //             //           style:  TextStyle(
          //             //               color: Colors.white,
          //             //               fontSize: 14,
          //             //               fontWeight:
          //             //               FontWeight.bold),
          //             //         ),
          //             //       ],
          //             //     ))
          //             //         .toList(),
          //             //   ),
          //             // ),
          //           ),
          //         ),
          //       ),
          //     ))

        ],
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: heightOfText,
              builder: (context, double value, child) =>
                  AnimatedContainer(
                    duration:  Duration(milliseconds: 500),
                    width: displayWidth(context) * 0.86,
                    margin:  EdgeInsets.symmetric(vertical: 8),
                    height: value,
                    curve: Curves.easeIn,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: SvgPicture.asset('assets/icons/attach.svg'),
                          onPressed: ()  {},
                        ),
                        Expanded(
                          child: TextField(
                              key: key,
                              //controller: _sendtextController,
                              scrollPhysics:  BouncingScrollPhysics(),
                              decoration:  InputDecoration(
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                hintText: "Type Something...",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              style:  TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              minLines: null,
                              maxLines: null,
                              expands: true,
                              onChanged: (String e) {
                              }),
                        ),

                        InkWell(
                          onTapDown: (details) {

                          },
                          onTapCancel: () {

                          },
                          onTap: () {

                          },
                          child: SizedBox(
                            height: 36,
                            width: 36,
                            child: SvgPicture.asset(
                              'assets/icons/microphone.svg',
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),

                        IconButton(
                          icon:  Icon(
                            Icons.send,
                            color: kPrimaryColor,
                          ),
                          onPressed: ()  {

                          },
                        ),
                      ],
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void showInviteMenu(BuildContext context, Size size) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(40),
          height: size.height * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Participant\'s\nUsername',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(
                flex: 2,
              ),
              TextField(
                style: const TextStyle(fontSize: 16, color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(fontSize: 16, color: Colors.grey),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              SizedBox(
                width: size.width,
                child: Center(
                  child: TextButton(
                      onPressed: () {
                      //
                      //   if (_inviteUserController.text.isNotEmpty) {
                      //     accountSettingsRef!
                      //         .orderByChild(userName)
                      //         .equalTo(_inviteUserController.text)
                      //         .once()
                      //         .then((snapshot) {
                      //       if (snapshot.value == null) {
                      //         print('User does\'nt exist');
                      //       } else {
                      //         usersRef!
                      //             .orderByKey()
                      //             .equalTo(snapshot.value['uid'])
                      //             .once()
                      //             .then((snapshot4) async {
                      //           final dynamicShortLink =
                      //           await DynamicLinkHelper.createMeetingLink(
                      //             id: scheduledMeeting!.id,
                      //             desc:
                      //             'Meeting between ${scheduledMeeting!.consultantName} and ${auth!.currentUser!.displayName}',
                      //             title: 'Join the Scheduled Meeting',
                      //           );
                      //           sendInviteToUser(snapshot4.value[userEmail],
                      //               dynamicShortLink);
                      //           print(snapshot4.value[userEmail]);
                      //         });
                      //       }
                      //     });
                      //   }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.green),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                            horizontal: size.width * 0.3, vertical: 20)),
                      ),
                      child: const Text(
                        'Invite',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      backgroundColor: Colors.white,
    );
  }


  displaySnackbar(String message, BuildContext context) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
