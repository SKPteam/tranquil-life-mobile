// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:get/get.dart';
import 'package:tranquil_app/app/getx_controllers/journal_history_controller.dart';
import 'package:tranquil_app/app/helperControllers/timeFunctionsController.dart';
import 'package:tranquil_app/app/models/journal_model.dart';
import 'package:tranquil_app/app/modules/journal/selected_note_view.dart';
import 'package:tranquil_app/app/utils/constants.dart';
import 'package:tranquil_app/app/utils/sizes_helpers.dart';

import '../../../main.dart';


class JournalHistoryView extends StatelessWidget {
  const JournalHistoryView({Key? key}) : super(key: key);

  Future<void> cardOptionsDialog(JournalModel _model, BuildContext ctx,
      JournalHistoryController controller) async {
    return Get.dialog(
      Obx(
        () => AlertDialog(
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
        ),
      ),
    );
    // .whenComplete(() {
    //   _isDefault = false;

    //   print(_isDefault);
    // });
  }

  @override
  Widget build(BuildContext context) {
    final JournalHistoryController _ = Get.put(JournalHistoryController());

    return Scaffold(
        backgroundColor: kLightBackgroundColor,
        body: SafeArea(
          child: SizedBox(
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
                      //------------------------
                      // BACK BUTTON
                      //------------------------
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back, color: kPrimaryColor),
                      ),
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
                    return _.journalsLoaded.value
                        ? StaggeredGridView.countBuilder(
                            //divide the horizontal axis into 6 parts
                            crossAxisCount: 6,
                            controller: _.scrollController,
                            padding: const EdgeInsets.symmetric(
                                vertical: 30, horizontal: 18),
                            physics: const BouncingScrollPhysics(),
                            itemCount: _.moreJournalsAvailableInDatabase.value
                                ? _.journalList.length + 1
                                : _.journalList.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == _.journalList.length) {
                                return const SizedBox(
                                  height: 60,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              String heading = _.journalList[index].heading;
                              print(_.journalList[index].moodSvgUrl);
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
                                            _.journalList[index], context, _);
                                      },
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              SelectedNoteView(
                                            journalModel: _.journalList[index],
                                          ),
                                        ));
                                      },
                                      child: Container(
                                        padding: isThree
                                            ? const EdgeInsets.all(26)
                                            : const EdgeInsets.symmetric(
                                                vertical: 28, horizontal: 18),
                                        decoration: BoxDecoration(
                                          color: _.getColor(
                                              _.journalList[index].heading),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        //------------------------
                                        // COLUMN FOR HEADING AND DATE
                                        //------------------------
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            //------------------------
                                            // HEADING CONTAINER
                                            //------------------------
                                            Expanded(
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
                                            //------------------------
                                            // DATE
                                            //------------------------
                                            Align(
                                              // if it is the every 3rd element of the journal
                                              //  list then align the date to the right side
                                              alignment: (index + 1) % 3 == 0
                                                  ? Alignment.centerRight
                                                  : Alignment.centerLeft,
                                              child: Text(
                                                TimeManipulativeHelperController
                                                    .instance
                                                    .convertTimeToMDY(
                                                  _.journalList[index]
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
                                  if (_
                                      .journalList[index].moodSvgUrl.isNotEmpty)
                                    Positioned(
                                      top: -8,
                                      right: -6,
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
                                            _.journalList[index].moodSvgUrl,
                                            fit: BoxFit.contain,
                                            height: 30,
                                            width: 30,
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              );
                            },
                            staggeredTileBuilder: (int index) {
                              bool isLoader = index == _.journalList.length;
                              bool isThree = true;
                              double crossCount = 1;
                              if (!isLoader) {
                                var headingLength = _.journalList[index].heading
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
                                    : _.prevCrossCount!;

                                //if it's every 1st journal of 3 journals then it's vertical height is to be stored to directly use in the
                                //2nd jounral of 3 journals i.e both the half width containers will have same height no matter what
                                if ((index + 1) % 3 == 1) {
                                  _.prevCrossCount = crossCount;
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
          ),
        ));
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
