import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/main.dart';
import 'package:tranquil_life/models/question_model.dart';
import 'package:tranquil_life/models/questionnaire_option.dart';

import '../services/http_services.dart';

class QuestionnaireController extends GetxController {
  static QuestionnaireController instance = Get.find();

  List<String> tempOptions = [];
  bool? isFetchingQuestions;

  int questionProgress = 1;

  List<Questionaire>? listOfQuestions;

  var model = Question();

  //get list of questions
  Future<List<Question>> listQuestions() async {
    List<Question> _questions = [];

    //temporary list for adding options as QuestionaireOption Model into it from database

    String url = baseUrl + listQuestionsPath;

    var response = await get(Uri.parse(url),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
          //"Authorization": "Bearer ${sharedPreferences!.getString('accessToken')}",
        });

    if(response != null){
      var resBody = json.decode(response.body);
      resBody.forEach((question){
        model.id = question["id"];
        model.q1 = question["q1"];
        model.q1Options = question["q1_options"].toString().replaceAll(', ', ',').split(',');
        model.q1IsMultiChoice = question["q1_is_multi_choice"] == 0 ? false : true;
        model.q1Trigger = question["q1_trigger"]==null ? "" : question["q1_trigger"].toString();
        model.q2 = question["q2"] == null ? "" : question["q2"].toString();
        model.q2Options = question["q2_options"] == null ? [""] : question["q2_options"].toString().replaceAll(', ', ',').split(',');
        _questions.add(model);
      });
    }
    print(_questions);
    return _questions;
  }

  getQuestions() async{
    isFetchingQuestions = true;
    String url = baseUrl + listQuestionsPath;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString("accessToken");
    var header = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    };
    await HttpClass().httpGetRequest(header, Uri.parse(url)).then((value){
      final result = jsonDecode(value!.body);
      if(result != null){
        isFetchingQuestions = false;
        listOfQuestions = List<Questionaire>.from(json.decode(value.body).map((x) => Questionaire.fromJson(x)));
        update();
      }else{
        isFetchingQuestions = false;
        update();
        throw Exception("Unable to Load data");
      }
    });
  }

  @override
  void onInit() {
    getQuestions();
    super.onInit();
  }
}