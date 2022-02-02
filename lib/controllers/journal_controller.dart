// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';
import 'package:uuid/uuid.dart';

class JournalController extends GetxController {
  static JournalController instance = Get.find();


  /*........ Journal Controller ......*/
  AnimationController? controller;
  Animation<double>? textAnim;
  RxBool disposed = false.obs;
  double fontSizeForTitle = 45;
  Animation<double>? textSlideAnim;
  TextEditingController? headingController;
  TextEditingController bodyController = TextEditingController();

  var uuid = Uuid();

  final dateTime = DateTime.now();

  Size getSizeOfText(double sWidth) {
  final painter = TextPainter();
  painter.text = TextSpan(
  style: TextStyle(
  fontSize: fontSizeForTitle,
  ),
  text: 'What\'s On Your Mind?');
  painter.textDirection = TextDirection.ltr;
  painter.textAlign = TextAlign.left;
  painter.textScaleFactor = 1.0;
  painter.layout();
  return painter.size.width > sWidth
  ? Size(sWidth, painter.size.height * 2.5)
      : Size(painter.size.width, painter.size.height * 0.25);
  }

  Map data = {};
  void setFontSize(BuildContext context) {
  var width = displayWidth(context);
  if (width < 200) {
  fontSizeForTitle = 36;
  } else if (width < 300) {
  fontSizeForTitle = 42;
  } else if (width < 400) {
  fontSizeForTitle = 48;
  } else {
  fontSizeForTitle = 52;
  }
  }

  @override
  void onInit() {
  super.onInit();
  }

  @override
  void onReady() {
  super.onReady();
  }

  @override
  void onClose() {}
  }


/*........ Journal History Controller ........*/
class JournalHistoryController extends GetxController {
  double? prevCrossCount;

  Map map = {};
  RxBool journalsLoaded = false.obs;

  // final RxList<JournalModel> journalList = <JournalModel>[].obs;

  ///the last Notification document from the 10 extracted documents
  // DocumentSnapshot? lastDisplayedJournalDocument;

  ///scroll controlling for checking whether the screen is scrolled to the end
  final ScrollController scrollController = ScrollController();

  ///boolean to check if there are more pagination is required
  RxBool moreJournalsAvailableInDatabase = true.obs;

  @override
  void onInit() {
    super.onInit();
    getDataFromFirebase();
    //adding a scroll controller and add a listener to listen when the scroll reaches to maximum extent
    scrollController.addListener(scrollListener);
    //getJournalHistory();
  }

  @override
  void onClose() {
    scrollController.dispose();
  }

  void scrollListener() {
    //checking if there are more notifications in Database and then check if the scrollController attached to the listView
    //offset is greater than the max Offset the listView has.. and if that happens call the getting data function again for getting
    //further notifications from db
    if (moreJournalsAvailableInDatabase.value &&
        (scrollController.offset >= scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange)) {
      print("at the end of list");
      getDataFromFirebase();
    }
  }

  void getDataFromFirebase() async {
    // print('Extracting Data from Firebase for Transaction History');
    // //snapshots from database
    // QuerySnapshot journalDocs;
    // //if the list is empty, that is extraction process if done for first time, then
    // // don't use startAfterDocument property and limit the documents to 10
    // if (journalList.isEmpty) {
    //   journalDocs = await journalRef!
    //       .doc(auth!.currentUser!.uid)
    //       .collection('journalHistory')
    //       .orderBy('timestamp', descending: true)
    //       .limit(10)
    //       .get();
    // } else {
    //   // if it's not first time of extractiong then add the startAfterDocument and provide it the last snapshot of Notification
    //   // that was stored in the variable
    //   journalDocs = await journalRef!
    //       .doc(auth!.currentUser!.uid)
    //       .collection('journalHistory')
    //       .orderBy('timestamp', descending: true)
    //       .startAfterDocument(lastDisplayedJournalDocument!)
    //       .limit(10)
    //       .get();
    // }
    //
    // await _handleDataFromDatabase(journalDocs);
    //
    // journalsLoaded.value = true;
  }

  Future _handleDataFromDatabase(// QuerySnapshot journalDocs,
      ) async {
    // //if snapshots from database is not empty, then execute below code
    // if (journalDocs.docs.isNotEmpty) {
    //   // store the last snapshot of the 10 documents to be used for startfromDocument option
    //   lastDisplayedJournalDocument = journalDocs.docs.last;
    //   //for each document in the snapshot execute the loop
    //   for (var i = 0; i < journalDocs.docs.length; i++) {
    //     var doc = journalDocs.docs[i];
    //     print("Jounral History => ${i + 1}  ------- data: ${doc.data()}");
    //     var docData = doc.data() as Map;
    //     //!will use this for getting name of the user to which money is sent
    //     //get the userData from the uid of the notification
    //     // var userAccountDoc =
    //     //     await accountSettingsRef.child(docData['uid']).once();
    //
    //     //add the data into Notification Model and then add it to the notifications list
    //     journalList.add(
    //       JournalModel(
    //         id: docData['id'].toString(),
    //         heading: docData['heading'].toString(),
    //         body: docData['body'].toString(),
    //         moodSvgUrl: docData['moodUrl'].toString(),
    //         timestamp: DateTime.fromMillisecondsSinceEpoch(
    //             docData['timestamp'].toInt())
    //             .toLocal(),
    //       ),
    //     );
    //   }
    // }
    // //if the length of snapshot documents is less than 10 or it is empty then
    // // make the bool variable that suggests that no notifications are available in database for pagination
    // if (journalDocs.docs.length < 10) {
    //   moreJournalsAvailableInDatabase.value = false;
    // }
  }

  // void getJournalHistory() async {
  //   await journalRef!
  //       .doc(auth!.currentUser!.uid)
  //       .collection('journalHistory')
  //       .orderBy('timestamp', descending: true)
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     journalList.clear();
  //     querySnapshot.docs.forEach((doc) {
  //       var mapData = doc.data() as Map;
  //       var keys = mapData.keys;
  //
  //       print(keys);
  //       print(mapData);
  //
  //       journalModel = JournalModel(
  //         id: mapData['id'].toString(),
  //         heading: mapData['heading'].toString(),
  //         body: mapData['body'].toString(),
  //         moodSvgUrl: mapData['moodUrl'].toString(),
  //         timestamp:
  //             DateTime.fromMillisecondsSinceEpoch(mapData['timestamp'].toInt())
  //                 .toLocal(),
  //       );
  //       journalList.add(journalModel!);
  //       print('${journalModel!.heading}');
  //     });
  //   });
  //   setState(() {
  //     journalsLoaded.value = true;
  //   });
  // }

  ///get random color from the primary colors of material
  Color getColor(String text) {
    return Colors.primaries[text.length % Colors.primaries.length].shade800;
  }
}

//TODO: Implement business logic for every feature in the Journal page here:
//TODO: everything for journal and journal history
