// ignore_for_file: prefer_const_constructors, avoid_print, annotate_overrides, overridden_fields, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/helpers/constants.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/models/chat_room_message.dart';
import 'package:tranquil_life/models/schedule_meeting.dart';
import 'package:tranquil_life/pages/chat/audio_call_screen.dart';
import 'package:tranquil_life/pages/chat/widgets/custom_dialog.dart';
import 'package:tranquil_life/pages/chat/widgets/rate_dialog_box.dart';
import 'package:tranquil_life/pages/chat/widgets/text_widget.dart';
import 'package:tranquil_life/pages/profile/widgets/image_picker_android.dart';
import 'package:tranquil_life/pages/profile/widgets/image_picker_ios.dart';
import 'package:tranquil_life/widgets/valueListenableBuilder2.dart';

import 'health_report_screen.dart';

class ChatScreenPage extends StatefulWidget {




  ChatScreenPage({Key? key}) : super(key: key);

  @override
  State<ChatScreenPage> createState() => _ChatScreenPageState();
}

class _ChatScreenPageState extends State<ChatScreenPage>  with SingleTickerProviderStateMixin {
  final key1 = GlobalKey();

  Size size = MediaQuery.of(Get.context!).size;

  bool _mRecorderIsInited = false;

  bool dataloaded = false;

  ScheduledMeeting? scheduledMeeting;

  final TextEditingController _sendtextController = TextEditingController();

  final TextEditingController _inviteUserController = TextEditingController();

  List<String> menuList = [
    'Invite',
    'Participants',
    'Health Profile',
    'End Session'
  ];


  @override
  void initState() {
    super.initState();

    initiateRecorder();
    animController = AnimationController(
        duration: Duration(milliseconds: 500), vsync: this);
    participantsAnim = ValueNotifier(
        Tween<double>(begin: 6.0, end: 1.5).animate(animController));
  }

  final ValueNotifier<double> heightOfText = ValueNotifier<double>(45.00);

  bool imagePickSel = false;

  bool chatRoomLoaded = false;

  String photoUrl = '';

  // File photo;
  String imgUrl = '';

  ValueNotifier<bool> participants = ValueNotifier(false);

  late AnimationController animController;

  late ValueListenable<Animation<double>> participantsAnim;

  String errText = 'No OnGoing Sessions';

  bool mic = true;

