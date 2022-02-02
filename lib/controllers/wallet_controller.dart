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
import 'package:tranquil_life/helpers/sizes_helpers.dart';
import 'package:tranquil_life/main.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import 'dashboard_controller.dart';

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

/* .................. To-Up History Controller ...............*/


class TopUpHistoryController extends GetxController {
  // Query getDataFromFirebase() {
  //   print('Extracting Data from Firebase for Transaction History');
  //   //snapshots from database
  //   //if the list is empty, that is extraction process if done for first time, then
  //   // don't use startAfterDocument property and limit the documents to 10
  //   return transactionsRef!
  //       .child(businessProfit)
  //       .equalTo(auth!.currentUser!.uid, key: 'uid')
  //       .orderByChild('timestamp');
  // }
}

// Future _handleDataFromDatabase(
//   QuerySnapshot transactionDocs,
// ) async {
//   print('the length of the transactions is ${transactionDocs.docs.length}');
//   //if snapshots from database is not empty, then execute below code
//   if (transactionDocs.docs.isNotEmpty) {
//     // store the last snapshot of the 10 documents to be used for startfromDocument option
//     lastDisplayedTransactionDocument = transactionDocs.docs.last;
//     //for each document in the snapshot execute the loop
//     for (var i = 0; i < transactionDocs.docs.length; i++) {
//       var doc = transactionDocs.docs[i];
//       print(doc.data());
//       var docData = doc.data() as Map<String, dynamic>;
//       //!will use this for getting name of the user to which money is sent
//       //get the userData from the uid of the notification
//       // var userAccountDoc =
//       //     await accountSettingsRef.child(docData['uid']).once();

//       //add the data into Notification Model and then add it to the notifications list
//       historyOfTransactions.add(TransactionHistoryModel(
//         id: docData['id'],
//         amount: docData['amount'].toInt(),
//         referenceNumber: docData['referenceNumber'],
//         timestamp: DateTime.fromMillisecondsSinceEpoch(docData['timestamp'])
//             .toLocal(),
//         type: docData['type'],
//         uid: docData['uid'],
//       ));
//     }
//   }
//   //if the length of snapshot documents is less than 10 or it is empty then
//   // make the bool variable that suggests that no notifications are available in database for pagination
//   if (transactionDocs.docs.length < 10) {
//     moreTransactionsAvailableInDatabase.value = false;
//   }
// }

// TransactionHistoryModel? transactionHistoryModel;

// RxList<TransactionHistoryModel> historyOfTransactions =
//     <TransactionHistoryModel>[].obs;

// final _count = 103;
// final _itemsPerPage = 5;
// int _currentPage = 0;

// // This async function simulates fetching results from Internet, etc.
// Future<List<TransactionHistoryModel>> fetch() async {
//   final n = min(_itemsPerPage, _count - _currentPage * _itemsPerPage);
//   // Uncomment the following line to see in real time now items are loaded lazily.
//   // print('Now on page $_currentPage');

//   // Query transactionQuery;
//   //
//   // transactionQuery = transactionsRef!.child(businessProfit)
//   //     .orderByChild("uid")
//   //     .equalTo(auth!.currentUser!.uid)
//   // .limitToLast(10);

//   //transactionQuery.onValue.last;

//   transactionsRef!
//       .child(businessProfit)
//       .orderByChild("uid")
//       .equalTo(auth!.currentUser!.uid)
//       .once()
//       .then((DataSnapshot snapshot) {
//     historyOfTransactions.clear();
//     if (snapshot.value != null) {
//       var keys = snapshot.value.keys;
//       var values = snapshot.value;
//       for (var key in keys) {
// transactionHistoryModel = TransactionHistoryModel(
//     id: values[key]["id"],
//     amount: values[key]["amount"],
//     referenceNumber: values[key]["referenceNumber"],
//     timestamp: values[key]["timestamp"],
//     type: values[key]["type"],
//     uid: values[key]["uid"]);
//         historyOfTransactions.add(transactionHistoryModel!);
//       }
//       print("KEYS:$keys");
//       print("VALUES: $values");
//     }
//   });

//   dataLoaded.value = true;

//   print(historyOfTransactions.length);

//   await Future.delayed(Duration(seconds: 1), () {
//     for (int i = 0; i < n; i++) {
//       historyOfTransactions.add(transactionHistoryModel!);
//     }
//   });
//   _currentPage++;
//   return historyOfTransactions;
// }

// @override
// void onInit() {
//   super.onInit();

//   isLoading.value = true;
//   hasMore.value = true;
//   loadMore();
// }

// // Triggers fecth() and then add new items or change _hasMore flag
// void loadMore() {
//   isLoading.value = true;
//   fetch().then((List<TransactionHistoryModel> fetchedList) {
//     if (fetchedList.isEmpty) {
//       isLoading.value = false;
//       hasMore.value = false;
//     } else {
//       isLoading.value = false;
//       historyOfTransactions.addAll(fetchedList);
//     }
//   });
// }

/*......... Add New Card Controller ............*/



class AddNewCardController extends GetxController{

  TextEditingController? cardNumController;
  TextEditingController? cardOwnerController;
  TextEditingController? cardCvvController;
  TextEditingController? cardExpDateController;

  final PaymentCard cardValidator = PaymentCard.empty();
  FocusNode? cardNumFocusNode,
      cardOwnerFocusNode,
      cardExpFocusNode,
      cardCvvFocusNode;
  RxList<Map> cardTypes = <Map>[].obs;

  RxString cardId = "".obs;
  RxString cardNumText = "".obs;
  RxString cardOwnerText = "".obs;
  RxString cvvText = "".obs;
  RxString expDate = "".obs;
  RxString cardTypeName = "".obs;

  final formKey = GlobalKey<FormState>();
  String selectedCardType = "";
  RxString cardType = "".obs;

  cardNum() {
    if (cardNumController!.text == "") {
      cardNumController = TextEditingController(text: "Card Number");
    }
  }

  @override
  void onInit() {
    cardNumController = TextEditingController();
    cardOwnerController = TextEditingController();
    cardCvvController = TextEditingController();
    cardExpDateController = TextEditingController();

    cardNumFocusNode = FocusNode();
    cardOwnerFocusNode = FocusNode();
    cardCvvFocusNode = FocusNode();
    cardExpFocusNode = FocusNode();

    cardNum();

    cardTypes.value = [
      {
        'id': '0',
        'image': 'assets/icons/icon-visa.svg',
        'name': CardType.visa.toUpperCase()
      },
      {
        'id': '1',
        'image': 'assets/icons/icon-verve.svg',
        'name': CardType.verve.toUpperCase()
      },
      {
        'id': '2',
        'image': 'assets/icons/icon-mastercard.svg',
        'name': CardType.masterCard.toUpperCase()
      },
      {
        'id': '3',
        'image': 'assets/icons/icon-american-express.svg',
        'name': CardType.americanExpress.toUpperCase()
      },
    ];

    super.onInit();
  }

  @override
  void onClose() {
    cardNumFocusNode!.dispose();
    cardOwnerFocusNode!.dispose();
    cardCvvFocusNode!.dispose();

    super.onClose();
  }
}