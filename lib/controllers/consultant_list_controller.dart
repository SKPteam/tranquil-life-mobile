/*............. Consultant List Controller ...............*/

import 'dart:convert';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart';
import 'package:tranquil_life/main.dart';
import 'package:tranquil_life/models/consultant_model.dart';

import '../constants/app_strings.dart';

class ConsultantListController extends GetxController {
    static ConsultantListController instance = Get.find();

    ///Demo List of Consultants
    final RxList<Consultant> consultantList = <Consultant>[].obs;
    late Consultant consultantModel;
    final List<Map<String, String>> answers = [];
    RxBool consultantListLoaded = false.obs;

    // ConsultantProfileModel consultantProfileModel = ConsultantProfileModel(
    //     preferredLangs: "Yoruba",
    //     yearsOfExperience: "2",
    //     areaOfExpertise: "5",
    //     uid: "1",
    //     fee: 5000,
    //     firstName: "Barry",
    //     lastName: "allen");


    Future<List<Consultant>> getConsultantList() async {
        List<Consultant> _consultants = [];

        String url = baseUrl + getAllConsultantsPath;

        var response = await get(Uri.parse(url), headers: {
            "Content-type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer ${sharedPreferences!.getString(
                'accessToken')}",
        });

        if (response != null) {
            var resBody = json.decode(response.body);
            resBody.forEach((consultant) {
                var model = Consultant();
                model.id = consultant['id'];
                model.rating = consultant['rating'] != null
                    ? double.parse(consultant['rating'].toString())
                    : 0.0;
                model.fName = consultant['f_name'] ?? "";
                model.lName = consultant['l_name'] ?? "";
                model.latitude = consultant['latitude'] != null
                    ? double.parse(consultant['latitude'].toString())
                    : 0.0;
                model.longitude = consultant['longitude'] != null
                    ? double.parse(consultant['longitude'].toString())
                    : 0.0;
                model.languages =
                consultant['languages'] == null ? [] : consultant['languages'];
                model.specialties = consultant['specialties'] == null
                    ? []
                    : consultant['specialties'];
                model.yearsOfExperience = consultant['years'] ?? "";
                model.availableTime = consultant['available_time'] == null
                    ? []
                    : consultant['available_time'];
                model.fee = consultant['fee'] != null
                    ? double.parse(consultant['fee'].toString())
                    : 0.0;
                //model.onlineStatus;
                //model.approved;
                //model.restricted;
                //model.blocked;
                _consultants.add(model);
            });
        }

        return _consultants;
    }
}