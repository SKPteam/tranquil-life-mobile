// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';
import 'dart:io';

//import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/models/card_model.dart';
import 'package:tranquil_life/helpers/constants.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;


class WalletController extends GetxController{
  static WalletController instance = Get.find();

  GetStorage storage = GetStorage();
  final plugin = PaystackPlugin();

  ValueNotifier<bool> cardStackLoaded = ValueNotifier(false);
  RxList<CardModel> cardStack = <CardModel>[].obs;
  RxList<CardModel> allCardStackBeforeSwipingOff = <CardModel>[].obs;

  CardModel? cardModel;
  var workPlace = "";
  RxInt? discount;
  RxString type = "".obs;
  RxInt? amountPaid;
  var uuid = const Uuid();

  Locale locale = Localizations.localeOf(Get.context!);

  RxString currency = "".obs;

  List<String> currencies = [];
  String from = "USD";
  String to = "NGN";
  //TODO: I want to  to = format.currencyName.toString() but it's not working.
  //TODO: Please help me solve the issue

  //variables for exchange rate
  double? rate;
  String result = "";

  RxString figure = "".obs;

  var format;

  RxBool discountExists = false.obs;
  RxBool loaded = false.obs;

  late AnimationController controller;
  late AnimationController numberController;
  late Animation<double> animationah;
  late Animation<double> animationaw;
  late Animation<double> animationbh;
  late Animation<double> animationbw;
  late Animation<double> fadeanimationOp;
  double num = 0;
  late Animation<double> numberAnim;

  late String bankName;
  RxBool dataLoaded = false.obs;
  String zerosOfBalance = '';
  RxInt? consultationsThisMonth;

  String getZeros(int num) {
    String a = '';
    for (int i = 0; i < num.toString().length; i++) {
      a = a + '0';
    }
    return a;
  }

  @override
  void dispose() {
    controller.dispose();
    controller.isNull;
    super.dispose();
  }

  @override
  void onInit() async {
    super.onInit();


    await checkNumOfConsultations();

    rate = await getRate(from, to);

    (() async {
      // List<String> list = await getCurrencies();
      // currencies = list;
    });

    format = intl.NumberFormat.simpleCurrency(locale: locale.toString());

    //to = "${NumberFormat.simpleCurrency(locale: locale.toString()).currencyName}";

    plugin.initialize(publicKey: publicKey);

    getCardDetails();
    allCardStackBeforeSwipingOff.addAll(cardStack);

    type.value = storage.read(userType);

    getStaffDetails();

  }

  Size textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  checkNumOfConsultations() {
    // if (DashboardController.to.myTotalConsultations!.value <= 3) {
    //   discountExists.value = true;
    // }
  }

  @override
  void onReady() {
    super.onReady();

    getStaffDetails();
  }

  void getCardDetails() async {
    // DatabaseReference _paymentCardsReference =
    // accountSettingsRef!.child(auth!.currentUser!.uid).child('paymentCards');
    // await _paymentCardsReference.once().then((DataSnapshot snapshot) {
    //   cardStack.clear();
    //   if (snapshot.value != null) {
    //     var keys = snapshot.value.keys;
    //     var values = snapshot.value;
    //     //print(keys);
    //     //print(values);
    //     for (var key in keys) {
    //       cardModel = CardModel(
    //           values[key]['id'],
    //           values[key][cardNumber],
    //           values[key][cardOwner],
    //           values[key]["cardType"],
    //           values[key][cardExpiryDate],
    //           values[key][cardCVV],
    //           values[key]['isDefault']);
    //       cardStack.add(cardModel!);
    //     }
    //     print("KEYS:$keys");
    //     print("VALUES: $values");
    //   }
    //   cardStackLoaded.value = true;
    // });
  }

  getStaffDetails() async {
    // workPlace = DashboardController.to.workPlace!.value.toString();
    // print(workPlace.toString());
    //
    // var doc;
    // await enrolledCompaniesRef!
    //     .where('name', isEqualTo: workPlace)
    //     .limit(1)
    //     .get()
    //     .then((snapshot1) {
    //   if (snapshot1.size >= 0) {
    //     for (var i = 0; i < snapshot1.docs.length; i++) {
    //       doc = snapshot1.docs[i];
    //     }
    //   } else {
    //     print('does not exist');
    //   }
    // });
    //
    // enrolledCompaniesRef!
    //     .doc(doc.data()['id'])
    //     .collection('staff')
    //     .where('email', isEqualTo: auth!.currentUser!.email)
    //     .limit(1)
    //     .get()
    //     .then((snapshot2) {
    //   for (var j = 0; j < snapshot2.docs.length; j++) {
    //     discount =
    //         RxInt(int.parse(snapshot2.docs[j].data()['discount'].toString()));
    //     loaded.value = true;
    //   }
    // });
  }

  ///gives a reference string mentioning from which device type and at what time it is charged
  String getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  //function to get currencies list
  // Future<List<String>> getCurrencies() async {
  //   http.Response res = await http.get(currencyURL);
  //   if (res.statusCode == 200) {
  //     var body = jsonDecode(res.body);
  //     var list = body['results'];
  //     List<String> currencies = (list.keys).toList();
  //     print(currencies);
  //     return getCurrencies();
  //   } else {
  //     throw Exception("Failed to connect to API");
  //   }
  // }

  //getting exchange rate
  Future<double> getRate(String from, String to) async {
    final Uri rateUri = Uri.http("free.currconv.com", "/api/v7/convert", {
      "apiKey": "36c7bbb929c685da0160",
      "q": "${from}_$to",
      "compact": "ultra"
    });
    http.Response res = await http.get(rateUri);
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      return body["${from}_$to"];
    } else {
      throw Exception("Failed to connect to API");
    }
  }


//TODO: Implement business logic for every feature in the Wallet page here:
//TODO: list of cards. top up, add card, client discount and balance

}

