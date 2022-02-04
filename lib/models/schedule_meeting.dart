import 'dart:convert';

class ScheduledMeeting {
  final String creatorID;
  final String consultantID;
  String consultantName;
  String avatarUrl;
  final String duration;
  final int fee;
  final String id;
  final DateTime startingTime;
  final DateTime timestamp;

  ScheduledMeeting(
      {required this.creatorID,
        required this.consultantID,
        required this.avatarUrl,
        required this.consultantName,
        required this.duration,
        required this.fee,
        required this.id,
        required this.startingTime,
        required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'creatorID': creatorID,
      'consultantID': consultantID,
      'consultantName': consultantName,
      'avatarUrl': avatarUrl,
      'duration': duration,
      'fee': fee,
      'id': id,
      'startingTime': startingTime.millisecondsSinceEpoch,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory ScheduledMeeting.fromMap(Map<String, dynamic> map) {
    return ScheduledMeeting(
      creatorID: map['creatorID'],
      consultantID: map['consultantID'],
      consultantName: map['consultantName'],
      avatarUrl: map['avatarUrl'],
      duration: map['duration'],
      fee: map['fee'],
      id: map['id'],
      startingTime: DateTime.fromMillisecondsSinceEpoch(map['startingTime']),
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ScheduledMeeting.fromJson(String source) =>
      ScheduledMeeting.fromMap(json.decode(source));
}