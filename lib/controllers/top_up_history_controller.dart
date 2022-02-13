/* .................. To-Up History Controller ...............*/


import 'package:get/get.dart';

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

