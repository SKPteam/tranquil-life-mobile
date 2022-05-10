// ignore_for_file: prefer__ructors, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/dashboard_controller.dart';
import 'package:tranquil_life/controllers/journal_controller.dart';
import 'package:tranquil_life/controllers/onboarding_controller.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/pages/journal/widgets/note_item.dart';
import 'package:tranquil_life/routes/app_pages.dart';
import 'package:tranquil_life/widgets/custom_snackbar.dart';

import '../../controllers/journal_history_controller.dart';

class JournalView extends StatefulWidget {
  final String? moodSvgUrl;

  Size size = MediaQuery.of(Get.context!).size;

   JournalView({Key? key, required this.moodSvgUrl}) : super(key: key);

  @override
  _JournalViewState createState() => _JournalViewState();
}

class _JournalViewState extends State<JournalView> with SingleTickerProviderStateMixin {
  final controller = Get.put(OnBoardingController());
  final JournalController journalController = Get.put(JournalController());
  final dashboardController = Get.put(DashboardController());



  @override
  void initState() {
    journalController.controller = AnimationController(
        duration:  Duration(milliseconds: 700), vsync: this);
    journalController.textAnim = TweenSequence(<TweenSequenceItem<double>>[
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
    ]).animate(journalController.controller!);
    journalController.textSlideAnim = TweenSequence(<TweenSequenceItem<double>>[
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
    ]).animate(journalController.controller!);

    start();

    print(widget.moodSvgUrl!.isNotEmpty
        ? 'Selected Mood In JournalPage: ' + widget.moodSvgUrl!
        : 'No Mood Selected');
    super.initState();
  }

  void start() async {
    await Future.delayed( Duration(seconds: 1));
    journalController.controller?.forward().orCancel;
  }

