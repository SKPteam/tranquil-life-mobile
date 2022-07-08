// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tranquil_life/general_widgets/custom_snackbar.dart';

class CustomRatingDialogBox extends StatefulWidget {
  final void Function()? onpressed;
  final String consultantName;
  final String consultantEmail;
  final String consultantID;
  final String creatorUsername;
  final String currentMeetingID;

  CustomRatingDialogBox(
      {Key? key,
        this.onpressed,
        required this.consultantName,
        required this.consultantEmail,
        required this.consultantID,
        required this.creatorUsername,
        required this.currentMeetingID})
      : super(key: key);

  @override
  _CustomRatingDialogBoxState createState() => _CustomRatingDialogBoxState();
}

class _CustomRatingDialogBoxState extends State<CustomRatingDialogBox> {
  ValueNotifier<int> rating = ValueNotifier(0);
  final TextEditingController ratingTEC = TextEditingController();
  late Size size = MediaQuery.of(context).size;
  changeRating(int value) async {
    rating.value = value;
    // await Future.delayed(Duration(milliseconds: 300));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }


  var favDoc;

  bool addedToFavList = false;

  final dateFormat = DateFormat('dd-MM-yyyy');
  final timeFormat = DateFormat('kk:mm');

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.greenAccent[100],
        ),
        height: 450,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(
              flex: 4,
            ),
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: size.width * 0.25,
                      backgroundColor: Colors.white54,
                      child: Center(
                        child: CircleAvatar(
                          radius: size.width * 0.17,
                          backgroundColor: Colors.white70,
                          child: CircleAvatar(
                            radius: size.width * 0.1,
                            backgroundImage:
                            const AssetImage('assets/images/avatar_img1.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    child: SizedBox(
                      width: size.width * 0.8,
                      child: Center(
                        child: Text(
                          'Dr. Charles Richard',
                          style: TextStyle(
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: size.width - size.width * 0.8,
                    top: 10,
                    child: GestureDetector(
                      onTap: () {


                      },
                      child: Icon(
                        addedToFavList ? Icons.star : Icons.person_add_alt_1,
                        size: 35,
                        color: Colors.green[800],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Spacer(
              flex: 2,
            ),
            SizedBox(
              child: Center(
                  child: Text(
                    'Kindly rate your consultation with Dr. Charles Richard',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.green[600],
                      fontSize: 14,
                    ),
                  )),
              width: size.width * 0.6,
            ),
            Spacer(
              flex: 2,
            ),
            SizedBox(
              width: size.width * 0.6,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                child: rating.value == 0
                    ? ValueListenableBuilder(
                  valueListenable: rating,
                  builder: (context, value, child) => ratingBox(),
                )
                    : ratingTextBox(),
              ),
            ),
            if (rating.value == 0)
              const Spacer(
                flex: 8,
              ),
            if (rating.value > 0) ...[
              const Spacer(
                flex: 2,
              ),
              Divider(
                thickness: 2,
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'YES',
                  style: TextStyle(
                      color: Colors.green[900],
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ],
        ),
      ),
    );
  }

  Widget ratingTextBox() => TextField(
    controller: ratingTEC,
    textAlign: TextAlign.center,
    decoration: const InputDecoration(
      hintText: 'Kindly give a feedback',

      hintStyle: TextStyle(
        color: Colors.grey,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 1,
      ),
      // floatingLabelBehavior: FloatingLabelBehavior.auto,
      // labelText: 'Feedback',
      // labelStyle: TextStyle(
      //   color: Colors.black,
      //   fontSize: 16,
      //   fontWeight: FontWeight.w400,
      //   letterSpacing: 1,
      // ),
    ),
  );

  Widget ratingBox() => SizedBox(
    width: size.width * 0.6,
    child: FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            child: Icon(
              rating.value > 0 ? Icons.star : Icons.star_border,
              size: 20,
              color: Colors.green[800],
            ),
            onTap: () {
              changeRating(1);
            },
          ),
          InkWell(
            child: Icon(rating.value > 1 ? Icons.star : Icons.star_border,
                size: 20, color: Colors.green[800]),
            onTap: () {
              changeRating(2);
            },
          ),
          InkWell(
            child: Icon(rating.value > 2 ? Icons.star : Icons.star_border,
                size: 20, color: Colors.green[800]),
            onTap: () {
              changeRating(3);
            },
          ),
          InkWell(
            child: Icon(rating.value > 3 ? Icons.star : Icons.star_border,
                size: 20, color: Colors.green[800]),
            onTap: () {
              changeRating(4);
            },
          ),
          InkWell(
            child: Icon(rating.value > 4 ? Icons.star : Icons.star_border,
                size: 20, color: Colors.green[800]),
            onTap: () {
              changeRating(5);
            },
          ),
        ],
      ),
    ),
  );





  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
  }



}