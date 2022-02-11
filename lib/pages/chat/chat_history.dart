// // ignore_for_file: prefer_const_constructors
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:tranquil_life/constants/style.dart';
// import 'package:tranquil_life/controllers/chat_controller.dart';
// import 'package:tranquil_life/helpers/sizes_helpers.dart';
//
// class ChatHistoryView extends StatefulWidget {
//   const ChatHistoryView({Key? key}) : super(key: key);
//
//   @override
//   _ChatHistoryViewState createState() => _ChatHistoryViewState();
// }
//
// class _ChatHistoryViewState extends State<ChatHistoryView> {
//   final ChatHistoryController _ = Get.put(ChatHistoryController());
//   String avatarUrl = "";
//   String username = "";
//   int? messagesDocCount;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kLightBackgroundColor,
//       body: SafeArea(
//         child: SizedBox(
//           width: displayWidth(context),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 width: displayWidth(context) * 0.95,
//                 padding: const EdgeInsets.all(8),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     //------------------------
//                     // BACK BUTTON
//                     //------------------------
//                     IconButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       icon: const Icon(Icons.arrow_back, color: kPrimaryColor),
//                     ),
//                     SizedBox(
//                       width: displayWidth(context) * 0.06,
//                     ),
//                     //------------------------
//                     // SCREEN HEADING
//                     //------------------------
//                     const Text(
//                       'Chat History',
//                       style: TextStyle(
//                         color: kPrimaryColor,
//                         fontSize: 20,
//                         fontWeight: FontWeight.w900,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                   child: Container(
//                       height: displayHeight(context),
//                       padding: EdgeInsets.all(16.0),
//                       child: FutureBuilder(
//                         builder: (BuildContext context,
//                             AsyncSnapshot<dynamic> snapshot) {
//                           if (!snapshot.hasData) {
//                             return Center(
//                                 child: CircularProgressIndicator());
//                           }
//                           // ignore: avoid_unnecessary_containers
//                           return Container(child: Text("Chat room history"),);
//                           //   ListView.builder(
//                           //   itemBuilder: (context, index) {
//                           //     DocumentSnapshot document =
//                           //     snapshot.data.docs[index];
//                           //
//                           //     Map<String, dynamic> mapDoc =
//                           //     document.data() as Map<String, dynamic>;
//                           //
//                           //     chatRoomsRef!
//                           //         .doc(mapDoc["id"])
//                           //         .collection("messages")
//                           //         .get()
//                           //         .then((value) {
//                           //       if (mounted) {
//                           //         setState(() {
//                           //           messagesDocCount = value.docs.length;
//                           //         });
//                           //       }
//                           //     });
//                           //
//                           //     List<Consultant> consultantList = <Consultant>[];
//                           //     Consultant? consultantModel;
//                           //
//                           //     if (DashboardController.to.userType == client) {
//                           //       accountSettingsRef!
//                           //           .child(mapDoc["consultantID"])
//                           //           .once()
//                           //           .then((DataSnapshot ds) {
//                           //         //Map<dynamic, dynamic> values = ds.value;
//                           //         consultantList.clear();
//                           //         var keys = ds.value.keys;
//                           //         var values = ds.value;
//                           //
//                           //         for (var key in keys) {
//                           //           consultantModel = Consultant(
//                           //             uid: values[userUID].toString(),
//                           //             firstName: values[userFirstName],
//                           //             lastName: values[userLastName],
//                           //             avatarUrl: values[userAvatarUrl],
//                           //             location: values[userCountry],
//                           //             onlineStatus: values[userOnlineStatus],
//                           //           );
//                           //           consultantList.add(consultantModel!);
//                           //         }
//                           //         if (mounted) {
//                           //           setState(() {
//                           //             avatarUrl =
//                           //                 consultantList[index].avatarUrl;
//                           //             username =
//                           //             "${consultantList[index].firstName} ${consultantList[index].lastName}";
//                           //           });
//                           //         }
//                           //       });
//                           //     }
//                           //     return GestureDetector(
//                           //       onTap: () async {
//                           //         final participantsList = [];
//                           //         participantsList.addAll(mapDoc['participants']
//                           //             .toList()
//                           //             .cast<String>());
//                           //         List<Participants> tempParticipant = [];
//                           //         for (var j = 0;
//                           //         j < participantsList.length;
//                           //         j++) {
//                           //           await accountSettingsRef!
//                           //               .child(participantsList[j])
//                           //               .once()
//                           //               .then((userAccountDetails) async {
//                           //             await usersRef!
//                           //                 .child((userAccountDetails
//                           //                 .value[userType] ??
//                           //                 '') ==
//                           //                 'client'
//                           //                 ? 'clients'
//                           //                 : 'consultants')
//                           //                 .child(participantsList[j])
//                           //                 .once()
//                           //                 .then((userRefValue) {
//                           //               tempParticipant.add(Participants(
//                           //                   participantsList[j],
//                           //                   userAccountDetails
//                           //                       .value[userFirstName] +
//                           //                       ' ' +
//                           //                       userAccountDetails
//                           //                           .value[userLastName],
//                           //                   userRefValue
//                           //                       .value[FCMtokenGetStoreConstant]
//                           //                       .toString(),
//                           //                   userAccountDetails
//                           //                       .value[userAvatarUrl]));
//                           //             });
//                           //           });
//                           //         }
//                           //         final _chatroomData = mapDoc;
//                           //         final chatRoomModel = Chatroom(
//                           //           id: _chatroomData['id'],
//                           //           creatorID: _chatroomData['creatorID'],
//                           //           consultantID: _chatroomData['consultantID'],
//                           //           timer: _chatroomData['timer'],
//                           //           participants: tempParticipant,
//                           //           timestamp:
//                           //           DateTime.fromMillisecondsSinceEpoch(
//                           //               _chatroomData['timestamp'])
//                           //               .toLocal(),
//                           //         );
//                           //         Get.to(
//                           //               () => ChatScreenPage(
//                           //             showingHistory: true,
//                           //             clientUid: chatRoomModel.creatorID,
//                           //             consultantUid: chatRoomModel.consultantID,
//                           //             chatroom: chatRoomModel,
//                           //           ),
//                           //         );
//                           //       },
//                           //       child: Container(
//                           //           padding: const EdgeInsets.all(10.0),
//                           //           margin: const EdgeInsets.only(
//                           //               top: 32.0, right: 16.0, left: 16.0),
//                           //           color: Colors.white,
//                           //           child: Stack(
//                           //             clipBehavior: Clip.none,
//                           //             children: [
//                           //               Row(
//                           //                 children: [
//                           //                   Container(
//                           //                     width: 54.0,
//                           //                     height: 54.0,
//                           //                     margin: const EdgeInsets.only(
//                           //                         right: 10),
//                           //                     decoration: BoxDecoration(
//                           //                       borderRadius:
//                           //                       BorderRadius.circular(35.0),
//                           //                       border: Border.all(
//                           //                           width: 2,
//                           //                           color: const Color(
//                           //                               0xffC9D8CD)),
//                           //                       image: DecorationImage(
//                           //                         image:
//                           //                         NetworkImage(avatarUrl),
//                           //                         fit: BoxFit.cover,
//                           //                       ),
//                           //                     ),
//                           //                   ),
//                           //                   Text(
//                           //                     username,
//                           //                     style: const TextStyle(
//                           //                         fontSize: 16.0),
//                           //                   )
//                           //                 ],
//                           //               ),
//                           //               Positioned(
//                           //                   right: -45,
//                           //                   top: -15,
//                           //                   child: Container(
//                           //                     margin: EdgeInsets.only(
//                           //                         right: displayWidth(
//                           //                             Get.context!) *
//                           //                             0.075),
//                           //                     padding:
//                           //                     const EdgeInsets.all(4.0),
//                           //                     decoration: BoxDecoration(
//                           //                       borderRadius:
//                           //                       BorderRadius.circular(20.0),
//                           //                       color: Colors.red,
//                           //                     ),
//                           //                     constraints: const BoxConstraints(
//                           //                       minWidth: 25,
//                           //                       minHeight: 25,
//                           //                     ),
//                           //                     child: Center(
//                           //                       child: Text(
//                           //                           messagesDocCount.isNull
//                           //                               ? "0"
//                           //                               : "$messagesDocCount",
//                           //                           style: const TextStyle(
//                           //                               color: Colors.white)),
//                           //                     ),
//                           //                   ))
//                           //             ],
//                           //           )),
//                           //     );
//                           //   },
//                           //   itemCount: snapshot.data.docs.length,
//                           // );
//                         },
//                       )))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
// }