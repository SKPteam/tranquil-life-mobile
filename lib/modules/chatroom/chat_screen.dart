// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tranquil_app/app/helperControllers/dynamic_link_helper.dart';
import 'package:tranquil_app/app/helperControllers/firebase_push_notifications.dart';
import 'package:tranquil_app/app/models/chatroom.dart';
import 'package:tranquil_app/app/models/chatroom_message.dart';
import 'package:tranquil_app/app/models/scheduled_meeting.dart';
import 'package:tranquil_app/app/modules/chatroom/videochat.dart';
import 'package:tranquil_app/app/modules/profile/components/imagePickerAndroid.dart';
import 'package:tranquil_app/app/modules/profile/components/imagePickerIos.dart';
import 'package:tranquil_app/app/utils/constants.dart';
import 'package:tranquil_app/app/utils/sizes_helpers.dart';
import 'package:tranquil_app/app/utils/snackbar.dart';
import 'package:tranquil_app/app/utils/valueListenableBuilder2.dart';
import '../../../main.dart';
import 'package:flutter_sound/flutter_sound.dart';

import 'audio_call_screen.dart';
import 'components/custom_dialog.dart';
import 'components/rate_dialog_box.dart';
import 'components/enums.dart';
import 'components/photo_in_chat.dart';
import 'components/text_widget.dart';
import 'components/voice_message.dart';
import 'health_report_screen.dart';

