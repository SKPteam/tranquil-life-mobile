class ConsultantProfileModel {
  final String? preferredLangs;
  final String? yearsOfExperience;
  final String? areaOfExpertise;
  final String? uid;
  final int fee;
  final String? phoneNum;
  final String? description;
  final String? location;
  final String? avatarUrl;
  final String? firstName;
  final String? lastName;
  final String? timeZone;
  final String? email;

  ConsultantProfileModel({
    this.uid,
    this.email,
    this.phoneNum,
    this.preferredLangs,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    this.yearsOfExperience = '',
    this.areaOfExpertise = '',
    this.fee = 0,
    this.timeZone,
    this.description = '',
    this.location = '',
  });
}