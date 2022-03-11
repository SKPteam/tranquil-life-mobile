class Partner {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? logo;
  String? password;
  List? cities;

  Partner(
      {this.id,
        this.name,
        this.email,
        this.phone,
        this.logo,
        this.password,
        this.cities});

  Partner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    logo = json['logo'];
    password = json['password'];
    cities = json['cities'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['logo'] = this.logo;
    data['password'] = this.password;
    data['cities'] = this.cities;
    return data;
  }
}