// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/helpers/constants.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';
import 'package:tranquil_life/models/chat_room.dart';
import 'package:tranquil_life/models/schedule_meeting.dart';
import 'package:tranquil_life/pages/chat/health_report_screen.dart';
import 'package:tranquil_life/pages/chat/widgets/custom_dialog.dart';
import 'package:tranquil_life/widgets/custom_snackbar.dart';
import 'package:tranquil_life/widgets/valueListenableBuilder2.dart';

import 'audio_call_screen.dart';

class ChatScreenPage extends StatefulWidget {
  static const String idScreen = 'chatScreen';
  final String scheduledMeetingID;
  final ScheduledMeeting? meeting;
  final bool isNewParticipant;
  final bool showingHistory;
  final Chatroom? chatroom;
  final String consultantUid;
  final String clientUid;

  const ChatScreenPage({Key? key,
    this.chatroom,
    required this.consultantUid,
    required this.clientUid,
    this.showingHistory = false,
    this.scheduledMeetingID = '',
    this.meeting,
    this.isNewParticipant = false})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreenPage>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<double> heightOfText = ValueNotifier<double>(45.00);
  final key = GlobalKey();
  bool imagePickSel = false;
  bool chatRoomLoaded = false;
  String photoUrl = '';

  // File photo;
  String imgUrl = '';
  ValueNotifier<bool> participants = ValueNotifier(false);
  bool anyMeetingAvailable = false;
  late AnimationController animController;
  late ValueListenable<Animation<double>> participantsAnim;

  // final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  ///Chatroom and chatroom messsages DB references
  // DatabaseReference chatsRef = firebaseDatabase.reference().child('chats');
  // var chatModel;
  late Chatroom chatRoomModel;

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

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
  String errText = 'No OnGoing Sessions';
  bool mic = true;


  @override
  void initState() {
    super.initState();

    animController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    participantsAnim = ValueNotifier(
        Tween<double>(begin: 6.0, end: 1.5).animate(animController));
  }



