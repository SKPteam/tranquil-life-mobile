// ignore_for_file: file_names, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/registration_three_controller.dart';
import 'package:tranquil_life/helpers/constants.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';

import '../../../helpers/sizes_helpers.dart';

class AreaOfExpertiseModalSheet extends StatefulWidget {
  @override
  _AreaOfExpertiseModalSheetState createState() => _AreaOfExpertiseModalSheetState();
}

class _AreaOfExpertiseModalSheetState extends State<AreaOfExpertiseModalSheet> {
  final RegistrationThreeController _ = Get.put(RegistrationThreeController());

  List? searchedAOEList;
  List aoeList = [];
  String selectedAOE = "";
  int _selectedIndex = -1;
  bool checkedValue = false;

  TextEditingController aoeSearchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    aoeList = _.areaOfExpertiseList;
    searchedAOEList = aoeList;

    print(searchedAOEList);
  }

  void search(String query) {
    searchedAOEList = [];
    print('Searching');
    setState(() {
      for (var i = 0; i < aoeList.length; i++) {
        query = aoeList[i];
        if (query
            .toLowerCase()
            .contains(aoeSearchController.text.toLowerCase())) {
          searchedAOEList!.add(query);
        }
      }
    });
    print(searchedAOEList);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      responsiveBuilder: (context, size)=> Container(
        height: 600,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SizedBox(
          height: size.height * 0.08,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: aoeSearchController,
                      //onEditingComplete: search(),
                      onChanged: (value){
                        search(value);
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    color: kPrimaryColor,
                    onPressed: (){},
                  )
                ],
              ),
              Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: searchedAOEList!.length,
                      itemBuilder: (context, int index){
                        final item = searchedAOEList![index];
                        return GestureDetector(
                            onTap: () {
                              if(!_.expertiseArr.contains(item)){
                                _.expertiseArr.add(item);
                              }else{
                                _.expertiseArr.remove(item);
                              }

                              _.areaOfExpertiseTEC.text =
                                  _.expertiseArr.toString().substring(1,
                                      _.expertiseArr.toString().length-1);
                            },
                            child: Obx(()=>
                                Container(
                                  margin: EdgeInsets.all(displayWidth(context) * 0.03),
                                  padding: EdgeInsets.all(displayWidth(context) * 0.01),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(item.toString(),
                                          style: TextStyle(
                                              fontSize: displayWidth(context)*0.04
                                          )),

                                      Checkbox(
                                          onChanged: (newValue){

                                            if(!_.expertiseArr.contains(item)){
                                              _.expertiseArr.add(item);
                                            }else{
                                              _.expertiseArr.remove(item);
                                            }

                                            _.areaOfExpertiseTEC.text =
                                                _.expertiseArr.toString().substring(1,
                                                    _.expertiseArr.toString().length-1);

                                          }, value: _.expertiseArr.contains(item) ? true : false)
                                    ],
                                  ),
                                ))
                        );
                      }
                  )
              )
            ],
          ),
        ),
      )
    );
  }
}

