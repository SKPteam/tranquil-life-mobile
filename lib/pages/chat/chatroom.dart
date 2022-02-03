

// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/helpers/constants.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';
import 'package:tranquil_life/pages/chat/audio_call_screen.dart';
import 'package:tranquil_life/pages/chat/health_report_screen.dart';
import 'package:tranquil_life/pages/chat/widgets/custom_dialog.dart';
import 'package:tranquil_life/pages/chat/widgets/enums.dart';
import 'package:tranquil_life/pages/chat/widgets/text_widget.dart';
import 'package:tranquil_life/pages/chat/widgets/voice_message.dart';

class ChatScreenPage extends StatefulWidget {
  static const String idScreen = 'chatScreen';
  final String scheduledMeetingID;
  // final ScheduledMeeting? meeting;
  final bool isNewParticipant;
  final bool showingHistory;
  //final Chatroom? chatroom;
  final String consultantUid;
  final String clientUid;
  const ChatScreenPage(
      {Key? key,
       // this.chatroom,
        required this.consultantUid,
        required this.clientUid,
        this.showingHistory = false,
        this.scheduledMeetingID = '',
        //this.meeting,
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
  //ScheduledMeeting? scheduledMeeting;
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

    initiateRecorder();
    animController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    participantsAnim = ValueNotifier(
        Tween<double>(begin: 6.0, end: 1.5).animate(animController));
  }

  @override
  Widget build(BuildContext context) {
    // textSize = _textSize(
    //   'c',
    //   const TextStyle(
    //     color: Colors.black,
    //     fontSize: 14,
    //     fontWeight: FontWeight.w600,
    //   ),
    // );
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
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              child: true
                  ? Text( "errText",
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
                  : const CircularProgressIndicator(),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

        ],
      ),
    );
  }







  }

  bool messagesLoaded = false;
  bool notSendingCurrently = true;

  GetStorage getStorage = GetStorage();

  late String type =
  getStorage.read(userType) == 'client' ? 'creatorID' : 'consultantID';
  late String nameString =
  getStorage.read(userType) == 'client' ? 'consultantID' : 'creatorID';








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




  String? downloadUrl;


  double? textFieldWidth;
  late Size textSize;


  // double getWidth() {
  //   return key.currentState!.context.size!.width;
  // }

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

  // void changeTextFieldSize(String e) {
  //   textFieldWidth ??= getWidth();
  //
  //   num cal = e.length * textSize.width;
  //   int numlines = (cal / textFieldWidth!).ceil();
  //   if (numlines != heightOfText.value / 40 && numlines > 1) {
  //     double cal = 40 + (numlines * 8).toDouble();
  //     if (cal > 90) {
  //       heightOfText.value = 90;
  //     } else {
  //       heightOfText.value = cal == 50.00 ? 40.00 : cal;
  //     }
  //   } else if (numlines == 1) {
  //     heightOfText.value = 40.00;
  //   }
  // }

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
  Future initiateRecorder() async {
    hasRecordingPermission = await Permission.microphone.isGranted;
    if (!hasRecordingPermission) {
      var status = await Permission.microphone.request();
      hasRecordingPermission = status == PermissionStatus.granted ||
          status == PermissionStatus.limited;
    }

  }

  Timer? timer;
  int secondsOfAudioRecorded = 0;
  void startRecording() async {

  }





// Future<void> _handleCameraAndMic(Permission permission) async {
//   final status = await permission.request();
//   print(status);
// }
