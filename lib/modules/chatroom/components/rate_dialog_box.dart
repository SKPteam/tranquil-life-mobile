// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:tranquil_app/app/utils/constants.dart';
import 'package:tranquil_app/app/utils/snackbar.dart';

import '../../../../main.dart';

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
    queryFavList();
  }

  CollectionReference testimonialsRef =
      FirebaseFirestore.instance.collection('testimonials');
  CollectionReference favConsultantRef =
      FirebaseFirestore.instance.collection('favouriteConsultants');
  late QuerySnapshot _snapshot;

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
                        var subStr = uuid.v4();
                        var id = subStr.substring(0, subStr.length - 10);

                        if (addedToFavList) {
                          //..
                        } else {
                          favDoc.then((_snapshot) {
                            if (_snapshot.docs.length == 1) {
                              displaySnackBar(
                                  '${widget.consultantName} has already been to your favourite consultants list',
                                  context);
                            } else if (_snapshot.docs.length < 1) {
                              favConsultantRef.doc(id).set({
                                'id': id,
                                'consultantID': widget.consultantID,
                                'clientID': auth!.currentUser!.uid
                              }).then((value) {
                                setState(() {
                                  addedToFavList = !addedToFavList;
                                });
                                displaySnackBar(
                                    'added to your favourite consultants list',
                                    context);
                              });
                            } else {
                              displaySnackBar(
                                  '${widget.consultantName} appears more than once in your favourite consultants list. Please delete one',
                                  context);
                            }
                          });
                        }
                      },
                      child: Icon(
                        addedToFavList ? Icons.star : Icons.star_border,
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

                  var subStr = uuid.v4();
                  var id = subStr.substring(0, subStr.length - 10);
                  int? ratingVal;

                  await accountSettingsRef!
                      .child(widget.consultantID)
                      .child('profile')
                      .once()
                      .then((snapshot) {
                    if (snapshot.value != null) {
                      ratingVal = snapshot.value['rating'];
                    }
                  });

                  ratingVal ??= 0;

                  await accountSettingsRef!
                      .child(widget.consultantID)
                      .child('profile')
                      .update({
                    'rating': ((rating.value + ratingVal!) / 2).round(),
                  }).then((value) {
                    if (ratingTEC.text.isNotEmpty) {
                      testimonialsRef.doc(id).set({
                        'id': id,
                        'consultantID': widget.consultantID,
                        'clientID': auth!.currentUser!.uid,
                        'comment': ratingTEC.text,
                        'timestamp':
                            DateTime.now().toUtc().millisecondsSinceEpoch
                      });
                    }
                  });
                  scheduledMeetingsRef!.doc(widget.currentMeetingID).delete();
                  sendFeedback();
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

  void queryFavList() {
    setState(() {
      favDoc = favConsultantRef
          .where('consultantID', isEqualTo: widget.consultantID)
          .where('clientID', isEqualTo: auth!.currentUser!.uid)
          .limit(1)
          .get();
    });

    favDoc.then((_snapshot) {
      if (_snapshot.docs.length == 1) {
        setState(() {
          addedToFavList = true;
        });
      }
    });
  }

  void sendFeedback() {
    sendEmailToCreator();
    sendEmailToConsultant();
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
  }

  void sendEmailToCreator() {
    String email = 'skiplab.innovation@gmail.com';
    String password = 'aaaaaa@123';

    //user for your own domain
    final smtpServer = gmail(email, password);

    final message = Message()
      ..from = Address(email, 'Resillia')
      ..recipients.add('${auth!.currentUser!.email}')
      //..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      //..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'Meeting Has Ended'
      ..html = ''' 
     <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <meta name="x-apple-disable-message-reformatting">
  <title></title>
  <style>
    table, td, div, h1, p {
      font-family: Arial, sans-serif;
    }
    @media screen and (max-width: 530px) {
      .unsub {
        display: block;
        padding: 8px;
        margin-top: 14px;
        border-radius: 6px;
        background-color: #555555;
        text-decoration: none !important;
        font-weight: bold;
      }
      .col-lge {
        max-width: 100% !important;
      }
    }
    @media screen and (min-width: 531px) {
      .col-sml {
        max-width: 27% !important;
      }
      .col-lge {
        max-width: 73% !important;
      }
    }
  </style>
</head>
<body style="margin:0;padding:0;word-spacing:normal;background-color:#939297;">
  <div role="article" aria-roledescription="email" lang="en" style="text-size-adjust:100%;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#939297;">
    <table role="presentation" style="width:100%;border:none;border-spacing:0;">
      <tr>
        <td align="center" style="padding:0;">
          <table role="presentation" style="width:94%;max-width:600px;border:none;border-spacing:0;text-align:left;font-family:Arial,sans-serif;font-size:16px;line-height:22px;color:#363636;">
            <tr>
              <td style="padding:40px 30px 30px 30px;text-align:center;font-size:24px;font-weight:bold;">
                <a href="http://www.example.com/" style="text-decoration:none;"><img src="https://assets.codepen.io/210284/logo.png" width="165" alt="Resillia" style="width:80%;max-width:165px;height:auto;border:none;text-decoration:none;color:#ffffff;"></a>
              </td>
            </tr>
            <tr>
              <td style="padding:30px;background-color:#ffffff;">
                <h1 style="margin-top:0;margin-bottom:16px;font-size:26px;line-height:32px;font-weight:bold;letter-spacing:-0.02em;">Hello ${widget.creatorUsername}!</h1>
                <p style="margin:0;">You just ended a meeting with <strong>${widget.consultantName}</strong> at 
                    ${timeFormat.format(DateTime.now().toUtc())} UTC ${DateTime.now().toUtc().timeZoneOffset.isNegative ? '' : '+'}${_printDuration(DateTime.now().toUtc().timeZoneOffset)}, ${dateFormat.format(DateTime.now().toUtc())}</p>
              </td>
            </tr>
            <tr>
              <td style="padding:0;font-size:24px;line-height:28px;font-weight:bold;">
                <a href="http://www.example.com/" style="text-decoration:none;">
                <img src="https://firebasestorage.googleapis.com/v0/b/mindscapeproject-ef43d.appspot.com/o/emailTemplates%2Fbye-vector.png?alt=media&token=0bdf91ad-17b1-48b9-baf5-863bdc748c5a" 
                width="600" alt="" style="width:100%;height:auto;display:block;border:none;text-decoration:none;color:#363636;">
                </a>
              </td>
            </tr>
            <tr>
              <td style="padding:35px 30px 11px 30px;font-size:0;background-color:#ffffff;border-bottom:1px solid #f0f0f5;border-color:rgba(201,201,207,.35);">
              <div style="text-align:center">
                <div class="col-lge" style="display:inline-block;width:100%;max-width:395px;vertical-align:top;padding-bottom:20px;font-family:Arial,sans-serif;font-size:16px;line-height:22px;color:#363636;">
                      <p style="margin:0;">
                          <a href="https://example.com/" style="background: #4CAF50; text-decoration: none; padding: 10px 25px; color: #ffffff; border-radius: 4px; display:inline-block; mso-padding-alt:0;text-underline-color:#ff3884">
                              <span style="mso-text-raise:10pt;font-weight:bold;">Resillia
                              </span>
                          </a>
                      </p>
                  </div>
              </div>
                
              </td>  
            </tr>
            <tr>
              <td style="padding:30px;text-align:center;font-size:12px;background-color:#404040;color:#cccccc;">
                <p style="margin:0 0 8px 0;">
                <a href="http://www.facebook.com/" style="text-decoration:none;"><img src="https://assets.codepen.io/210284/facebook_1.png" width="40" height="40" alt="f" style="display:inline-block;color:#cccccc;"></a> 
                <a href="http://www.twitter.com/" style="text-decoration:none;"><img src="https://assets.codepen.io/210284/twitter_1.png" width="40" height="40" alt="t" style="display:inline-block;color:#cccccc;"></a></p>
                <p style="margin:0;font-size:14px;line-height:20px;">&reg; Skiplab Innovation, Nigeria 2021<br><a class="unsub" href="http://www.example.com/" style="color:#cccccc;text-decoration:underline;">Unsubscribe instantly</a></p>
              </td>
            </tr>
          </table>
 
 
        </td>
      </tr>
    </table>
  </div>
</body>
</html> 
      ''';

    try {
      final sendReport = send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  void sendEmailToConsultant() {
    String email = 'skiplab.innovation@gmail.com';
    String password = 'aaaaaa@123';

    //user for your own domain
    final smtpServer = gmail(email, password);

    final message = Message()
      ..from = Address(email, 'Resillia')
      ..recipients.add('${widget.consultantEmail}')
      //..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      //..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'Meeting Has Ended'
      ..html = ''' 
      <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <meta name="x-apple-disable-message-reformatting">
  <title></title>
  <style>
    table, td, div, h1, p {
      font-family: Arial, sans-serif;
    }
    @media screen and (max-width: 530px) {
      .unsub {
        display: block;
        padding: 8px;
        margin-top: 14px;
        border-radius: 6px;
        background-color: #555555;
        text-decoration: none !important;
        font-weight: bold;
      }
      .col-lge {
        max-width: 100% !important;
      }
    }
    @media screen and (min-width: 531px) {
      .col-sml {
        max-width: 27% !important;
      }
      .col-lge {
        max-width: 73% !important;
      }
    }
  </style>
</head>
<body style="margin:0;padding:0;word-spacing:normal;background-color:#939297;">
  <div role="article" aria-roledescription="email" lang="en" style="text-size-adjust:100%;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#939297;">
    <table role="presentation" style="width:100%;border:none;border-spacing:0;">
      <tr>
        <td align="center" style="padding:0;">
          <table role="presentation" style="width:94%;max-width:600px;border:none;border-spacing:0;text-align:left;font-family:Arial,sans-serif;font-size:16px;line-height:22px;color:#363636;">
            <tr>
              <td style="padding:40px 30px 30px 30px;text-align:center;font-size:24px;font-weight:bold;">
                <a href="http://www.example.com/" style="text-decoration:none;"><img src="https://assets.codepen.io/210284/logo.png" width="165" alt="Resillia" style="width:80%;max-width:165px;height:auto;border:none;text-decoration:none;color:#ffffff;"></a>
              </td>
            </tr>
            <tr>
              <td style="padding:30px;background-color:#ffffff;">
                <h1 style="margin-top:0;margin-bottom:16px;font-size:26px;line-height:32px;font-weight:bold;letter-spacing:-0.02em;">Hello ${widget.consultantName}!</h1>
                <p style="margin:0;"><strong>${widget.creatorUsername}</strong> just ended a meeting with you at
                      ${timeFormat.format(DateTime.now().toUtc())} UTC ${DateTime.now().toUtc().timeZoneOffset.isNegative ? '' : '+'}${_printDuration(DateTime.now().toUtc().timeZoneOffset)}, ${dateFormat.format(DateTime.now().toUtc())}</p>
              </td>
            </tr>
            <tr>
              <td style="padding:0;font-size:24px;line-height:28px;font-weight:bold;">
                <a href="http://www.example.com/" style="text-decoration:none;">
                <img src="https://firebasestorage.googleapis.com/v0/b/mindscapeproject-ef43d.appspot.com/o/emailTemplates%2Fbye-vector.png?alt=media&token=0bdf91ad-17b1-48b9-baf5-863bdc748c5a" 
                width="600" alt="" style="width:100%;height:auto;display:block;border:none;text-decoration:none;color:#363636;">
                </a>
              </td>
            </tr>
            <tr>
              <td style="padding:35px 30px 11px 30px;font-size:0;background-color:#ffffff;border-bottom:1px solid #f0f0f5;border-color:rgba(201,201,207,.35);">
              <div style="text-align:center">
                <div class="col-lge" style="display:inline-block;width:100%;max-width:395px;vertical-align:top;padding-bottom:20px;font-family:Arial,sans-serif;font-size:16px;line-height:22px;color:#363636;">
                      <p style="margin:0;">
                          <a href="https://example.com/" style="background: #4CAF50; text-decoration: none; padding: 10px 25px; color: #ffffff; border-radius: 4px; display:inline-block; mso-padding-alt:0;text-underline-color:#ff3884">
                              <span style="mso-text-raise:10pt;font-weight:bold;">Resillia
                              </span>
                          </a>
                      </p>
                  </div>
              </div>
                
              </td>  
            </tr>
            <tr>
              <td style="padding:30px;text-align:center;font-size:12px;background-color:#404040;color:#cccccc;">
                <p style="margin:0 0 8px 0;">
                <a href="http://www.facebook.com/" style="text-decoration:none;"><img src="https://assets.codepen.io/210284/facebook_1.png" width="40" height="40" alt="f" style="display:inline-block;color:#cccccc;"></a> 
                <a href="http://www.twitter.com/" style="text-decoration:none;"><img src="https://assets.codepen.io/210284/twitter_1.png" width="40" height="40" alt="t" style="display:inline-block;color:#cccccc;"></a></p>
                <p style="margin:0;font-size:14px;line-height:20px;">&reg; Skiplab Innovation, Nigeria 2021<br><a class="unsub" href="http://www.example.com/" style="color:#cccccc;text-decoration:underline;">Unsubscribe instantly</a></p>
              </td>
            </tr>
          </table>
 
        </td>
      </tr>
    </table>
  </div>
</body>
</html>
      ''';

    try {
      final sendReport = send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
