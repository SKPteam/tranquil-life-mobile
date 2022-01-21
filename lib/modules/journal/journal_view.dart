// ignore_for_file: avoid_print

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


import 'package:get/get.dart';
import 'package:tranquil_app/app/getx_controllers/dashboard_controller.dart';
import 'package:tranquil_app/app/getx_controllers/journal_controller.dart';
import 'package:tranquil_app/app/getx_controllers/journal_history_controller.dart';
import 'package:tranquil_app/app/helperControllers/timeFunctionsController.dart';
import 'package:tranquil_app/app/models/journal_model.dart';
import 'package:tranquil_app/app/modules/journal/selected_note_view.dart';
import 'package:tranquil_app/app/utils/constants.dart';
import 'package:tranquil_app/app/utils/sizes_helpers.dart';
import 'package:tranquil_app/app/utils/snackbar.dart';
//import 'package:path_provider/path_provider.dart';

import '../../../main.dart';
import 'components/customTextClipper.dart';
import 'journal_history_view.dart';

class JournalView extends StatefulWidget {
  final String moodSvgUrl;

  const JournalView({Key? key, required this.moodSvgUrl}) : super(key: key);

  @override
  _JournalViewState createState() => _JournalViewState();
}

class _JournalViewState extends State<JournalView>
    with SingleTickerProviderStateMixin {
  final JournalController _ = Get.put(JournalController());
  final JournalHistoryController historyController = Get.put(JournalHistoryController());


  @override
  void initState() {
    _.headingController = TextEditingController();
    _.controller = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    _.textAnim = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 80, end: 0)
            .chain(CurveTween(curve: Curves.ease)),
        weight: 80.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 40)
            .chain(CurveTween(curve: Curves.ease)),
        weight: 60.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 40, end: 0)
            .chain(CurveTween(curve: Curves.ease)),
        weight: 60.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 20)
            .chain(CurveTween(curve: Curves.ease)),
        weight: 40.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 20, end: 0)
            .chain(CurveTween(curve: Curves.ease)),
        weight: 40.0,
      ),
    ]).animate(_.controller!);
    _.textSlideAnim = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.6, end: 1.4)
            .chain(CurveTween(curve: Curves.ease)),
        weight: 80.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.4, end: 0.7)
            .chain(CurveTween(curve: Curves.ease)),
        weight: 60.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.7, end: 1.3)
            .chain(CurveTween(curve: Curves.ease)),
        weight: 40.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.3, end: 0.8)
            .chain(CurveTween(curve: Curves.ease)),
        weight: 60.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.8, end: 1)
            .chain(CurveTween(curve: Curves.ease)),
        weight: 80.0,
      ),
    ]).animate(_.controller!);

    start();

    print(widget.moodSvgUrl.isNotEmpty
        ? 'Selected Mood In JournalPage: ' + widget.moodSvgUrl
        : 'No Mood Selected');
    super.initState();
  }

  void start() async {
    await Future.delayed(const Duration(seconds: 1));
    _.controller?.forward().orCancel;
  }

  @override
  void dispose() {
    if (!(_.controller?.isDismissed ?? true)) {
      _.controller!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _.setFontSize(context);
    final date =
        '${_.dateTime.day} ${monthsFromIndex[_.dateTime.month - 1]}, ${_.dateTime.year}';
    final textSize = _.getSizeOfText(MediaQuery.of(context).size.width);
    return Scaffold(
      backgroundColor: kLightBackgroundColor,
      body: SafeArea(
          child: DashboardController.to.userType!.value == client
              ?
          SingleChildScrollView(
              child: Container(
                height: displayHeight(context),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          date,
                          style: const TextStyle(
                            color: kPrimaryDarkColor,
                            fontSize: 16,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => JournalHistoryView());
                          },
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Icon(
                              Icons.list,
                              color: kPrimaryColor,
                              size: displayWidth(context) * 0.06,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    if (widget.moodSvgUrl.isNotEmpty)
                      Image.asset(widget.moodSvgUrl, height: 60),
                    AnimatedBuilder(
                      animation: _.textAnim!,
                      builder: (context, child) => Transform.translate(
                        offset: Offset(0, _.textAnim!.value),
                        child: Opacity(
                          opacity: (0.8 -
                              (_.textAnim!.value != 0
                                  ? _.textAnim!.value.toDouble() / 100
                                  : -0.2))
                              .toDouble(),
                          child: SizedOverflowBox(
                            size: textSize,
                            alignment: Alignment.topCenter,
                            child: ClipRect(
                              clipper: CustomTextClipper(textSize),
                              child: Transform.translate(
                                offset: Offset(
                                    0, -_.textSlideAnim!.value * textSize.height),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: textSize.width >
                                          MediaQuery.of(context).size.width
                                          ? textSize.height * 2
                                          : textSize.height,
                                      child: Text(
                                        'What\'s On Your Mind?',
                                        style: TextStyle(
                                          fontSize: _.fontSizeForTitle,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height: textSize.width >
                                            MediaQuery.of(context).size.width
                                            ? textSize.height * 2
                                            : textSize.height,
                                        child: TextField(
                                          maxLines: 3,
                                          controller: _.headingController,
                                          style:
                                          TextStyle(fontSize: _.fontSizeForTitle),
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                              fontSize: _.fontSizeForTitle,
                                              color: Colors.black54,
                                            ),
                                            hintText: 'What\'s On Your Mind?',
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                          ),
                                        )),
                                    SizedBox(
                                      height: textSize.width >
                                          MediaQuery.of(context).size.width
                                          ? textSize.height * 2
                                          : textSize.height,
                                      child: Text(
                                        'What\'s On Your Mind?',
                                        style: TextStyle(
                                          fontSize: _.fontSizeForTitle,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      maxLines: 8,
                      style: const TextStyle(fontSize: 20),
                      controller: _.bodyController,
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(fontSize: 20),
                        hintText: 'Type Something here',
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: InkWell(
                          onTap: () {
                            saveToDatabase();
                          },
                          child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              radius: 30,
                              child: Icon(
                                Icons.check,
                                color: kPrimaryColor,
                                size: displayWidth(context) * 0.06,
                              )),
                        )),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ))
              :
          SizedBox(
            width: displayWidth(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //------------------------
                // APPBAR
                //------------------------
                Container(
                  width: displayWidth(context) * 0.95,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: displayWidth(context) * 0.06,
                      ),
                      //------------------------
                      // SCREEN HEADING
                      //------------------------
                      const Text(
                        'Journal',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Spacer(),
                      //------------------------
                      // Search Button Container
                      //------------------------
                      InkWell(
                        onTap: () {
                          //TODO: Search query for journal using heading
                        },
                        child: Container(
                          height: displayHeight(context) * 0.037,
                          width: displayHeight(context) * 0.037,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          //------------------------
                          // SEARCH SVG
                          //------------------------
                          child: Icon(
                            Icons.search_rounded,
                            size: displayWidth(context) * 0.06,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //------------------------
                // JOURNAL CONTAINER
                //------------------------
                Expanded(
                  //------------------------
                  // STAGGERED LIST VIEW
                  //------------------------
                  child: Obx(() {
                    return historyController.journalsLoaded.value
                        ? StaggeredGridView.countBuilder(
                      //divide the horizontal axis into 6 parts
                      crossAxisCount: 6,
                      controller: historyController.scrollController,
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 18),
                      physics: const BouncingScrollPhysics(),
                      itemCount: historyController.moreJournalsAvailableInDatabase.value
                          ? historyController.journalList.length + 1
                          : historyController.journalList.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == historyController.journalList.length) {
                          return const SizedBox(
                            height: 60,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        String heading = historyController.journalList[index].heading;
                        print(historyController.journalList[index].moodSvgUrl);
                        bool isThree = (index + 1) % 3 == 0;
                        //------------------------
                        // STACK FOR EMOJI AND JOURNAL
                        //------------------------
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            //------------------------
                            // CONTAINER FOR JOURNAL
                            //------------------------
                            InkWell(
                                onLongPress: () {
                                  _cardOptionsDialog(
                                      historyController.journalList[index], context, historyController);
                                },
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) =>
                                        SelectedNoteView(
                                          journalModel: historyController.journalList[index],
                                        ),
                                  ));
                                },
                                child: Container(
                                  padding: isThree
                                      ? const EdgeInsets.all(26)
                                      : const EdgeInsets.symmetric(
                                      vertical: 28, horizontal: 18),
                                  decoration: BoxDecoration(
                                    color: historyController.getColor(
                                        historyController.journalList[index].heading),
                                    borderRadius:
                                    BorderRadius.circular(8),
                                  ),
                                  //------------------------
                                  // COLUMN FOR HEADING AND DATE
                                  //------------------------
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    // mainAxisAlignment:
                                    // MainAxisAlignment.spaceBetween,
                                    children: [
                                      //------------------------
                                      // HEADING CONTAINER
                                      //------------------------
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: displayHeight(context)*0.02),
                                          child: Text(
                                            //if the string length is greater than 60 characters then cut it to 58 characters
                                            //and add "..." to the end of the heading in
                                            //journal containers of half width
                                            heading.length > 60
                                                ? isThree
                                                ? heading
                                                : heading.substring(
                                                0, 58) +
                                                '...'
                                                : heading,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      //------------------------
                                      // DATE
                                      //------------------------
                                      Align(
                                        // if it is the every 3rd element of the journal
                                        //  list then align the date to the right side
                                        alignment: (index + 1) % 3 == 0
                                            ? Alignment.centerRight
                                            : Alignment.bottomLeft,
                                        child: Text(
                                          TimeManipulativeHelperController
                                              .instance
                                              .convertTimeToMDY(
                                            historyController.journalList[index]
                                                .timestamp,
                                          ),
                                          style: const TextStyle(
                                            color: Colors.white60,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            //------------------------
                            // MOOD CONTAINER
                            //------------------------
                            //if there is a mood attached to the journal element then the mood
                            //container in the topRight corner will be created
                            if (historyController
                                .journalList[index].moodSvgUrl.isNotEmpty)
                              Positioned(
                                top: -8,
                                right: (index + 1) % 3 == 0
                                    ? 200 : 16,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(6),
                                    color: Colors.black,
                                  ),
                                  child: Center(
                                    child: Image.network(
                                      historyController.journalList[index].moodSvgUrl,
                                      fit: BoxFit.contain,
                                      height: 30,
                                      width: 30,
                                    ),
                                  ),
                                ),
                              ),

                            Positioned(
                              top: -10,
                              right: (index + 1) % 3 == 0
                                  ? 260 : 76,
                              child: Container(
                                width: 100,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(6),
                                  color: Colors.black,
                                ),
                                child: const Center(
                                    child: Text("username",
                                      style: TextStyle(
                                          color: Colors.white
                                      ),)
                                ),
                              ),
                            ),

                          ],
                        );
                      },
                      staggeredTileBuilder: (int index) {
                        bool isLoader = index == historyController.journalList.length;
                        bool isThree = true;
                        double crossCount = 1;
                        if (!isLoader) {
                          var headingLength = historyController.journalList[index].heading
                              .length; //length of heading of journal

                          isThree = (index + 1) % 3 ==
                              0; //is it the 3rd element

                          //calculation crossAxis count i.e vertical height of the containers
                          //based on the number of characters in the heading of journal
                          //and also based on whether it's the very 3rd element with full width
                          //container
                          crossCount = (index + 1) % 3 == 1
                              ? headingLength < 20
                              ? isThree
                              ? 0.8
                              : 2.3
                              : headingLength < 30
                              ? isThree
                              ? 0.9
                              : 2.8
                              : headingLength < 40
                              ? isThree
                              ? 1.0
                              : 3.2
                              : headingLength < 50
                              ? isThree
                              ? 1.1
                              : 3.6
                              : headingLength < 60
                              ? isThree
                              ? 1.2
                              : 4
                              : isThree
                              ? 1.3
                              : 4
                              : historyController.prevCrossCount!;

                          //if it's every 1st journal of 3 journals then it's vertical height is to be stored to directly use in the
                          //2nd jounral of 3 journals i.e both the half width containers will have same height no matter what
                          if ((index + 1) % 3 == 1) {
                            historyController.prevCrossCount = crossCount;
                          }
                        }
                        return StaggeredTile.count(
                          isThree ? 6 : 3,
                          crossCount,
                        );
                        //returning axis count as full width or half width as the horizontal axis is divided into 6 parts
                        //and then the cross axis count that is vertical height is also passed from the previous variable
                      },
                      //horizontal spacing between elements
                      mainAxisSpacing: 16,
                      //vertical spacing between elements
                      crossAxisSpacing: 13,
                    )
                        : const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
                )
              ],
            ),
          )
      ),
    );
  }

  ///converts asset to file
  // Future<File> getImageFileFromAssets(String _path) async {
  //   final byteData = await rootBundle.load(_path);
  //
  //   final lastIndexOfSlash = _path.lastIndexOf('/');
  //   final fileName = _path.substring(lastIndexOfSlash);
  //
  //   ///final file = File('${(await getTemporaryDirectory()).path}/$fileName');
  //   //error was that, as we were giving the whole path to store, while writeAsBytes only works when
  //   //uh provide a filename, not a whole directory, it can't create folders only file so earlier,
  //   // we were passing assets/xxxxxx/xxxx.svg with meant that it had to create assets and xxxxx folder
  //   //since it can't create folders it wasn't created anything and else file was not found
  //   // await file.writeAsBytes(byteData.buffer
  //   //     .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  //   //
  //   // return file;
  // }

  void saveToDatabase() async {
    var subStr = _.uuid.v4();
    var id = subStr.substring(0, subStr.length - 10);

    if (_.headingController!.text.isEmpty) {
      displaySnackBar('Heading is empty', Get.context!);
    } else if (_.bodyController.text.isEmpty) {
      displaySnackBar('Body is empty', Get.context!);
    } else {
      showLoaderDialog(Get.context!);

      ///If moodSvgUrl is empty
      if (widget.moodSvgUrl.isEmpty) {
        await journalRef!
            .doc(auth!.currentUser!.uid)
            .collection('journalHistory')
            .doc(id)
            .set({
          userJID: id,
          userJHeading: _.headingController!.text,
          userJBody: _.bodyController.text,
          "clientID": auth!.currentUser!.uid,
          "consultantID": "",
          userJMood: '',
          userJDate: DateTime.now().toUtc().millisecondsSinceEpoch
        }).then((value) {
          displaySnackBar('Saved to journal', context);
          sendEmail();
        }).catchError((e) {
          print("Save error: ${e.toString()}");
        });
      }

      ///If moodSvgUrl is not empty
      ///SAVE ICON TO FIREBASE STORAGE BEFORE SAVING DATA TO DATABASE
      else {
        //File file = await getImageFileFromAssets(widget.moodSvgUrl);
        //String fileName = file.path.split('/').last;
        // Reference ref =
        //     FirebaseStorage.instance.ref().child('moodIcons/$fileName');
        // UploadTask uploadTask = ref.putFile(file);

        // await uploadTask.whenComplete(() async {
        //   String downloadUrl;
        //   downloadUrl = await ref.getDownloadURL();
        //   setState(() {
        //     journalRef!
        //         .doc(auth!.currentUser!.uid)
        //         .collection('journalHistory')
        //         .doc(id)
        //         .set({
        //       userJID: id,
        //       userJHeading: _.headingController!.text,
        //       userJBody: _.bodyController.text,
        //       userJMood: downloadUrl,
        //       userJDate: DateTime.now().toUtc().millisecondsSinceEpoch
        //     }).then((value) {
        //       displaySnackBar('Saved to journal', context);
        //       sendEmail();
        //     }).catchError((e) {
        //       print('Save Error: ${e.toString()}');
        //     });
        //   });
        // });
      }
      _.headingController!.clear();
      _.bodyController.clear();
      Navigator.of(context).pop();
    }
  }

  void sendEmail() {
    //..
  }

  Future<void> _cardOptionsDialog(JournalModel _model, BuildContext ctx,
      JournalHistoryController controller) async {
    return Get.dialog(AlertDialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            ListTile(
              onTap: () async {
                Navigator.pop(ctx);
                showLoaderDialog(ctx);
                await journalRef!
                    .doc(auth!.currentUser!.uid)
                    .collection('journalHistory')
                    .doc(_model.id)
                    .delete();

                controller.journalList.remove(_model);

                Navigator.pop(ctx);
              },
              visualDensity: VisualDensity.compact,
              contentPadding: EdgeInsets.zero,
              dense: true,
              horizontalTitleGap: 0,
              title: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text(
                  'Delete',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: displayWidth(ctx) * 0.05),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
    // .whenComplete(() {
    //   _isDefault = false;

    //   print(_isDefault);
    // });
  }
}
