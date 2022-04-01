// To parse this JSON data, do
//
//     final journalListReponse = journalListReponseFromJson(jsonString);

import 'dart:convert';

JournalListReponse journalListReponseFromJson(String str) => JournalListReponse.fromJson(json.decode(str));

String journalListReponseToJson(JournalListReponse data) => json.encode(data.toJson());

class JournalListReponse {
  JournalListReponse({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int? currentPage;
  List<JournalList>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  factory JournalListReponse.fromJson(Map<String, dynamic> json) => JournalListReponse(
    currentPage: json["current_page"] == null ? null : json["current_page"],
    data: json["data"] == null ? null : List<JournalList>.from(json["data"].map((x) => JournalList.fromJson(x))),
    firstPageUrl: json["first_page_url"] == null ? null : json["first_page_url"],
    from: json["from"] == null ? null : json["from"],
    lastPage: json["last_page"] == null ? null : json["last_page"],
    lastPageUrl: json["last_page_url"] == null ? null : json["last_page_url"],
    links: json["links"] == null ? null : List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"] == null ? null : json["path"],
    perPage: json["per_page"] == null ? null : json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"] == null ? null : json["to"],
    total: json["total"] == null ? null : json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage == null ? null : currentPage,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
    "first_page_url": firstPageUrl == null ? null : firstPageUrl,
    "from": from == null ? null : from,
    "last_page": lastPage == null ? null : lastPage,
    "last_page_url": lastPageUrl == null ? null : lastPageUrl,
    "links": links == null ? null : List<dynamic>.from(links!.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path == null ? null : path,
    "per_page": perPage == null ? null : perPage,
    "prev_page_url": prevPageUrl,
    "to": to == null ? null : to,
    "total": total == null ? null : total,
  };
}

class JournalList {
  JournalList({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.heading,
    this.body,
    this.moodSvgUrl,
    this.clientId,
    this.consultantId,
  });

  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? heading;
  String? body;
  String? moodSvgUrl;
  int? clientId;
  dynamic consultantId;

  factory JournalList.fromJson(Map<String, dynamic> json) => JournalList(
    id: json["id"] == null ? null : json["id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    heading: json["heading"] == null ? null : json["heading"],
    body: json["body"] == null ? null : json["body"],
    moodSvgUrl: json["moodSvgUrl"] == null ? null : json["moodSvgUrl"],
    clientId: json["client_id"] == null ? null : json["client_id"],
    consultantId: json["consultant_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
    "heading": heading == null ? null : heading,
    "body": body == null ? null : body,
    "moodSvgUrl": moodSvgUrl == null ? null : moodSvgUrl,
    "client_id": clientId == null ? null : clientId,
    "consultant_id": consultantId,
  };
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String? url;
  String? label;
  bool? active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"] == null ? null : json["url"],
    label: json["label"] == null ? null : json["label"],
    active: json["active"] == null ? null : json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url == null ? null : url,
    "label": label == null ? null : label,
    "active": active == null ? null : active,
  };
}