  @override
  void dispose() {
    if (!(journalController.controller?.isDismissed ?? true)) {
      journalController.controller!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    journalController.setFontSize(context);
    // final date =
    //     '${_.dateTime.day} ${monthsFromIndex[_.dateTime.month - 1]}, ${_.dateTime.year}';
    final textSize = journalController.getSizeOfText(MediaQuery.of(context).size.width);
    String convertedDate = Jiffy(DateTime.now()).yMMMMEEEEd;

    return ResponsiveSafeArea(
      responsiveBuilder: (context, size) =>
          Scaffold(resizeToAvoidBottomInset: false, backgroundColor: kLightBackgroundColor,
        body: dashboardController.userType == client ?
        SingleChildScrollView(
            child: Container(
              height: size.height,
              padding:  EdgeInsets.all(20),
              child: Column(
                // mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(convertedDate,
                        style: TextStyle(
                          color: kPrimaryDarkColor,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.JOURNAL_HISTORY);
                          },
                          child: Icon(
                            Icons.list,
                            color: kPrimaryColor,
                            //size: size.width * 0.06,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  if (widget.moodSvgUrl!.isNotEmpty)
                    Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(widget.moodSvgUrl!, height: 60),
                      ],
                    ),
                  AnimatedBuilder(
                    animation: journalController.textAnim!,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(0, journalController.textAnim!.value),
                      child: Opacity(
                        opacity: (0.8 -
                            (journalController.textAnim!.value != 0 ? journalController.textAnim!.value.toDouble() / 100
                                : -0.2))
                            .toDouble(),
                        child: SizedOverflowBox(
                          size: textSize,
                          alignment: Alignment.topCenter,
                          child: ClipRect(
                            clipper: CustomTextClipper(textSize),
                            child: Transform.translate(
                              offset: Offset(0, -journalController.textSlideAnim!.value * textSize.height),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 100,
                                  ),
                                  SizedBox(
                                    height: textSize.width >
                                        MediaQuery.of(context).size.width
                                        ? textSize.height * 1.5
                                        : textSize.height,
                                    child: Text(
                                      'What\'s On Your Mind?',
                                      style: TextStyle(
                                        fontSize: journalController.fontSizeForTitle,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: textSize.width > MediaQuery.of(context).size.width ? textSize.height * 2 : textSize.height,
                                      child: TextField(
                                        maxLines: 3, controller: journalController.headingController,
                                        style:
                                        TextStyle(fontSize: journalController.fontSizeForTitle),
                                        decoration: InputDecoration(
                                          hintStyle: TextStyle(fontSize: journalController.fontSizeForTitle, color: Colors.black54,),
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
                                        ? textSize.height * 1.5
                                        : textSize.height,
                                    child: Text(
                                      'What\'s On Your Mind?',
                                      style: TextStyle(
                                        fontSize: journalController.fontSizeForTitle,
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
                  Spacer(),
                  TextField(
                    maxLines: 8,
                    style:  TextStyle(fontSize: 20),
                    controller: journalController.bodyController,
                    decoration:  InputDecoration(
                      hintStyle: TextStyle(fontSize: 20),
                      hintText: 'Type Something here',
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                    ),
                  ),
                  // SizedBox(
                  //   height: 100,
                  // ),
                  Spacer(),
                  Align(alignment: Alignment.bottomLeft,
                    child: Padding(
                        padding:  EdgeInsets.only(left: 30.0, bottom: 100),
                        child: InkWell(
                          onTap: () {
                            if (journalController.headingController!.text.isEmpty) {
                              CustomSnackBar.showSnackBar(
                                  context: context,
                                  title: "Error",
                                  message: kHeaderNullError,
                                  backgroundColor: active);
                            } else if (journalController.bodyController!.text.isEmpty) {
                              CustomSnackBar.showSnackBar(
                                  context: context,
                                  title: "Error",
                                  message: kBodyNullError,
                                  backgroundColor: active);
                            } else {
                              journalController.addJournal(journalController.headingController?.text, journalController.bodyController?.text, widget.moodSvgUrl!).whenComplete((){
                                journalController.headingController?.clear();
                                journalController.bodyController?.clear();
                              });
                            }
                          },
                          child: CircleAvatar(
                              backgroundColor: Colors.black54, radius: 30,
                              child: Icon(Icons.check, color: kPrimaryColor, size: size.width * 0.05,)),
                        )),
                  ),
                  // SizedBox(
                  //   height: 50,
                  // )
                ],
              ),
            ))
            :
        SizedBox(
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //------------------------
              // APPBAR
              //------------------------
              Container(

                width: size.width * 0.95,
                padding:  EdgeInsets.all(8),
                child: Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.06,
                    ),
                    //------------------------
                    // SCREEN HEADING
                    //------------------------
                    Text(
                      'Journal',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Spacer(),
                    //------------------------
                    // Search Button Container
                    //------------------------
                    InkWell(
                      onTap: () {
                        //TODO: Search query for journal using heading
                      },
                      child: Container(
                        height: size.height * 0.037,
                        width: size.height * 0.037,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        //------------------------
                        // SEARCH SVG
                        //------------------------
                        child: Icon(
                          Icons.search_rounded,
                          size: 28,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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

  // void saveToDatabase() async {
  //   var subStr = _.uuid.v4();
  //   var id = subStr.substring(0, subStr.length - 10);
  //
  //   if (_.headingController!.text.isEmpty) {
  //     displaySnackBar('Heading is empty', Get.context!);
  //   } else if (_.bodyController.text.isEmpty) {
  //     displaySnackBar('Body is empty', Get.context!);
  //   } else {
  //     showLoaderDialog(Get.context!);
  //
  //     ///If moodSvgUrl is empty
  //     if (widget.moodSvgUrl.isEmpty) {
  //       await journalRef!
  //           .doc(auth!.currentUser!.uid)
  //           .collection('journalHistory')
  //           .doc(id)
  //           .set({
  //         userJID: id,
  //         userJHeading: _.headingController!.text,
  //         userJBody: _.bodyController.text,
  //         "clientID": auth!.currentUser!.uid,
  //         "consultantID": "",
  //         userJMood: '',
  //         userJDate: DateTime.now().toUtc().millisecondsSinceEpoch
  //       }).then((value) {
  //         displaySnackBar('Saved to journal', context);
  //         sendEmail();
  //       }).catchError((e) {
  //         print("Save error: ${e.toString()}");
  //       });
  //     }
  //
  //     ///If moodSvgUrl is not empty
  //     ///SAVE ICON TO FIREBASE STORAGE BEFORE SAVING DATA TO DATABASE
  //     else {
  //       File file = await getImageFileFromAssets(widget.moodSvgUrl);
  //       String fileName = file.path.split('/').last;
  //       Reference ref =
  //           FirebaseStorage.instance.ref().child('moodIcons/$fileName');
  //       UploadTask uploadTask = ref.putFile(file);
  //
  //       await uploadTask.whenComplete(() async {
  //         String downloadUrl;
  //         downloadUrl = await ref.getDownloadURL();
  //         setState(() {
  //           journalRef!
  //               .doc(auth!.currentUser!.uid)
  //               .collection('journalHistory')
  //               .doc(id)
  //               .set({
  //             userJID: id,
  //             userJHeading: _.headingController!.text,
  //             userJBody: _.bodyController.text,
  //             userJMood: downloadUrl,
  //             userJDate: DateTime.now().toUtc().millisecondsSinceEpoch
  //           }).then((value) {
  //             displaySnackBar('Saved to journal', context);
  //             sendEmail();
  //           }).catchError((e) {
  //             print('Save Error: ${e.toString()}');
  //           });
  //         });
  //       });
  //     }
  //     _.headingController!.clear();
  //     _.bodyController.clear();
  //     Navigator.of(context).pop();
  //   }
  // }

  void sendEmail() {
    //..
  }

  // Future<void> _cardOptionsDialog(JournalModel _model, BuildContext ctx,
  //     JournalHistoryController controller) async {
  //   return Get.dialog(AlertDialog(
  //     elevation: 0,
  //     backgroundColor: Colors.transparent,
  //     insetPadding: EdgeInsets.zero,
  //     contentPadding: EdgeInsets.zero,
  //     content: SingleChildScrollView(
  //       child: ListBody(
  //         children: <Widget>[
  //           ListTile(
  //             onTap: () async {
  //               Navigator.pop(ctx);
  //               showLoaderDialog(ctx);
  //               await journalRef!
  //                   .doc(auth!.currentUser!.uid)
  //                   .collection('journalHistory')
  //                   .doc(_model.id)
  //                   .delete();
  //
  //               controller.journalList.remove(_model);
  //
  //               Navigator.pop(ctx);
  //             },
  //             visualDensity: VisualDensity.compact,
  //             contentPadding: EdgeInsets.zero,
  //             dense: true,
  //             horizontalTitleGap: 0,
  //             title: Container(
  //               color: Colors.white,
  //               padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  //               child: Text(
  //                 'Delete',
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(fontSize: displayWidth(ctx) * 0.05),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   ));
  //   // .whenComplete(() {
  //   //   _isDefault = false;
  //
  //   //   print(_isDefault);
  //   // });
  // }
}
