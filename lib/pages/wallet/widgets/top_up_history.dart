// ignore_for_file: avoid_print, must_be_immutable, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/top_up_history_controller.dart';
import 'package:tranquil_life/models/transaction_history.dart';



class TopUpHistoryModalSheet extends StatelessWidget {
  TopUpHistoryModalSheet({Key? key}) : super(key: key);

  Size size = MediaQuery.of(Get.context!).size;


  @override
  Widget build(BuildContext context) {
    TopUpHistoryController _ = Get.put(TopUpHistoryController());
//------------------------
    // GESTURE DETECTOR FOR REMOVING TRANSACTION
    // MODAL SHEET WHEN TAPPED OUTSIDE OF THE TRANSACTION MODAL SHEET
    //------------------------
    return AnimatedContainer(
      duration:  Duration(milliseconds: 150),
      height: size.height * 0.6,
      width: size.width,
      decoration:  BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      padding: EdgeInsets.only(
          right: size.height * 0.04,
          left: size.height * 0.04,
          top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
           SizedBox(
            height: 10,
          ),
          //------------------------
          // HEADING
          //------------------------
          Container(
            padding:  EdgeInsets.only(left: 10),
            child:  Text(
              'Transactions',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
           SizedBox(
            height: 10,
          ),
          //------------------------
          // SCROLLING TRANSACTIONS
          //------------------------
          Expanded(
            child: Container(),
            // FirebaseAnimatedList(
            //   query: transactionsRef!
            //       .child(businessProfit)
            //       .orderByChild('uid')
            //       .equalTo(auth!.currentUser!.uid),
            //   shrinkWrap: true,
            //   defaultChild:  Center(
            //     child: CircularProgressIndicator(),
            //   ),
            //   padding:  EdgeInsets.symmetric(vertical: 10),
            //   sort: (a, b) {
            //     return DateTime.fromMillisecondsSinceEpoch(a.value["timestamp"])
            //         .compareTo(DateTime.fromMillisecondsSinceEpoch(
            //         b.value["timestamp"]));
            //   },
            //   itemBuilder: (context, snapshot, animation, index) {
            //     print("transaction => ${snapshot.value}");
            //     final values = snapshot.value;
            //     return TransactionHistoryModalWidget(
            //       transactionModel: TransactionHistoryModel(
            //         id: values["id"],
            //         amount: values["amount"].toInt(),
            //         referenceNumber: values["referenceNumber"],
            //         timestamp: DateTime.fromMillisecondsSinceEpoch(
            //             values["timestamp"]),
            //         type: values["type"],
            //         uid: values["uid"],
            //       ),
            //     );
            //   },
            // ),
          ),
        ],
      ),
    );
  }
}

class TransactionHistoryModalWidget extends StatelessWidget {
  final TransactionHistoryModel transactionModel;

   TransactionHistoryModalWidget({Key? key, required this.transactionModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat _dmyformat = DateFormat('dd-mm-yyyy');
    final primaryColor = transactionModel.type == TransactionType.topUp
        ? kPrimaryColor
        : Colors.red;
    //------------------------
    // Transaction Container
    //------------------------
    return Container(
      height: 120,
      padding:  EdgeInsets.all(18),
      margin:  EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: kLightBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //------------------------
          // Name and COst row
          //------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    transactionModel.type.toString(),
                    textAlign: TextAlign.left,
                    style:  TextStyle(
                      color: kPrimaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
               SizedBox(
                width: 10,
              ),
              Text(
                'N${transactionModel.amount}',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
           Spacer(),
          //------------------------
          // ref no. and date heading row
          //------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Reference Number',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
               SizedBox(
                width: 10,
              ),
              Text(
                'Date',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
           SizedBox(
            height: 2,
          ),
          //------------------------
          // ref no. and date row
          //------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    transactionModel.referenceNumber,
                    textAlign: TextAlign.left,
                    style:  TextStyle(
                      color: kPrimaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
               SizedBox(
                width: 10,
              ),
              Text(
                _dmyformat.format(transactionModel.timestamp),
                style:  TextStyle(
                  color: kPrimaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}