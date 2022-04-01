// To parse this JSON data, do
//
//     final questionaire = questionaireFromJson(jsonString);

import 'dart:convert';

List<Questionaire> questionaireFromJson(String str) => List<Questionaire>.from(json.decode(str).map((x) => Questionaire.fromJson(x)));

String questionaireToJson(List<Questionaire> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Questionaire {
  Questionaire({
    this.id,
    this.q1,
    this.q1Options,
    this.q1IsMultiChoice,
    this.q1Trigger,
    this.q2,
    this.q2Options,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? q1;
  List<String>? q1Options;
  int? q1IsMultiChoice;
  String? q1Trigger;
  String? q2;
  List<String>? q2Options;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Questionaire.fromJson(Map<String, dynamic> json) => Questionaire(
    id: json["id"] == null ? null : json["id"],
    q1: json["q1"] == null ? null : json["q1"],
    q1Options: json["q1_options"] == null ? null : List<String>.from(json["q1_options"].map((x) => x)),
    q1IsMultiChoice: json["q1_is_multi_choice"] == null ? null : json["q1_is_multi_choice"],
    q1Trigger: json["q1_trigger"] == null ? null : json["q1_trigger"],
    q2: json["q2"] == null ? null : json["q2"],
    q2Options: json["q2_options"] == null ? null : List<String>.from(json["q2_options"].map((x) => x)),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "q1": q1 == null ? null : q1,
    "q1_options": q1Options == null ? null : List<dynamic>.from(q1Options!.map((x) => x)),
    "q1_is_multi_choice": q1IsMultiChoice == null ? null : q1IsMultiChoice,
    "q1_trigger": q1Trigger == null ? null : q1Trigger,
    "q2": q2 == null ? null : q2,
    "q2_options": q2Options == null ? null : List<dynamic>.from(q2Options!.map((x) => x)),
    "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
  };
}
