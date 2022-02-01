// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/helpers/constants.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';

class AreaOfExpertiseModalSheet extends StatefulWidget {

  final List<String> aoeList;
  final TextEditingController areaOfExpertiseTEC;

  const AreaOfExpertiseModalSheet({required Key? key, required this.aoeList, required this.areaOfExpertiseTEC}) : super(key: key);

  @override
  _AreaOfExpertiseModalSheetState createState() => _AreaOfExpertiseModalSheetState();
}

class _AreaOfExpertiseModalSheetState extends State<AreaOfExpertiseModalSheet> {

  List<String>? searchedAOEList;
  List<String>? aoeList;
  String? selectedAOE;

  TextEditingController aoeSearchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    aoeList = widget.aoeList;
    searchedAOEList = aoeList;

    print(searchedAOEList);
  }

  void search() {
    searchedAOEList = [];
    print('Searching');
    setState(() {
      for (var i = 0; i < aoeList!.length; i++) {
        if (aoeList![i]
            .toLowerCase()
            .contains(aoeSearchController.text.toLowerCase())) {
          searchedAOEList!.add(aoeList![i]);
        }
      }
    });
    print(searchedAOEList);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 600,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SizedBox(
        height: displayHeight(context) * 0.08,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: aoeSearchController,
                    onEditingComplete: search,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  color: kPrimaryColor,
                  onPressed: search,
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
                            selectedAOE = item;
                            widget.areaOfExpertiseTEC.text = selectedAOE!;

                            Navigator.of(context).pop();
                          },
                          child: Container(
                            margin: EdgeInsets.all(displayWidth(context) * 0.03),
                            child: Text(item.toString(),
                                style: TextStyle(
                                    fontSize: displayWidth(context)*0.04
                                )),
                          ));
                    }
                )
            )
          ],
        ),
      ),
    );
  }
}