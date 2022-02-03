import 'dart:convert';

class Chatroom {
  final String id;
  final String creatorID;
  final String consultantID;
  final int timer;
  final DateTime timestamp;
  final List<Participants> participants;

  Chatroom(
      {required this.consultantID,
        this.timer = 0,
        required this.timestamp,
        required this.id,
        required this.creatorID,
        this.participants = const []});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'creatorID': creatorID,
      'consultantID': consultantID,
      'timer': timer,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'participants': participants.map((x) => x.toMap()).toList(),
    };
  }

  factory Chatroom.fromMap(Map<String, dynamic> map) {
    return Chatroom(
      id: map['id'],
      creatorID: map['creatorID'],
      consultantID: map['consultantID'],
      timer: map['timer'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      participants: List<Participants>.from(
          map['participants']?.map((x) => Participants.fromJson(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Chatroom.fromJson(String source) =>
      Chatroom.fromMap(json.decode(source));
}

class Participants {
  final String userID;
  final String name;
  final String fCMToken;
  bool isOnline = false;
  final String avatarUrl;

  Participants(this.userID, this.name, this.fCMToken, this.avatarUrl);

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'name': name,
      'fCMToken': fCMToken,
      'isOnline': isOnline,
      'avatarUrl': avatarUrl,
    };
  }

  factory Participants.fromMap(Map<String, dynamic> map) {
    return Participants(
      map['userID'],
      map['name'],
      map['fCMToken'],
      map['avatarUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Participants.fromJson(String source) =>
      Participants.fromMap(json.decode(source));
}