class ChatScreenPage extends StatefulWidget {
  static const String idScreen = 'chatScreen';
  final String scheduledMeetingID;
  final ScheduledMeeting? meeting;
  final bool isNewParticipant;
  final bool showingHistory;
  final Chatroom? chatroom;
  final String consultantUid;
  final String clientUid;
  const ChatScreenPage(
      {Key? key,
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
  CollectionReference chatRoomRef =
      FirebaseFirestore.instance.collection('chatRooms');
  CollectionReference agoraTokenRef =
      FirebaseFirestore.instance.collection('agoraTokens');
  late CollectionReference chatRoomMessagesRef;
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
  late DataSnapshot accountDoc;
  late DataSnapshot consultantDoc;

  @override
  void initState() {
    super.initState();

    initiateRecorder();
    animController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    participantsAnim = ValueNotifier(
        Tween<double>(begin: 6.0, end: 1.5).animate(animController));
    getCurrentRunningScheduledMeeting();
  }

  getUserAccountDoc() async {
    accountDoc = await accountSettingsRef!.child(auth!.currentUser!.uid).once();
    consultantDoc =
        await accountSettingsRef!.child(widget.consultantUid).once();
    print('account details ${consultantDoc.value}');
  }

  Future getChatRoom(ScheduledMeeting scheduledMeeting) async {
    if (widget.chatroom == null) {
      List<String> participantsList = [
        scheduledMeeting.creatorID,
        scheduledMeeting.consultantID
      ];

      ///check if chatroom exists
      await chatRoomRef
          .where('creatorID', isEqualTo: scheduledMeeting.creatorID)
          .where('consultantID', isEqualTo: scheduledMeeting.consultantID)
          .limit(1)
          .get()
          .then((snapshot) async {
        if (snapshot.docs.isNotEmpty) {
          print('ChatRoom Exists');
          final element = snapshot.docs[0];
          participantsList.clear();
          if (widget.isNewParticipant) {
            chatRoomRef.doc(snapshot.docs[0].id).update({
              "participants": FieldValue.arrayUnion([auth!.currentUser!.uid])
            });
            participantsList.add(auth!.currentUser!.uid);
          }
          participantsList.addAll(
              (element.data() as Map<String, dynamic>)['participants']
                  .toList()
                  .cast<String>());
          List<Participants> tempParticipant = [];
          for (var j = 0; j < participantsList.length; j++) {
            await accountSettingsRef!
                .child(participantsList[j])
                .once()
                .then((userAccountDetails) async {
              await usersRef!
                  .child((userAccountDetails.value[userType] ?? '') == 'client'
                      ? 'clients'
                      : 'consultants')
                  .child(participantsList[j])
                  .once()
                  .then((userRefValue) {
                tempParticipant.add(Participants(
                    participantsList[j],
                    userAccountDetails.value[userFirstName] +
                        ' ' +
                        userAccountDetails.value[userLastName],
                    userRefValue.value[FCMtokenGetStoreConstant].toString(),
                    userAccountDetails.value[userAvatarUrl]));
              });
            });
            final _chatroomData = element.data() as Map<String, dynamic>;
            chatRoomModel = Chatroom(
              id: _chatroomData['id'],
              creatorID: _chatroomData['creatorID'],
              consultantID: _chatroomData['consultantID'],
              timer: _chatroomData['timer'],
              participants: tempParticipant,
              timestamp: DateTime.fromMillisecondsSinceEpoch(
                      _chatroomData['timestamp'])
                  .toLocal(),
            );
          }
        } else {
          print('it does not exists');
          var subStr = uuid.v4();
          String id = subStr.substring(0, subStr.length - 10);
          if (widget.isNewParticipant) {
            participantsList.add(auth!.currentUser!.uid);
          }

          ///chatRoomModel creation
          chatRoomRef.doc(id).set({
            'id': id,
            'creatorID': scheduledMeeting.creatorID,
            'participants': participantsList,
            'consultantID': scheduledMeeting.consultantID,
            'timer': chatRoomModel.timer,
            'timestamp': chatRoomModel.timestamp.toUtc().millisecondsSinceEpoch,
          }).then((value) {
            displaySnackbar('chatroom created successfully', context);
          }).catchError((error) =>
              displaySnackbar('Error: ${error.toString()}', context));
        }
      });
    } else {
      chatRoomModel = widget.chatroom!;
    }
    if (chatRoomModel.creatorID != auth!.currentUser!.uid) {
      menuList = [
        'Participants',
        'Health Profile',
      ];
    }
    chatRoomMessagesRef = FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomModel.id)
        .collection('messages');
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
  Future getCurrentRunningScheduledMeeting() async {
    await getUserAccountDoc();
    if (!widget.showingHistory) {
      if (widget.scheduledMeetingID.isNotEmpty) {
        scheduledMeeting = widget.meeting;
        int status = _isMeetingRunning(scheduledMeeting!);
        if (status == 0) {
          anyMeetingAvailable = true;
          if (widget.isNewParticipant) {}
          getChatRoom(scheduledMeeting!);
        } else if (status == -1) {
          errText = 'Session isn\'t yet Started';
          if (widget.isNewParticipant) {
            displaySnackBar(
                'Meeting isn\'t started yet, Join using the link when meeting start',
                context);
          }
        } else if (status == 1) {
          await scheduledMeetingsRef!.doc(scheduledMeeting!.id).delete();
        }
      } else {
        bool firstExtraction = true;
        late QueryDocumentSnapshot lastSnapshot;
        while (true) {
          QuerySnapshot scheduledMeetingDoc;
          if (firstExtraction) {
            scheduledMeetingDoc = await scheduledMeetingsRef!
                .where(type, isEqualTo: auth!.currentUser!.uid)
                .orderBy('startingTime')
                .limit(10)
                .get();
            firstExtraction = false;
          } else {
            scheduledMeetingDoc = await scheduledMeetingsRef!
                .where(type, isEqualTo: auth!.currentUser!.uid)
                .orderBy('startingTime')
                .limit(10)
                .startAfterDocument(lastSnapshot)
                .get();
          }
          print(scheduledMeetingDoc.docs);
          if (scheduledMeetingDoc.docs.isNotEmpty) {
            lastSnapshot = scheduledMeetingDoc.docs.last;
            for (var i = 0; i < scheduledMeetingDoc.docs.length; i++) {
              var doc = scheduledMeetingDoc.docs[i];
              print(doc.data());
              var docData = doc.data() as Map<String, dynamic>;
              // get the userData from the uid of the scheduledMeeting!
              var consultantAccountDoc =
                  await accountSettingsRef!.child(docData[nameString]).once();
              //add the data into Scheduled meeting Model and then add it to the scheduled meetings List list
              scheduledMeeting = ScheduledMeeting(
                avatarUrl: consultantAccountDoc.value[userAvatarUrl],
                consultantID: docData['consultantID'],
                creatorID: docData['creatorID'],
                consultantName:
                    '${consultantAccountDoc.value[userFirstName]} ${consultantAccountDoc.value[userLastName]}',
                duration: docData['duration'],
                fee: docData['fee'].toInt(),
                id: docData['meetingID'],
                startingTime:
                    DateTime.fromMillisecondsSinceEpoch(docData['startingTime'])
                        .toLocal(),
                timestamp:
                    DateTime.fromMillisecondsSinceEpoch(docData['timestamp'])
                        .toLocal(),
              );

              int status = _isMeetingRunning(scheduledMeeting!);
              if (status == 0) {
                anyMeetingAvailable = true;
                getChatRoom(scheduledMeeting!);

                //displaySnackbar('${chatRoomModel.creatorID} consultantUid: ${scheduledMeeting!.consultantID}' , context);

                break;
              }
            }
            if (anyMeetingAvailable) {
              break;
            }
          } else {
            break;
          }
        }
      }
    } else {
      chatRoomModel = widget.chatroom!;
      anyMeetingAvailable = true;
      chatRoomMessagesRef = FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(chatRoomModel.id)
          .collection('messages');
      // await getUserAccountDoc();
      setState(() {
        chatRoomLoaded = true;
      });
    }
    setState(() {
      dataloaded = true;
    });
  }

  int _isMeetingRunning(ScheduledMeeting _model) {
    List<String> splittedIntoMinutesAndSeconds = _model.duration.split(':');
    int minutesOfMeetingDuration = int.parse(splittedIntoMinutesAndSeconds[0]);
    int secondsOfMeetingDuration = int.parse(splittedIntoMinutesAndSeconds[1]);
    int now = DateTime.now().millisecondsSinceEpoch;
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
        now.compareTo(startOfMeetingTime) + now.compareTo(endingOfMeetingsTime);
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
  void sendInviteToUser(String invitedUserEmail, String dynamicLink) {
    //TODO: ayomide passed the dynamic link in here
    String email = 'skiplab.innovation@gmail.com';
    String password = 'aaaaaa@123';

    //user for your own domain
    final smtpServer = gmail(email, password);

    final message = Message()
      ..from = Address(email, 'Tranquila')
      ..recipients.add(invitedUserEmail)
      //..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      //..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'You have a meeting 😀'
      ..html = '''''';
  }

  @override
  void dispose() {
    animController.stop();
    animController.dispose();
    _mySoundRecorder.closeAudioSession();
    super.dispose();
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
                        if (_inviteUserController.text.isNotEmpty) {
                          accountSettingsRef!
                              .orderByChild(userName)
                              .equalTo(_inviteUserController.text)
                              .once()
                              .then((snapshot) {
                            if (snapshot.value == null) {
                              print('User does\'nt exist');
                            } else {
                              usersRef!
                                  .orderByKey()
                                  .equalTo(snapshot.value['uid'])
                                  .once()
                                  .then((snapshot4) async {
                                final dynamicShortLink =
                                    await DynamicLinkHelper.createMeetingLink(
                                  id: scheduledMeeting!.id,
                                  desc:
                                      'Meeting between ${scheduledMeeting!.consultantName} and ${auth!.currentUser!.displayName}',
                                  title: 'Join the Scheduled Meeting',
                                );
                                sendInviteToUser(snapshot4.value[userEmail],
                                    dynamicShortLink);
                                print(snapshot4.value[userEmail]);
                              });
                            }
                          });
                        }
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

  Widget _buildChatMessageWidget(int index,
      {loader = false, QueryDocumentSnapshot? snapshot}) {
    late DateTime date;
    late String avatarUrl = '';
    late String message;
    late ChatFrom chatFrom;
    late String type;
    late int seconds;

    if (snapshot != null) {
      var data = snapshot.data() as Map<String, dynamic>;
      date = DateTime.fromMillisecondsSinceEpoch(data['timestamp'].toInt())
          .toLocal();
      print(
          'avatarURl: ------------------------------------------------------------\n $avatarUrl');
      message = data['message'];
      chatFrom = data['senderID'] == auth!.currentUser!.uid
          ? ChatFrom.self
          : ChatFrom.other;
      if (chatFrom == ChatFrom.other) {
        for (var i = 0; i < chatRoomModel.participants.length; i++) {
          print(chatRoomModel.participants[i].userID);
        }
        avatarUrl = chatRoomModel.participants
            .singleWhere((element) => element.userID == data['senderID'])
            .avatarUrl;
      }
      type = data['type'];
      if (type == 'audio') {
        seconds = data['secondsOfAudio'];
      }
    }
    if (loader) {
      return const SizedBox(
        height: 80,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    switch (ChatroomMessage.messagetypeFromText(type)) {
      case messagetype.text:
        return TextWidgetInChat(
          date: date,
          avatarUrl: avatarUrl,
          message: message,
          chatFrom: chatFrom,
        );

      case messagetype.audio:
        return VoiceWidgetInChat(
          time: Duration(seconds: seconds),
          avatarUrl: avatarUrl,
          url: message,
          chatFrom: chatFrom,
          date: date,
        );

      case messagetype.image:
        return PhotoWidgetInChat(
          url: message,
          avatarUrl: avatarUrl,
          chatFrom: chatFrom,
          date: date,
        );

      default:
        return TextWidgetInChat(
          date: date,
          avatarUrl: avatarUrl,
          message: message,
          chatFrom: chatFrom,
        );
    }
  }

  String? downloadUrl;
  Future<String> uploadFileToFirebase(String path, {bool audio = false}) async {
    File file = File(path);
    String fileName = file.path.split('/').last;
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('chats/${chatRoomModel.id}/$fileName');

    UploadTask uploadTask = ref.putFile(file);
    displaySnackbar('Uploading', context);
    await uploadTask.whenComplete(() async {
      downloadUrl = await ref.getDownloadURL();
      displaySnackbar('Done Uploaded', context);
    });
    print('DOWNLOAD_URL: $downloadUrl');

    return downloadUrl!;
  }

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
                                backgroundColor: const Color(0xffC9D8CD),
                                radius: 22,
                                child: Center(
                                  child: CircleAvatar(
                                    radius: 20,
                                    foregroundImage: NetworkImage(
                                      consultantDoc.value[userAvatarUrl] ?? '',
                                    ),
                                  ),
                                )),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
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
                                '${consultantDoc.value[userFirstName]} ${consultantDoc.value[userLastName]}',
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
                            if (!widget.showingHistory)
                              Text(
                                scheduledMeeting!.duration,
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
                                onPressed: () async {
                                  showLoaderDialog(context);
                                  // await for camera and mic permissions before pushing video page
                                  // await _handleCameraAndMic(Permission.camera);
                                  // await _handleCameraAndMic(
                                  //     Permission.microphone);

                                  await chatRoomRef
                                      .doc(chatRoomModel.id)
                                      .get()
                                      .then((snapshot) async {
                                    if ((snapshot.data() as Map<String,
                                            dynamic>)['channelName'] ==
                                        null) {
                                      var subStr = uuid.v4();
                                      int uid = auth!.currentUser!.uid.hashCode;
                                      String channelName = subStr.substring(
                                          0, subStr.length - 14);
                                      Response response = await get(Uri.parse(
                                          'https://mindscape-project.herokuapp.com/agora_access_token?channelName=$channelName&role=publisher&uid=$uid&expiryTime=600'));
                                      Map data = jsonDecode(response.body);
                                      print('agora token: ${data['token']}');
                                      await chatRoomRef
                                          .doc(chatRoomModel.id)
                                          .collection('agoraTokens')
                                          .doc(auth!.currentUser!.uid)
                                          .set({
                                        'token': data['token'],
                                        'expiryAt': DateTime.now()
                                            .add(const Duration(seconds: 60))
                                            .toUtc()
                                            .millisecondsSinceEpoch
                                      });
                                      chatRoomRef.doc(chatRoomModel.id).update({
                                        'channelName': channelName
                                      }).then((value) {
                                        Navigator.pop(context);
                                        // push video page with given channel name
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => VideoChat(
                                                    role:
                                                        ClientRole.Broadcaster,
                                                    channelName: channelName,
                                                    agoraToken:
                                                        '${data['token']}',
                                                    uid: auth!
                                                        .currentUser!.uid)));
                                      });
                                    } else {
                                      String token = '';
                                      var tokenSnapshot = await chatRoomRef
                                          .doc(chatRoomModel.id)
                                          .collection('agoraTokens')
                                          .doc(auth!.currentUser!.uid)
                                          .get();
                                      bool generateToken = true;
                                      if (tokenSnapshot.exists) {
                                        var tokenData = tokenSnapshot.data()
                                            as Map<String, dynamic>;
                                        if (tokenData['expiryAt'] >
                                            DateTime.now()
                                                .toUtc()
                                                .millisecondsSinceEpoch) {
                                          generateToken = false;
                                          token = tokenData['token'];
                                        } else {
                                          await chatRoomRef
                                              .doc(chatRoomModel.id)
                                              .collection('agoraTokens')
                                              .doc(auth!.currentUser!.uid)
                                              .delete();
                                        }
                                      }
                                      if (generateToken) {
                                        int uid =
                                            auth!.currentUser!.uid.hashCode;
                                        String channelName = (snapshot.data()
                                                as Map<String, dynamic>)[
                                            'channelName'];
                                        Response response = await get(Uri.parse(
                                            'https://mindscape-project.herokuapp.com/agora_access_token?channelName=$channelName&role=publisher&uid=$uid&expiryTime=600'));
                                        Map data = jsonDecode(response.body);
                                        await chatRoomRef
                                            .doc(chatRoomModel.id)
                                            .collection('agoraTokens')
                                            .doc(auth!.currentUser!.uid)
                                            .set({
                                          'token': data['token'],
                                          'expiryAt': DateTime.now()
                                              .add(const Duration(seconds: 60))
                                              .toUtc()
                                              .millisecondsSinceEpoch
                                        });
                                        token = data['token'];
                                      }
                                      Navigator.pop(context);
                                      // push video page with given channel name
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => VideoChat(
                                              role: ClientRole.Broadcaster,
                                              channelName: (snapshot.data()
                                                      as Map<String, dynamic>)[
                                                  'channelName'],
                                              agoraToken: token,
                                              uid: auth!.currentUser!.uid),
                                        ),
                                      );
                                    }
                                  });
                                }),
                          ),
                        if (!widget.showingHistory)
                          PopupMenuButton(
                            child: const Icon(
                              Icons.arrow_right_sharp,
                              color: Colors.white,
                              size: 26,
                            ),
                            onSelected: (value) async {
                              if (chatRoomModel.creatorID ==
                                  auth!.currentUser!.uid) {
                                switch (value) {
                                  case 0:
                                    print('invite');

                                    showInviteMenu(context, size);
                                    break;
                                  case 1:
                                    print('participant');

                                    participants.value = true;
                                    await Future.delayed(
                                        const Duration(milliseconds: 200));
                                    animController.forward();
                                    break;
                                  case 2:
                                    print('health');
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => HealthReportScreen(
                                        clientID: widget.clientUid,
                                      ),
                                    ));
                                    break;
                                  case 3:
                                    await showDialog(
                                      context: context,
                                      builder: (context) => CustomDialogBox(
                                        consultantName:
                                            scheduledMeeting!.consultantName,
                                        onpressed: () async {
                                          print('YES');
                                          await showDialog(
                                            context: context,
                                            builder:
                                                (context) =>
                                                    CustomRatingDialogBox(
                                                        consultantEmail:
                                                            consultantDoc.value[
                                                                userEmail],
                                                        consultantID:
                                                            scheduledMeeting!
                                                                .creatorID,
                                                        consultantName:
                                                            scheduledMeeting!
                                                                .consultantName,
                                                        creatorUsername:
                                                            accountDoc.value[
                                                                userName],
                                                        currentMeetingID: widget
                                                            .scheduledMeetingID),
                                          );
                                          print('rated');
                                        },
                                      ),
                                    );
                                    print('end');
                                    break;
                                }
                              } else {
                                switch (value) {
                                  case 0:
                                    print('participant');

                                    participants.value = true;
                                    await Future.delayed(
                                        const Duration(milliseconds: 200));
                                    animController.forward();
                                    break;
                                  case 1:
                                    print('health');
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => HealthReportScreen(
                                        clientID: scheduledMeeting!.creatorID,
                                      ),
                                    ));
                                    break;
                                }
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
                    child: chatRoomLoaded
                        ? StreamBuilder(
                            stream: chatRoomMessagesRef
                                .orderBy('timestamp', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  reverse: true,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  itemCount: (snapshot.data as QuerySnapshot)
                                      .docs
                                      .length,
                                  itemBuilder: (context, index) =>
                                      _buildChatMessageWidget(index,
                                          snapshot:
                                              (snapshot.data as QuerySnapshot)
                                                  .docs[index]),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
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
                                      ? const ImagePickerPageIOS()
                                      : const ImagePickerAndroid(),
                                ));
                                if (result != null && result.isNotEmpty) {
                                  print(result);
                                  notSendingCurrently = false;
                                  print('setting state edit photo onTapped');
                                  // if (Platform.isAndroid) {
                                  //   photoUrl = result;
                                  // } else {
                                  //   photo = result;
                                  //   imgUrl = photo.toString();
                                  // }
                                  var url = await uploadFileToFirebase(result);
                                  var subStr = uuid.v4();
                                  String id =
                                      subStr.substring(0, subStr.length - 10);

                                  ChatroomMessage message = ChatroomMessage(
                                    id: id,
                                    chatroomID: chatRoomModel.id,
                                    senderID: auth!.currentUser!.uid,
                                    isRead: false,
                                    timestamp: DateTime.now(),
                                    message: url,
                                    quote: '',
                                    type: 'image',
                                  );

                                  print(accountDoc.value);
                                  chatRoomMessagesRef.doc(id).set({
                                    'message': message.message,
                                    'chatroomID': message.chatroomID,
                                    'senderID': message.senderID,
                                    'id': message.id,
                                    'quote': '',
                                    'senderAvatarUrl':
                                        accountDoc.value[userAvatarUrl],
                                    'isRead': message.isRead,
                                    'timestamp': message.timestamp
                                        .toUtc()
                                        .millisecondsSinceEpoch,
                                    'type': 'image'
                                  });
                                  // _listKey.currentState.insertItem(0,
                                  //     duration: Duration(seconds: 1));

                                  //inserting the msg into the messages list too at 0 index
                                  // chatRoomMessages.insert(0, message);

                                  String userName;
                                  if (accountDoc.value[userType] == 'client') {
                                    userName = accountDoc.value['userName'];
                                  } else {
                                    userName = accountDoc.value[userFirstName] +
                                        ' ' +
                                        accountDoc.value[userLastName];
                                  }
                                  String avatarUrl =
                                      accountDoc.value[userAvatarUrl];
                                  print(userName);
                                  print(avatarUrl);
                                  for (var i = 0;
                                      i < chatRoomModel.participants.length;
                                      i++) {
                                    if (chatRoomModel.participants[i].userID !=
                                        auth!.currentUser!.uid) {
                                      PushNotificationHelperController.instance
                                          .sendNotificationMessageToPeerUser(
                                        1,
                                        'text',
                                        'Shared an image with you',
                                        userName,
                                        chatRoomModel.id,
                                        chatRoomModel.participants[i].fCMToken,
                                        avatarUrl,
                                      );
                                    }
                                  }
                                  notSendingCurrently = true;
                                }
                              }
                            },
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
                              icon: const Icon(
                                Icons.send,
                                color: kPrimaryColor,
                              ),
                              onPressed: () async {
                                if (_sendtextController.text.isNotEmpty &&
                                    notSendingCurrently) {
                                  notSendingCurrently = false;
                                  var subStr = uuid.v4();
                                  String id =
                                      subStr.substring(0, subStr.length - 10);

                                  ChatroomMessage message = ChatroomMessage(
                                    id: id,
                                    chatroomID: chatRoomModel.id,
                                    senderID: auth!.currentUser!.uid,
                                    isRead: false,
                                    timestamp: DateTime.now(),
                                    message: _sendtextController.text,
                                    quote: '',
                                    type: 'text',
                                  );
                                  print(accountDoc.value);
                                  chatRoomMessagesRef.doc(id).set({
                                    'message': message.message,
                                    'chatroomID': message.chatroomID,
                                    'senderID': message.senderID,
                                    'id': message.id,
                                    'quote': '',
                                    'senderAvatarUrl':
                                        accountDoc.value[userAvatarUrl],
                                    'isRead': message.isRead,
                                    'timestamp': message.timestamp
                                        .toUtc()
                                        .millisecondsSinceEpoch,
                                    'type': 'text'
                                  });
                                  // _listKey.currentState.insertItem(0,
                                  //     duration: Duration(seconds: 1));

                                  //inserting the msg into the messages list too at 0 index
                                  // chatRoomMessages.insert(0, message);

                                  String userName;
                                  if (accountDoc.value[userType] == 'client') {
                                    userName = accountDoc.value['userName'];
                                  } else {
                                    userName = accountDoc.value[userFirstName] +
                                        ' ' +
                                        accountDoc.value[userLastName];
                                  }
                                  String avatarUrl =
                                      accountDoc.value[userAvatarUrl];
                                  print(userName);
                                  print(avatarUrl);
                                  _sendtextController.clear();
                                  heightOfText.value = 45.0;
                                  setState(() {
                                    mic = true;
                                  });
                                  notSendingCurrently = true;
                                  for (var i = 0;
                                      i < chatRoomModel.participants.length;
                                      i++) {
                                    if (chatRoomModel.participants[i].userID !=
                                        auth!.currentUser!.uid) {
                                      PushNotificationHelperController.instance
                                          .sendNotificationMessageToPeerUser(
                                        1,
                                        'text',
                                        _sendtextController.text,
                                        userName,
                                        chatRoomModel.id,
                                        chatRoomModel.participants[i].fCMToken,
                                        avatarUrl,
                                      );
                                    }
                                  }
                                }
                              },
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
              builder: (context, bool value, double animValue, child) => value
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
                                            (e) => Row(
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
                                            .map((e) => Row(
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
  Future initiateRecorder() async {
    hasRecordingPermission = await Permission.microphone.isGranted;
    if (!hasRecordingPermission) {
      var status = await Permission.microphone.request();
      hasRecordingPermission = status == PermissionStatus.granted ||
          status == PermissionStatus.limited;
    }
    if (hasRecordingPermission) {
      _mySoundRecorder.openAudioSession().then((value) {
        setState(() {
          _mRecorderIsInited = true;
        });
      });
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
        await _mySoundRecorder.startRecorder(
          toFile: filepath,
          codec: Codec.aacADTS,
        );
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

      await _mySoundRecorder.stopRecorder();
      timer?.cancel();

      uploadRecording();
    }
  }

  void uploadRecording() async {
    if (_audioRecordPath?.isNotEmpty ?? false) {
      notSendingCurrently = true;
      var url = await uploadFileToFirebase(_audioRecordPath!, audio: true);
      var subStr = uuid.v4();
      String id = subStr.substring(0, subStr.length - 10);

      ChatroomMessage message = ChatroomMessage(
        id: id,
        chatroomID: chatRoomModel.id,
        senderID: auth!.currentUser!.uid,
        isRead: false,
        timestamp: DateTime.now(),
        message: url,
        quote: '',
        type: 'audio',
        secondsOfAudio: secondsOfAudioRecorded,
      );
      var accountDoc =
          await accountSettingsRef!.child(auth!.currentUser!.uid).once();
      print(accountDoc.value);
      chatRoomMessagesRef.doc(id).set({
        'message': message.message,
        'chatroomID': message.chatroomID,
        'senderID': message.senderID,
        'id': message.id,
        'quote': '',
        'senderAvatarUrl': accountDoc.value[userAvatarUrl],
        'isRead': message.isRead,
        'timestamp': message.timestamp.toUtc().millisecondsSinceEpoch,
        'type': 'audio',
        'secondsOfAudio': message.secondsOfAudio,
      });
      // cont.listKey.currentState.insertItem(0,
      //     duration: Duration(seconds: 1));

      // // inserting the msg into the messages list too at 0 index
      // chatRoomMessages.insert(0, message);

      String userName;
      if (accountDoc.value[userType] == 'client') {
        userName = accountDoc.value['userName'];
      } else {
        userName = accountDoc.value[userFirstName] +
            ' ' +
            accountDoc.value[userLastName];
      }
      String avatarUrl = accountDoc.value[userAvatarUrl];
      print(userName);
      print(avatarUrl);
      for (var i = 0; i < chatRoomModel.participants.length; i++) {
        if (chatRoomModel.participants[i].userID != auth!.currentUser!.uid) {
          PushNotificationHelperController.instance
              .sendNotificationMessageToPeerUser(
            1,
            'text',
            '$userName has sent a recording',
            userName,
            chatRoomModel.id,
            chatRoomModel.participants[i].fCMToken,
            avatarUrl,
          );
        }
      }
      notSendingCurrently = true;
      secondsOfAudioRecorded = 0;
    }
  }

  // Future<void> _handleCameraAndMic(Permission permission) async {
  //   final status = await permission.request();
  //   print(status);
  // }
}
