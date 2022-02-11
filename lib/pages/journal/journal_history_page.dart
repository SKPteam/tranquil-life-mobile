// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/journal_controller.dart';
import 'package:tranquil_life/helpers/constants.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';
import 'package:tranquil_life/pages/journal/selected_note_page.dart';
import 'package:tranquil_life/routes/app_pages.dart';

class JournalHistoryView extends StatelessWidget {
   JournalHistoryView({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final JournalHistoryController _ = Get.put(JournalHistoryController());

    return ResponsiveSafeArea(
      responsiveBuilder: (context, size) => Scaffold(
          backgroundColor: kLightBackgroundColor,
          body: SizedBox(
            width: size.width,
            child: Column(

              children: [
                //------------------------
                // APPBAR
                //------------------------
                Container(
                  width: size.width * 0.95,
                  padding:  EdgeInsets.all(8),
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
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (context) =>
                                SelectedNoteView(),
                          ));
                        },
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          //------------------------
                          // SEARCH SVG
                          //------------------------
                          child: Icon(
                            Icons.search_rounded,
                            //size: size.width * 0.06,
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
                // Expanded(
                //   //------------------------
                //   // STAGGERED LIST VIEW
                //   //------------------------
                //   child: Obx(() {
                //     return _.journalsLoaded.value
                //         ? StaggeredGridView.countBuilder(
                //       //divide the horizontal axis into 6 parts
                //       crossAxisCount: 6,
                //       controller: _.scrollController,
                //       padding:  EdgeInsets.symmetric(
                //           vertical: 30, horizontal: 18),
                //       physics:  BouncingScrollPhysics(),
                //       itemCount: _.moreJournalsAvailableInDatabase.value
                //           ? _.journalList.length + 1
                //           : _.journalList.length,
                //       itemBuilder: (BuildContext context, int index) {
                //         if (index == _.journalList.length) {
                //           return  SizedBox(
                //             height: 60,
                //             child: Center(
                //               child: CircularProgressIndicator(),
                //             ),
                //           );
                //         }
                //         String heading = _.journalList[index].heading;
                //         print(_.journalList[index].moodSvgUrl);
                //         bool isThree = (index + 1) % 3 == 0;
                //         //------------------------
                //         // STACK FOR EMOJI AND JOURNAL
                //         //------------------------
                //         return Stack(
                //           clipBehavior: Clip.none,
                //           children: [
                //             //------------------------
                //             // CONTAINER FOR JOURNAL
                //             //------------------------
                //             InkWell(
                //                 onLongPress: () {
                //                   _cardOptionsDialog(
                //                       _.journalList[index], context, _);
                //                 },
                //                 onTap: () {
                //                   Navigator.of(context)
                //                       .push(MaterialPageRoute(
                //                     builder: (context) =>
                //                         SelectedNoteView(
                //                           journalModel: _.journalList[index],
                //                         ),
                //                   ));
                //                 },
                //                 child: Container(
                //                   padding: isThree
                //                       ?  EdgeInsets.all(26)
                //                       :  EdgeInsets.symmetric(
                //                       vertical: 28, horizontal: 18),
                //                   decoration: BoxDecoration(
                //                     color: _.getColor(
                //                         _.journalList[index].heading),
                //                     borderRadius:
                //                     BorderRadius.circular(8),
                //                   ),
                //                   //------------------------
                //                   // COLUMN FOR HEADING AND DATE
                //                   //------------------------
                //                   child: Column(
                //                     crossAxisAlignment:
                //                     CrossAxisAlignment.start,
                //                     mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                     children: [
                //                       //------------------------
                //                       // HEADING CONTAINER
                //                       //------------------------
                //                       Expanded(
                //                         child: Text(
                //                           //if the string length is greater than 60 characters then cut it to 58 characters
                //                           //and add "..." to the end of the heading in
                //                           //journal containers of half width
                //                           heading.length > 60
                //                               ? isThree
                //                               ? heading
                //                               : heading.substring(
                //                               0, 58) +
                //                               '...'
                //                               : heading,
                //                           style:  TextStyle(
                //                             color: Colors.white,
                //                             fontSize: 20,
                //                             fontWeight: FontWeight.w500,
                //                           ),
                //                         ),
                //                       ),
                //                       //------------------------
                //                       // DATE
                //                       //------------------------
                //                       Align(
                //                         // if it is the every 3rd element of the journal
                //                         //  list then align the date to the right side
                //                         alignment: (index + 1) % 3 == 0
                //                             ? Alignment.centerRight
                //                             : Alignment.centerLeft,
                //                         child: Text(
                //                           TimeManipulativeHelperController
                //                               .instance
                //                               .convertTimeToMDY(
                //                             _.journalList[index]
                //                                 .timestamp,
                //                           ),
                //                           style:  TextStyle(
                //                             color: Colors.white60,
                //                             fontSize: 17,
                //                             fontWeight: FontWeight.w400,
                //                           ),
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 )),
                //             //------------------------
                //             // MOOD CONTAINER
                //             //------------------------
                //             //if there is a mood attached to the journal element then the mood
                //             //container in the topRight corner will be created
                //             if (_
                //                 .journalList[index].moodSvgUrl.isNotEmpty)
                //               Positioned(
                //                 top: -8,
                //                 right: -6,
                //                 child: Container(
                //                   width: 40,
                //                   height: 40,
                //                   decoration: BoxDecoration(
                //                     borderRadius:
                //                     BorderRadius.circular(6),
                //                     color: Colors.black,
                //                   ),
                //                   child: Center(
                //                     child: Image.network(
                //                       _.journalList[index].moodSvgUrl,
                //                       fit: BoxFit.contain,
                //                       height: 30,
                //                       width: 30,
                //                     ),
                //                   ),
                //                 ),
                //               )
                //           ],
                //         );
                //       },
                //       staggeredTileBuilder: (int index) {
                //         bool isLoader = index == _.journalList.length;
                //         bool isThree = true;
                //         double crossCount = 1;
                //         if (!isLoader) {
                //           var headingLength = _.journalList[index].heading
                //               .length; //length of heading of journal
                //
                //           isThree = (index + 1) % 3 ==
                //               0; //is it the 3rd element
                //
                //           //calculation crossAxis count i.e vertical height of the containers
                //           //based on the number of characters in the heading of journal
                //           //and also based on whether it's the very 3rd element with full width
                //           //container
                //           crossCount = (index + 1) % 3 == 1
                //               ? headingLength < 20
                //               ? isThree
                //               ? 0.8
                //               : 2.3
                //               : headingLength < 30
                //               ? isThree
                //               ? 0.9
                //               : 2.8
                //               : headingLength < 40
                //               ? isThree
                //               ? 1.0
                //               : 3.2
                //               : headingLength < 50
                //               ? isThree
                //               ? 1.1
                //               : 3.6
                //               : headingLength < 60
                //               ? isThree
                //               ? 1.2
                //               : 4
                //               : isThree
                //               ? 1.3
                //               : 4
                //               : _.prevCrossCount!;
                //
                //           //if it's every 1st journal of 3 journals then it's vertical height is to be stored to directly use in the
                //           //2nd jounral of 3 journals i.e both the half width containers will have same height no matter what
                //           if ((index + 1) % 3 == 1) {
                //             _.prevCrossCount = crossCount;
                //           }
                //         }
                //         return StaggeredTile.count(
                //           isThree ? 6 : 3,
                //           crossCount,
                //         );
                //         //returning axis count as full width or half width as the horizontal axis is divided into 6 parts
                //         //and then the cross axis count that is vertical height is also passed from the previous variable
                //       },
                //       //horizontal spacing between elements
                //       mainAxisSpacing: 16,
                //       //vertical spacing between elements
                //       crossAxisSpacing: 13,
                //     )
                //         :  Center(
                //       child: CircularProgressIndicator(),
                //     );
                //   }),
                // )
              ],
            ),
          )),
    );
  }

}