  //menu icon options
  optionAction(String option) {
    print(option);
    if (option == 'Invite') {
      // showInviteMenu(BuildContext, size);
    } else {
      // PushNotificationHelperController.instance
      //     .updateTokenAfterSigningOut(auth!.currentUser!.uid);
      // auth!.signOut();
      // Navigator.pushNamedAndRemoveUntil(
      //     Get.context!, Routes.SIGN_IN, (route) => false);
    }
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

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
    return ResponsiveSafeArea(
      responsiveBuilder: (context, size) => Scaffold(
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
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                child: true
                    //data-loaded
                    ? Text(
                        errText,
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
                    : CircularProgressIndicator(),
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
                    padding: EdgeInsets.only(left: 8),
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        Stack(
                          children: [
                            CircleAvatar(
                                backgroundColor: Color(0xffC9D8CD),
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
                                  decoration: BoxDecoration(
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
                                'Dr Charles ',
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
                              "25 mins",
                              style: TextStyle(
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
                            padding: EdgeInsets.all(4.0),
                            icon: Icon(
                              Icons.call,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AudioCallScreen(),
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
                              padding: EdgeInsets.all(4.0),
                              icon: Icon(
                                Icons.video_call,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                showLoaderDialog(context);
                                // await for camera and mic permissions before pushing video page
                                // await _handleCameraAndMic(Permission.camera);
                                // await _handleCameraAndMic(
                                //     Permission.microphone);
                              }),
                        ),
                        PopupMenuButton(
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 26,
                          ),
                          onSelected: (value) async {
                            if (true) {
                              switch (value) {
                                case 0:
                                  print('invite');

                                  showInviteMenu(context, size);
                                  break;
                                case 1:
                                  print('participant');

                                  participants.value = true;
                                  await Future.delayed(
                                      Duration(milliseconds: 200));
                                  animController.forward();
                                  break;
                                case 2:
                                  print('health');
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => HealthReportScreen(),
                                  ));
                                  break;
                                case 3:
                                  await showDialog(
                                    context: context,
                                    builder: (context) => CustomDialogBox(
                                      consultantName: "Dr Charles",
                                      //scheduledMeeting!.consultantName,
                                      onpressed: () async {
                                        print('YES');
                                        await showDialog(
                                          context: context,
                                          builder: (context) =>
                                              CustomRatingDialogBox(
                                            consultantEmail:
                                                "charlesthedoctor@gmail.com",
                                            //consultantDoc.value[userEmail],
                                            consultantID: "2238",
                                            consultantName: 'Dr Charles',
                                            //scheduledMeeting!.consultantName,
                                            creatorUsername: 'Larry Badge',
                                            //accountDoc.value[userName],
                                            currentMeetingID: '2227',
                                            // widget.scheduledMeetingID
                                          ),
                                        );
                                        print('rated');
                                      },
                                    ),
                                  );
                                  print('end');
                                  break;
                              }
                            } else {
                              //   switch (value) {
                              //     case 0:
                              //       print('participant');
                              //
                              //       participants.value = true;
                              //       await Future.delayed(
                              //            Duration(milliseconds: 200));
                              //       animController.forward();
                              //       break;
                              //     case 1:
                              //       print('health');
                              //       Navigator.of(context)
                              //           .push(MaterialPageRoute(
                              //         builder: (context) =>
                              //             HealthReportScreen(
                              //               clientID: scheduledMeeting!
                              //                   .creatorID,
                              //             ),
                              //       ));
                              //       break;
                              //   }
                            }
                          },
                          itemBuilder: (context) => menuList
                              .map(
                                (e) => PopupMenuItem(
                                  value: menuList.indexOf(e),
                                  height: 40,
                                  child: Text(e),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        TextWidgetInChat(
                          message: "Hi, tell me about the challenge you are facing",
                          avatarUrl: "assets/images/avatar_img1.png",
                        ),
                        TextWidgetInChat(
                          message: "I have been having issues with my marriage",
                          avatarUrl: "assets/images/avatar_img2.png",
                        ),
                      ],
                    ),
                    // child: false
                    //     //chatRoomLoaded
                    //     ? Container()
                    //     // StreamBuilder(
                    //     //   stream: chatRoomMessagesRef
                    //     //       .orderBy('timestamp', descending: true)
                    //     //       .snapshots(),
                    //     //   builder: (context, snapshot) {
                    //     //     if (snapshot.hasData) {
                    //     //       return ListView.builder(
                    //     //         reverse: true,
                    //     //         padding:  EdgeInsets.symmetric(
                    //     //             horizontal: 12, vertical: 8),
                    //     //         itemCount: (snapshot.data as QuerySnapshot)
                    //     //             .docs
                    //     //             .length,
                    //     //         itemBuilder: (context, index) =>
                    //     //             _buildChatMessageWidget(index,
                    //     //                 snapshot:
                    //     //                 (snapshot.data as QuerySnapshot)
                    //     //                     .docs[index]),
                    //     //       );
                    //     //     } else {
                    //     //       return  Center(
                    //     //         child: CircularProgressIndicator(),
                    //     //       );
                    //     //     }
                    //     //   },
                    //     // )
                    //     : Center(
                    //         child: CircularProgressIndicator(),
                    //       ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ValueListenableBuilder(
                  valueListenable: heightOfText,
                  builder: (context, double value, child) => AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width: size.width * 0.86,
                    margin: EdgeInsets.symmetric(vertical: 8),
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
                          onPressed: () async {
                            var status = await Permission.storage.isGranted;
                            if (!status) {
                              await Permission.storage.request();
                              status = await Permission.storage.isGranted;
                            }
                            print(status);
                            if (status) {
                              var result = await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (context) => Platform.isIOS
                                    ? ImagePickerPageIOS()
                                    : ImagePickerAndroid(),
                              ));
                              if (result != null && result.isNotEmpty) {
                                print(result);
                                //notSendingCurrently = false;
                                print('setting state edit photo onTapped');
                                if (Platform.isAndroid) {
                                  photoUrl = result;
                                } else {
                                  photoUrl = result;
                                  imgUrl = photoUrl.toString();
                                }


                                ChatroomMessage message = ChatroomMessage(
                                  id: "m1",
                                  chatroomID: "",
                                  senderID: "Mr J",
                                  //auth!.currentUser!.uid,
                                  isRead: false,
                                  timestamp: DateTime.now(),
                                  message: photoUrl,
                                  quote: '',
                                  type: 'image',
                                );


                                // _listKey.currentState.insertItem(0,
                                //     duration: Duration(seconds: 1));
                                //
                                // //inserting the msg into the messages list too at 0 index
                                // chatRoomMessages.insert(0, message);

                                String userName;


                              }
                            }
                          },
                        ),
                        Expanded(
                          child: TextField(
                              key: key1,
                              controller: _sendtextController,
                              scrollPhysics: BouncingScrollPhysics(),
                              decoration: InputDecoration(
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
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              minLines: null,
                              maxLines: null,
                              expands: true,
                              onChanged: (String e) {
                                if (_sendtextController.text.isEmpty) {
                                  setState(() {
                                    mic = true;
                                  });
                                } else if (_sendtextController.text.length ==
                                    1) {
                                  setState(() {
                                    mic = false;
                                  });
                                }
                                changeTextFieldSize(e);
                              }),
                        ),
                        if (mic)
                          InkWell(
                            onTapDown: (details) {
                              startRecording();
                            },
                            onTapCancel: () {
                              stopRecording();
                            },
                            onTap: () {
                              stopRecording();
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
                        if (!mic)
                          IconButton(
                            icon: Icon(
                              Icons.send,
                              color: kPrimaryColor,
                            ),
                            onPressed: () async {},
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showInviteMenu(BuildContext context, Size size) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(40),
          height: size.height * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Participant\'s\nUsername',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              Spacer(
                flex: 2,
              ),
              TextField(
                style: TextStyle(fontSize: 16, color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(fontSize: 16, color: Colors.grey),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              Spacer(
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
                      child: Text(
                        'Invite',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      backgroundColor: Colors.white,
    );
  }

  double getWidth() {
    return  key1.currentState!.context.size!.width;
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

  void changeTextFieldSize(String e) {
    textFieldWidth ??= getWidth();

    double cal = e.length * textSize.width;
    int numlines = (cal / textFieldWidth!).ceil();
    if (numlines != heightOfText.value / 40 && numlines > 1) {
      double cal = 40 + (numlines * 8).toDouble();
      if (cal > 90) {
        heightOfText.value = 90;
      } else {
        heightOfText.value = cal == 50.00 ? 40.00 : cal;
      }
    } else if (numlines == 1) {
      heightOfText.value = 40.00;
    }
  }

  //final FlutterSoundRecorder _mySoundRecorder = FlutterSoundRecorder();

  String? _audioRecordPath;

  bool hasRecordingPermission = false;

  Future initiateRecorder() async {
    hasRecordingPermission = await Permission.microphone.isGranted;
    if (!hasRecordingPermission) {
      var status = await Permission.microphone.request();
      hasRecordingPermission = status == PermissionStatus.granted ||
          status == PermissionStatus.limited;
    }
    if (hasRecordingPermission) {
      // _mySoundRecorder.openRecorder().then((value) {
      //   setState(() {
      //     _mRecorderIsInited = true;
      //   });
      // });
    } else {
      displaySnackbar('Permission to microphone is denied', context);
    }
  }

  Timer? timer;

  int secondsOfAudioRecorded = 0;

  void startRecording() async {
    if (_mRecorderIsInited) {
      if (hasRecordingPermission) {
        Directory directory = await getApplicationDocumentsDirectory();
        String filepath = directory.path +
            '/' +
            DateTime.now().millisecondsSinceEpoch.toString() +
            '.aac';
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          secondsOfAudioRecorded++;
        });
        // await _mySoundRecorder.startRecorder(
        //   toFile: filepath,
        //   codec: Codec.aacADTS,
        // );
        displaySnackbar('Started Recording', context);
        _audioRecordPath = filepath;
      } else {
        displaySnackbar('Permission Denied', context);
      }
    } else {
      displaySnackbar('Try again in few moments', context);
    }
  }

  void stopRecording() async {
    if (_mRecorderIsInited && hasRecordingPermission) {
      displaySnackbar('Stopped Recording', context);

      //await _mySoundRecorder.stopRecorder();
      timer?.cancel();

    }
  }
}

