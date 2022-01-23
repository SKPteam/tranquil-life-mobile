// ignore_for_file: avoid_print

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:tranquil_app/app/getx_controllers/add_new_card_controller.dart';
import 'package:tranquil_app/app/getx_controllers/dashboard_controller.dart';
import 'package:tranquil_app/app/helperControllers/encryption_helper.dart';
import 'package:tranquil_app/app/utils/constants.dart';
import 'package:tranquil_app/app/utils/sizes_helpers.dart';
import 'package:tranquil_app/app/utils/snackbar.dart';

import '../../../main.dart';
import 'components/cardNumberInputFormatter.dart';
import 'components/expiryDateInputFormatter.dart';

class AddNewCard extends StatefulWidget {

  final void Function(int index) reloadWalletPage;

  const AddNewCard({Key? key, required this.reloadWalletPage}) : super(key: key);

  @override
  _AddNewCardState createState() => _AddNewCardState();
}

class _AddNewCardState extends State<AddNewCard> {

  final AddNewCardController _ = Get.find<AddNewCardController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        Scaffold(
          backgroundColor: kLightBackgroundColor,
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            title: const Text("Add New Card"),
            actions: [
              InkWell(
                onTap: () async{
                  if (_.cardNumController!.text == null ||
                      _.cardNumController!.text.isEmpty) {
                    displaySnackBar('empty', context);
                  } else if (_.cardOwnerController!.text == null ||
                      _.cardOwnerController!.text.isEmpty) {
                    displaySnackBar('empty', context);
                  } else if (_.cardType.value == null) {
                    displaySnackBar('empty', context);
                  } else if (_.cardExpDateController!.text == null) {
                    displaySnackBar('empty', context);
                  } else if (_.cardCvvController!.text == null) {
                    displaySnackBar('empty', context);
                  } else {
                    if (_.formKey.currentState!.validate()) {
                      await saveNewPaymentCard();
                      Get.back(result: true);
                      //Navigator.pop(context, true);
                    }
                  }
                },
                child: const Padding(
                    padding: EdgeInsets.only(right: 20, top: 16),
                    child: Text('Save',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ))
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              height: displayHeight(context),
              padding: const EdgeInsets.all(35),
              child: Form(
                key: _.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 180,
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(8.0)),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(_.cardNumController!.text == "Card Number"
                                ? ""
                                : _.cardNumController!.text.toString()
                              ,
                              style: const TextStyle(fontSize: 22, color: Colors.white),
                              textAlign: TextAlign.start,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('VALID \nTHRU',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: displayWidth(context) * 0.02)),
                                SizedBox(width: displayWidth(context) * 0.01),
                                Text(
                                    _.cardExpDateController! == null
                                        ? ''
                                        : _.cardExpDateController!.text.toString(),
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.white))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  child: Text(
                                    _.cardOwnerController! == null
                                        ? ''
                                        : _.cardOwnerController!.text.toString(),
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                const Spacer(),
                                SvgPicture.asset(
                                  _.cardType.value == null ? '' : _.cardType.value.toString(),
                                  color: Colors.white,
                                  height: 40.0,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton(
                                    hint: const Text(
                                      'Select card type',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    //value: _.selectedCardType,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _.selectedCardType = newValue.toString();
                                      });
                                    },
                                    items: _.cardTypes.map((e) {
                                      return DropdownMenuItem(
                                          value: e['name'],
                                          onTap: () {
                                            if (e['id'] == '0') {
                                              _.cardType.value = e['image'];
                                            } else if (e['id'] == '1') {
                                              _.cardType.value = e['image'];
                                            } else if (e['id'] == '2') {
                                              _.cardType.value = e['image'];
                                            } else if (e['id'] == '3') {
                                              _.cardType.value = e['image'];
                                            }
                                            _.cardTypeName.value = e['name'];
                                            print(_.cardTypeName.value);
                                          },
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                e['image'],
                                                width: displayWidth(context) * 0.08,
                                                color: kPrimaryDarkColor,
                                              ),
                                              SizedBox(
                                                width: displayWidth(context) * 0.06,
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(left: 10),
                                                child: Text(e['name']),
                                              )
                                            ],
                                          ));
                                    }).toList(),
                                  )
                              ),
                            ))
                      ],
                    ),
                    SizedBox(height: displayHeight(context) * 0.02),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: cardNumberFormField()
                    ),
                    SizedBox(height: displayHeight(context) * 0.02),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: cardOwnerFormField()
                    ),
                    SizedBox(height: displayHeight(context) * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: Container(
                              height: displayHeight(context) * 0.1,
                              width: displayWidth(context) * 0.22,
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(child: cardExpDateFormField()),
                                ],
                              )),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: SizedBox(
                            height: displayHeight(context) * 0.1,
                            width: displayWidth(context) * 0.30,
                            child: Column(
                              children: [
                                Expanded(child: cardCvvFormField()),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  saveNewPaymentCard() async{
    if (_.cardNumController!.text
        .split('')
        .reversed
        .join()
        .substring(0, 4)
        .contains(' ')) {
      setState(() {
        _.cardId.value = _.cardNumController!.text
            .split('')
            .reversed
            .join()
            .substring(0, 4)
            .replaceAll(' ', '?')
            .toString();
      });
    } else {
      _.cardId.value =
          _.cardNumController!.text.split('').reversed.join().substring(0, 4);
    }

    Map cardData = {
      'id': _.cardId.value,
      cardNumber: EncryptionHelper.handleEncryption(_.cardNumController!.text.trim()),
      cardOwner: EncryptionHelper.handleEncryption(_.cardOwnerController!.text.trim()),
      cardType: EncryptionHelper.handleEncryption(_.cardTypeName.value.trim()),
      cardExpiryDate: EncryptionHelper.handleEncryption(_.cardExpDateController!.text.trim()),
      cardCVV: EncryptionHelper.handleEncryption(_.cardCvvController!.text.trim()),
      defaultCard: false
    };

    DatabaseReference _paymentCardsReference =
    accountSettingsRef!.child(auth!.currentUser!.uid).child('paymentCards');
    await _paymentCardsReference.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        print('YES!!!');
        _paymentCardsReference.child(_.cardId.value).set(cardData);
      } else {
        print('NO!!!');
        accountSettingsRef!
            .child(auth!.currentUser!.uid)
            .child('paymentCards')
            .child(_.cardId.value)
            .set(cardData).then((value) => sendEmail());
      }
    });
  }

  String cardNumText = "";


  TextFormField cardNumberFormField() {
    return TextFormField(
      style: TextStyle(
          color: _.cardNumController!.text == "Card Number"
              ? Colors.grey
              : Colors.black
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Card Number can\'t be empty';
        } else if (_.cardValidator.validNumber(value.replaceAll(' ', ''))) {
          if (_.cardValidator
              .getTypeForIIN(value.replaceAll(' ', ''))
              .toLowerCase() ==
              _.selectedCardType.toLowerCase()) {
            return null;
          } else {
            return 'Card Type doesn\'t match the card Details';
          }
        } else {
          return 'Enter Valid Number';
        }
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(19),
        CardNumberInputFormatter()
      ],
      autofocus: false,
      focusNode: _.cardNumFocusNode,
      onChanged: (cardNumText) {
        setState(() {
          _.cardNumFocusNode!.requestFocus();
        });
      },
      controller: _.cardNumController!,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        hintText: "Card Number",
        hintStyle: TextStyle(
          fontSize: displayWidth(context) / 25,
          color: Colors.grey,
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: 20.0, horizontal: displayWidth(context) * 0.04),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  TextFormField cardOwnerFormField() {
    return TextFormField(
      style: const TextStyle(
          color: Colors.black
      ),
      autofocus: false,
      focusNode: _.cardOwnerFocusNode!,
      onChanged: (cardOwnerText) {
        setState(() {
          _.cardOwnerFocusNode!.requestFocus();
        });
      },
      controller: _.cardOwnerController!,
      decoration: InputDecoration(
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        hintText: "Card Owner",
        hintStyle:
        TextStyle(fontSize: displayWidth(context) / 25, color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(
            vertical: 20.0, horizontal: displayWidth(context) * 0.04),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  TextFormField cardCvvFormField() {
    return TextFormField(
      style: const TextStyle(
          color: Colors.black
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Cvv must not be empty';
        } else if (_.cardValidator.validCVC(value)) {
          return null;
        } else {
          return 'Enter Valid Cvv';
        }
      },
      controller: _.cardCvvController,
      decoration: InputDecoration(
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        hintText: "CVV",
        hintStyle:
        TextStyle(fontSize: displayWidth(context) / 25, color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(
            vertical: 20.0, horizontal: displayWidth(context) * 0.04),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  TextFormField cardExpDateFormField() {
    return TextFormField(
      style: const TextStyle(
          color: Colors.black
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        new LengthLimitingTextInputFormatter(4),
        new ExpiryDateInputFormatter()
      ],
      autofocus: false,
      focusNode: _.cardExpFocusNode!,
      onChanged: (expDate) {
        setState(() {
          _.cardExpFocusNode!.requestFocus();
        });
      },
      controller: _.cardExpDateController,
      decoration: InputDecoration(
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        hintText: "mm/yy",
        hintStyle:
        TextStyle(fontSize: displayWidth(context) / 25, color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(
            vertical: 20.0, horizontal: displayWidth(context) * 0.04),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  void sendEmail() {
    String email = 'skiplab.innovation@gmail.com';
    String password = 'aaaaaa@123';

    //user for your own domain
    final smtpServer = gmail(email, password);

    final message = Message()
      ..from = Address(email, 'Tranquil Life 😀')
      ..recipients.add('${auth!.currentUser!.email}')
    //..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
    //..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'You added a new payment card'
      ..html = addedNewCard;

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

  var addedNewCard = '''
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
                <a href="http://www.example.com/" style="text-decoration:none;"><img src="https://assets.codepen.io/210284/logo.png" width="165" alt="Tranquila" style="width:80%;max-width:165px;height:auto;border:none;text-decoration:none;color:#ffffff;"></a>
              </td>
            </tr>
            <tr>
              <td style="padding:30px;background-color:#ffffff;">
                <h1 style="margin-top:0;margin-bottom:16px;font-size:26px;line-height:32px;font-weight:bold;letter-spacing:-0.02em;">Hello ${DashboardController.to.username!.value}}!</h1>
                <p style="margin:0;">A new card <strong>"${Get.find<AddNewCardController>().cardNumController!.text.toString()}"</strong> has been added to your card stack.</p>
              </td>
            </tr>
            <tr>
              <td style="padding:0;font-size:24px;line-height:28px;font-weight:bold;">
                <a href="http://www.example.com/" style="text-decoration:none;">
                <img src="https://firebasestorage.googleapis.com/v0/b/mindscapeproject-ef43d.appspot.com/o/emailTemplates%2Fcard-stack-vector.png?alt=media&token=e75e9887-3c6a-43f7-8e83-042c429f7030" 
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
                              <span style="mso-text-raise:10pt;font-weight:bold;">Tranquila
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
}