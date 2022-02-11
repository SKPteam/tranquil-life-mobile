// // ignore_for_file: non_constant_identifier_names
// import 'dart:convert';
//
// import 'package:flutter/services.dart' as rootBundle;
//
class ConsultantPortfolioModel {
  String? f_name;
  String? l_name;


  //constructor
  ConsultantPortfolioModel({required this.f_name, required this.l_name});
}
//
//   //method that assign values to respective datatype vairables
//   ConsultantPortfolio.fromJson(Map<String,dynamic> json){
//     id = json['id'];
//     f_name = json['f_name'];
//     l_name = json['l_name'];
//     gender = json['gender'];
//     specialities = json['specialities'];
//     languages = json['languages'];
//     nationality = json['nationality'];
//   }
//
//   Future<List> ReadJsonData() async {
//     //read json file
//     final jsondata = await rootBundle.rootBundle.loadString('jsonFiles/consultant_portfolio_model.json');
//     //decode json data as list
//     final list = json.decode(jsondata) as List<dynamic>;
//
//     //map json and initialize using DataModel
//     return list;
//         //.map((e) => ConsultantPortfolio.fromJson(e)).toList();
//   }
// }


const jsonArray = [
  {
    "id":2,
    "f_name":"Charles",
    "l_name":"Richard",
    "gender":"male",
    "specialities":[
      "anxiety",
      "self-esteem"
    ],
    "languages":[
      "English",
      "Yoruba"
    ],
    "nationality":"English"
  },
  {
    "id":6,
    "f_name":"James",
    "l_name":"Emeka",
    "gender":"male",
    "specialities":[
      "anxiety",
      "self-esteem"
    ],
    "languages":[
      "English",
      "Igbo"
    ],
    "nationality":"Nigerian"
  },
  {
    "id":9,
    "f_name":"Mary",
    "l_name":"Christian",
    "gender":"female",
    "specialities":[
      "anxiety",
      "self-esteem"
    ],
    "languages":[
      "English",
      "Igbo",
      "Espanyol"
    ],
    "nationality":"Spanish"
  }
];
