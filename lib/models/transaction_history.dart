// ignore_for_file: file_names

class TransactionHistoryModel {
  final String id;
  final int amount;
  final String referenceNumber;
  final DateTime timestamp;
  late TransactionType type;
  final String uid;


  TransactionHistoryModel({
    required this.id,
    required this.amount,
    required this.referenceNumber,
    required this.timestamp,
    required String type,
    required this.uid,
  }) {
    this.type =
    type == 'topUp' ? TransactionType.topUp : TransactionType.meeting;
  }

}

enum TransactionType { topUp, meeting, payOut }