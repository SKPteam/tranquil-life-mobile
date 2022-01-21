// ignore_for_file: must_be_immutable, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_app/app/getx_controllers/dashboard_controller.dart';
import 'package:tranquil_app/app/getx_controllers/selected_note_controller.dart';
import 'package:tranquil_app/app/helperControllers/timeFunctionsController.dart';
import 'package:tranquil_app/app/models/journal_model.dart';
import 'package:tranquil_app/app/utils/constants.dart';
import 'package:tranquil_app/app/utils/sizes_helpers.dart';
import 'package:tranquil_app/app/utils/snackbar.dart';
import 'package:tranquil_app/main.dart';


class SelectedNoteView extends StatelessWidget {
  final JournalModel journalModel;

  SelectedNoteView({Key? key, required this.journalModel}) : super(key: key);

  final SelectedNoteController _ = Get.put(SelectedNoteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //------------------------
            // APPBAR
            //------------------------
            Center(
              child: Container(
                width: displayWidth(context) * 0.95,
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //------------------------
                    // BACK BUTTON
                    //------------------------
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back, color: kPrimaryColor),
                        ),
                      ),
                    ),
                    const Spacer(),
                    DashboardController.to.userType!.value == client
                    ?
                    InkWell(
                        onTap: () {
                          displayConsultantList(context);
                        },
                        child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            //------------------------
                            // Edit SVG
                            //------------------------
                            child: const Icon(
                              Icons.share,
                              color: kPrimaryColor,
                            )
                        )
                    ) : SizedBox()

                  ],
                ),
              ),
            ),
            SizedBox(
              height: displayHeight(context) * 0.03,
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    //------------------------
                    // HEADING OF THE JOURNAL CONTAINER
                    //------------------------
                    Container(
                      padding:
                      const EdgeInsets.only(left: 24, right: 40, top: 10),
                      child: Text(
                        journalModel.heading,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    //------------------------
                    // DATE AND EMOJI CONTAINER
                    //------------------------
                    Container(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            TimeManipulativeHelperController.instance
                                .convertTimeToMDY(
                              journalModel.timestamp,
                            ),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          //------------------------
                          // MOOD CONTAINER
                          //------------------------
                          //if there is a mood attached to the journal element then the mood
                          //container in the topRight corner will be created
                          if (journalModel.moodSvgUrl.isNotEmpty)
                            Center(
                              child: Image.network(
                                journalModel.moodSvgUrl,
                                fit: BoxFit.contain,
                                height: 60,
                                width: 60,
                              ),
                            ),
                        ],
                      ),
                    ),
                    //------------------------
                    // CONTENT OF THE JOURNAL ENTRY
                    //------------------------
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      child: Text(
                        journalModel.body,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void displayConsultantList(BuildContext context) {
    Get.bottomSheet(
        Container(
            color: Colors.white,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 16.0),
                  child: Text("Share this with your consultant",
                    style: TextStyle(fontSize: 16.0, color: kPrimaryDarkColor),),
                ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _.consultantList.length,
                    itemBuilder: (context, index) =>
                        InkWell(
                          onTap: (){
                            Get.back();
                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text("Share with ${_.consultantList[index].firstName} ${ _.consultantList[index].lastName}"),
                                    actions: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              sendNoteToConsultant(
                                                  journalModel.heading,
                                                  journalModel.body,
                                                  journalModel.id,
                                                  journalModel.moodSvgUrl,
                                                  _.consultantList[index].uid,
                                                  _.consultantList[index].firstName,
                                                  _.consultantList[index].lastName,
                                                  context
                                              );

                                            },
                                            child: const Text("Yes",
                                              style: TextStyle(
                                                  color: kPrimaryDarkColor,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: ()=> Get.back(),
                                            child: const Text("No",
                                              style: TextStyle(
                                                  color: kPrimaryDarkColor,
                                                  fontWeight: FontWeight.bold
                                              ),),
                                          )
                                        ],
                                      )
                                    ],
                                  );
                                });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //image of consultant
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(width: 2.0, color: kSecondaryColor)
                                  ),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: _.consultantList[index]
                                          .avatarUrl.isNotEmpty ?
                                      Image.network(
                                          _.consultantList[index].avatarUrl,
                                          fit: BoxFit.cover, width: 55, height: 55
                                      ) :
                                      Image.asset(
                                        'assets/images/avatar_img1.png',
                                        fit: BoxFit.cover,
                                        width: 55,
                                        height: 55,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text("${_.consultantList[index].firstName} ${_.consultantList[index].lastName}",
                                  style: const TextStyle(
                                      fontSize: 18.0
                                  ),)
                              ],
                            ),
                          ),
                        ),
                  ),
                ),
              ],
            )
        )
    );
  }

  void sendNoteToConsultant(
      String heading, String body,
      String id, String moodSvgUrl,
      String uid, String firstName,
      String lastName,
      BuildContext context)
  async {
    var subStr = _.uuid.v4();
    var id = subStr.substring(0, subStr.length - 10);

    await journalRef!.doc(uid)
        .collection("journalHistory")
        .doc(id)
        .set({
      userJID: id,
      "clientUserID": auth!.currentUser!.uid,
      userJHeading: heading,
      userJBody: body,
      userJMood: moodSvgUrl,
      userJDate: DateTime.now().toUtc().millisecondsSinceEpoch
    }).then((value) => Get.back());

    displaySnackBar("Sent to $firstName $lastName 😀!", context);

    sendEmail();
  }

  void sendEmail() {
    print("Sent email to consultant and client");
  }


}