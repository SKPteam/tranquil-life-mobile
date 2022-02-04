// ignore_for_file: prefer_const_constructors, avoid_print, avoid_unnecessary_containers

import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/consultant_list_controller.dart';
import 'package:tranquil_life/controllers/consultant_registration_controller.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';
import 'package:tranquil_life/models/consultant_profile_model.dart';
import 'package:tranquil_life/models/schedule_date_model.dart';


class ConsultantListView extends StatefulWidget {
  // final List<Map<String, String>> answerOfQuestionaire;
  //
  // const ConsultantListView({Key? key, required this.answerOfQuestionaire})
  //     : super(key: key);

  @override
  _ConsultantListViewState createState() => _ConsultantListViewState();
}

class _ConsultantListViewState extends State<ConsultantListView> {
  @override
  Widget build(BuildContext context) {
    //ConsultantListController _ = Get.put(ConsultantListController());

    //print(widget.answerOfQuestionaire[]);

    return Scaffold(
        body: ResponsiveSafeArea(
          responsiveBuilder: (context, size)
          => Container(
            child: Center(
              child: Text("Consultant List"),
            ),
          ),
        ));
  }
}
