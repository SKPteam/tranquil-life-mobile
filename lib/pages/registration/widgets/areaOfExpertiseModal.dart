// ignore_for_file: file_names, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/helpers/constants.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';

class _AreaOfExpertiseModalSheetState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      responsiveBuilder: (context, size)=>
          Container(
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
                        child: Container(),
                        // child: TextField(
                        //   controller: aoeSearchController,
                        //   onEditingComplete: search,
                        // ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        color: kPrimaryColor,
                        onPressed: (){},
                      )
                    ],
                  ),
                  Expanded(
                      child: Container()
                  )
                ],
              ),
            ),
          ),
    );
  }
}

/*
* ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: searchedAOEList!.length,
                          itemBuilder: (context, int index){
                            final item = searchedAOEList![index];
                            return GestureDetector(
                                onTap: () {
                                  selectedAOE = item;
                                  widget.areaOfExpertiseTEC.text = selectedAOE!;

                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  margin: EdgeInsets.all(size.width * 0.03),
                                  child: Text(item.toString(),
                                      style: TextStyle(
                                          fontSize: 18
                                      )),
                                ));
                          }
                      )
*
* */