  Future getChatRoom(ScheduledMeeting scheduledMeeting) async {
    if (widget.chatroom == null) {
      List<String> participantsList = [
        scheduledMeeting.creatorID,
        scheduledMeeting.consultantID
      ];

      ///check if chatroom exists

      // //called the getUserAccountDoc() function before setState only then it works,
      // await getUserAccountDoc();

      setState(() {
        chatRoomLoaded = true;
      });
    }

    bool messagesLoaded = false;
    bool notSendingCurrently = true;

    GetStorage getStorage = GetStorage();

    late String type =
    getStorage.read(userType) == 'client' ? 'creatorID' : 'consultantID';
    late String nameString =
    getStorage.read(userType) == 'client' ? 'consultantID' : 'creatorID';

    int _isMeetingRunning(ScheduledMeeting _model) {
      List<String> splittedIntoMinutesAndSeconds = _model.duration.split(':');
      int minutesOfMeetingDuration = int.parse(
          splittedIntoMinutesAndSeconds[0]);
      int secondsOfMeetingDuration = int.parse(
          splittedIntoMinutesAndSeconds[1]);
      int now = DateTime
          .now()
          .millisecondsSinceEpoch;
      print(now);
      int startOfMeetingTime = _model.startingTime.millisecondsSinceEpoch;
      int endingOfMeetingsTime = _model.startingTime
          .add(Duration(
          minutes: minutesOfMeetingDuration,
          seconds: secondsOfMeetingDuration))
          .millisecondsSinceEpoch;
      print(endingOfMeetingsTime);
      // 1 + -1 = currently in meeting  -1 + -1 = not yet started 1 + 1 = ended
      // 0 + -1 = meeting is at the start time  -1 + 0 = meeting is at end time
      int compare =
          now.compareTo(startOfMeetingTime) +
              now.compareTo(endingOfMeetingsTime);
      switch (compare) {
        case 0:
          return 0;
        case -2:
          return -1;
        case 2:
          return 1;
        default:
          return 0;
      }
    }

    //set invite to user

    @override
    void dispose() {
      animController.stop();
      animController.dispose();
      super.dispose();
    }

    void showInviteMenu(BuildContext context, Size size) {
      showModalBottomSheet<void>(
        context: context,
        builder: (context) =>
            SingleChildScrollView(
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
                      controller: _inviteUserController,
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

                            },
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              padding: MaterialStateProperty.all(EdgeInsets
                                  .symmetric(
                                  horizontal: size.width * 0.3, vertical: 20)),
                            ),
                            child: const Text(
                              'Invite',
                              style: TextStyle(color: Colors.white,
                                  fontSize: 18),
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


    String? downloadUrl;

    double? textFieldWidth;
    late Size textSize;

    @override
    Widget build(BuildContext context) {
      textSize = _textSize(
        'c',
        const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      );
      final size = MediaQuery
          .of(context)
          .size;
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
            if (!anyMeetingAvailable)
              Center(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  child: dataloaded
                      ? Text(
                    errText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                        decoration: TextDecoration.none,
                        fontFamily: Theme
                            .of(context)
                            .textTheme
                            .bodyText1!
                            .fontFamily),
                  )
                      : const CircularProgressIndicator(),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            if (anyMeetingAvailable) ...[
              Container(
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black12,
                          const Color(0xff001A07).withOpacity(0.75),
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
                      padding: const EdgeInsets.only(left: 8),
                      width: size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              icon: const Icon(
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
                                      foregroundImage: NetworkImage('',
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
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Hero(
                                tag: 'title',
                                child: Text(
                                  'Consultant Firstname & Lastname',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none,
                                      fontFamily: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyText1!
                                          .fontFamily),
                                ),
                              ),
                              if (!widget.showingHistory)
                                Text(
                                  scheduledMeeting.duration,
                                  style: const TextStyle(
                                      color: kSecondaryColor, fontSize: 16),
                                )
                            ],
                          ),
                          const Spacer(),
                          if (!widget.showingHistory)
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: IconButton(
                                padding: const EdgeInsets.all(4.0),
                                icon: const Icon(
                                  Icons.call,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const AudioCallScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          const SizedBox(
                            width: 5,
                          ),
                          if (!widget.showingHistory)
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: IconButton(
                                  padding: const EdgeInsets.all(4.0),
                                  icon: const Icon(
                                    Icons.video_call,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {}),
                            ),
                          if (!widget.showingHistory)
                            PopupMenuButton(
                              child: const Icon(
                                Icons.arrow_right_sharp,
                                color: Colors.white,
                                size: 26,
                              ),
                              onSelected: (value) async {},
                              itemBuilder: (context) =>
                                  menuList
                                      .map(
                                        (e) =>
                                        PopupMenuItem(
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
                  const SizedBox(
                    height: 10,
                  ),
                  if (!widget.showingHistory)
                    ValueListenableBuilder(
                      valueListenable: heightOfText,
                      builder: (context, double value, child) =>
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            width: displayWidth(context) * 0.86,
                            margin: const EdgeInsets.symmetric(vertical: 8),
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
                                  icon: SvgPicture.asset(
                                      'assets/icons/attach.svg'),
                                  onPressed: () async {},
                                ),
                                Expanded(
                                  child: TextField(
                                      key: key,
                                      controller: _sendtextController,
                                      scrollPhysics: const BouncingScrollPhysics(),
                                      decoration: const InputDecoration(
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
                                      style: const TextStyle(
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
                                        } else
                                        if (_sendtextController.text.length ==
                                            1) {
                                          setState(() {
                                            mic = false;
                                          });
                                        }
                                      }),
                                ),
                                if (mic)
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
                                if (!mic)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.send,
                                      color: kPrimaryColor,
                                    ),
                                    onPressed: () async {},
                                  ),
                              ],
                            ),
                          ),
                    ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
              ValueListenableBuilder2(
                participants,
                participantsAnim.value,
                builder: (context, bool value, double animValue, child) =>
                value
                    ? GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      animController.reverse();
                      await Future.delayed(const Duration(milliseconds: 500));
                      participants.value = false;
                    },
                    child: SizedBox(
                      height: size.height,
                      width: size.width,
                      child: Align(
                        alignment: Alignment(animValue, -0.6),
                        child: SizedBox(
                          height: chatRoomModel.participants.length > 3
                              ? 250.toDouble()
                              : (75 * chatRoomModel.participants.length)
                              .toDouble(),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.black,
                            ),
                            width: size.width * 0.7,
                            padding: EdgeInsets.only(
                                bottom: 12,
                                top: 12,
                                left: 12,
                                right: size.width * 0.08),
                            child: chatRoomModel.participants.length < 4
                                ? Column(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: chatRoomModel.participants
                                  .map(
                                    (e) =>
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            CircleAvatar(
                                                backgroundColor:
                                                Colors.white,
                                                radius: 22,
                                                child: Center(
                                                  child: CircleAvatar(
                                                    radius: 20,
                                                    foregroundImage:
                                                    NetworkImage(
                                                      e.avatarUrl,
                                                    ),
                                                  ),
                                                )),
                                            Positioned(
                                                bottom: 0,
                                                right: 0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: e.isOnline
                                                          ? Colors.green
                                                          : Colors.grey,
                                                      shape: BoxShape
                                                          .circle),
                                                  width: 12,
                                                  height: 12,
                                                ))
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          e.name,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                      ],
                                    ),
                              )
                                  .toList(),
                            )
                                : SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: chatRoomModel.participants
                                    .map((e) =>
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            CircleAvatar(
                                                backgroundColor:
                                                Colors.white,
                                                radius: 22,
                                                child: Center(
                                                  child:
                                                  CircleAvatar(
                                                    radius: 20,
                                                    foregroundImage:
                                                    NetworkImage(
                                                      e.avatarUrl,
                                                    ),
                                                  ),
                                                )),
                                            Positioned(
                                                bottom: 0,
                                                right: 0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: e.isOnline
                                                          ? Colors
                                                          .green
                                                          : Colors
                                                          .grey,
                                                      shape: BoxShape
                                                          .circle),
                                                  width: 12,
                                                  height: 12,
                                                ))
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          e.name,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                      ],
                                    ))
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ))
                    : Container(),
              ),
            ],
          ],
        ),
      );
    }

    double getWidth() {
      return key.currentState!.context.size!.width;
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

    // Future getImage() async {
    //   final pickedFile = await picker.getImage(source: ImageSource.camera);

    //   setState(() {
    //     if (pickedFile != null) {
    //       _image = File(pickedFile.path);
    //     } else {
    //       print('No image selected.');
    //     }
    //   });
    // }
    final FlutterSoundRecorder _mySoundRecorder = FlutterSoundRecorder();
    String? _audioRecordPath;
    bool hasRecordingPermission = false;
    Future initiateRecorder() async {}

    Timer? timer;
    int secondsOfAudioRecorded = 0;


    void stopRecording() async {
      if (_mRecorderIsInited && hasRecordingPermission) {
        displaySnackbar('Stopped Recording', context);

        await _mySoundRecorder.stopRecorder();
        timer?.cancel();

      }
    }


// Future<void> _handleCameraAndMic(Permission permission) async {
//   final status = await permission.request();
//   print(status);
// }
  }



  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}