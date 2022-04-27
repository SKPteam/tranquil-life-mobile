class Consultant {
  int? id;
  String? fName;
  String? lName;
  double? latitude;
  double? longitude;
  double? rating;
  String? gender;
  List? languages;
  List? specialties;
  String? yearsOfExperience;
  List? availableTime;
  double? fee;
  bool? onlineStatus;
  bool? approved;
  bool? restricted;
  bool? blocked;

  Consultant(
      {this.id,
        this.fName,
        this.lName,
        this.latitude,
        this.longitude,
        this.rating,
        this.gender,
        this.languages,
        this.specialties,
        this.yearsOfExperience,
        this.availableTime,
        this.fee,
        this.onlineStatus,
        this.approved,
        this.restricted,
        this.blocked});

  Consultant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    rating = json['rating'];
    gender = json['gender'];
    if (json['languages'] != null) {
      languages = [];
      json['languages'].forEach((v) {
        languages!.add(v);
      });
    }
    if (json['specialties'] != null) {
      specialties = [];
      json['specialties'].forEach((v) {
        specialties!.add(v);
      });
    }
    yearsOfExperience = json['years_of_experience'];
    if (json['available_time'] != null) {
      availableTime = [];
      json['available_time'].forEach((v) {
        availableTime!.add(v);
      });
    }
    fee = json['fee'];
    onlineStatus = json['online_status'];
    approved = json['approved'];
    restricted = json['restricted'];
    blocked = json['blocked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['rating'] = this.rating;
    data['gender'] = this.gender;
    if (this.languages != null) {
      data['languages'] = this.languages!.map((v) => v.toJson()).toList();
    }
    if (this.specialties != null) {
      data['specialties'] = this.specialties!.map((v) => v.toJson()).toList();
    }
    data['years_of_experience'] = this.yearsOfExperience;
    if (this.availableTime != null) {
      data['available_time'] =
          this.availableTime!.map((v) => v.toJson()).toList();
    }
    data['fee'] = this.fee;
    data['online_status'] = this.onlineStatus;
    data['approved'] = this.approved;
    data['restricted'] = this.restricted;
    data['blocked'] = this.blocked;
    return data;
  }
}
