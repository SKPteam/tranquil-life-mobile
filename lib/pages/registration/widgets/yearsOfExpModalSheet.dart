// ignore_for_file: file_names, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';

class YearsOfExpModalSheet extends StatefulWidget {

  final List<String> yearsOfExpList;
  final TextEditingController yearsOfExpTEC;

  const YearsOfExpModalSheet({Key? key, required this.yearsOfExpList, required this.yearsOfExpTEC})
      :super(key: key);

  @override
  _YearsOfExpModalSheetState createState() => _YearsOfExpModalSheetState();
}

class _YearsOfExpModalSheetState extends State<YearsOfExpModalSheet> {

  //NOTE: YOE: Year of experience

  List<String> searchYearsOfExpList = [];
  List<String> yearsOfExpList = [];
  String selectedYOE = '';

  TextEditingController yearsOfExpSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    yearsOfExpList = widget.yearsOfExpList;
    searchYearsOfExpList = yearsOfExpList;

    print(searchYearsOfExpList);
  }

  void search() {
    searchYearsOfExpList = [];
    print('Searching');
    setState(() {
      for (var i = 0; i < yearsOfExpList.length; i++) {
        if (yearsOfExpList[i]
            .toLowerCase()
            .contains(yearsOfExpSearchController.text.toLowerCase())) {
          searchYearsOfExpList.add(yearsOfExpList[i]);
        }
      }
    });
    print(searchYearsOfExpList);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
          displayWidth(context)*0.04
      ),
      child: SizedBox(
        height: displayHeight(context) * 0.20,
        child: Column(
          children: [
            Text('Years of experience', style: TextStyle(
                fontSize: displayWidth(context)*0.05)),
            Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: searchYearsOfExpList.length,
                    itemBuilder: (context, int index){
                      final item = searchYearsOfExpList[index];
                      return GestureDetector(
                          onTap: (){
                            selectedYOE = item.toString();
                            widget.yearsOfExpTEC.text = selectedYOE;
                            print(widget.yearsOfExpTEC.text);
                            Navigator.of(context).pop();
                          },
                          child: Column(
                            children: [
                              const Spacer(),
                              SizedBox(
                                width: displayHeight(context)*0.12,
                                height: displayHeight(context)*0.12,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(displayWidth(context)*0.03)
                                  ),
                                  margin: EdgeInsets.all(displayWidth(context) * 0.03),
                                  child: Text(item.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: displayWidth(context)*0.07
                                      )),
                                ),
                              ),
                              const Spacer(),
                            ],
                          )
                      );
                    })
            ),
          ],
        ),
      ),
    );
  }
}