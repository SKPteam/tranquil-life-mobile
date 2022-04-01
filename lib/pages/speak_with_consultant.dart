import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tranquil_life/controllers/consultant_detail_controller.dart';
import 'package:tranquil_life/helpers/bottom_sheet_helper.dart';
import 'package:tranquil_life/pages/consultant_available_time.dart';
import 'package:tranquil_life/pages/consultant_details.dart';
import '../constants/style.dart';
class SpeakWithConsultant extends StatelessWidget {
  const SpeakWithConsultant({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = Get.put(ConsultantDetailsController());
    List<ConsultantDetails> consultants = ConsultantDetails.consultantDetails;
    return SafeArea(top: false, bottom: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0, backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            Text("Speak With a consultant", style: Theme.of(context).textTheme.headline4?.copyWith(color: active, fontSize: 35),),
            Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: List.generate(consultants.length, (index) =>
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),),
                            height: MediaQuery.of(context).size.height/ 7, width: double.maxFinite,
                            child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height/ 5.5, width: MediaQuery.of(context).size.width/3,
                                  child: Image.asset(consultants[index].imagePath!),
                                ),
                                const SizedBox(width: 30,),
                               Align(alignment: Alignment.bottomCenter,
                                 child: Container(height: 15, width: 15,
                                   decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                                 ),
                               ),
                               Expanded(
                                   child: Padding(
                                       padding: const EdgeInsets.symmetric(horizontal: 30),
                                     child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         Text(consultants[index].name!, style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.black),),
                                         const SizedBox(height: 10,),
                                         InkWell(
                                           onTap: (){
                                             _controller.navigateToNextPage(index: index);
                                             _controller.getSelectedItem();
                                             Get.to(()=>const ConsultantDetailsAndInformation());
                                           },
                                           child: Container(height: 35,
                                             decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
                                             child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                               children: [
                                                 const Icon(Icons.calendar_today_sharp, color: Colors.green,),
                                                 Text("View Profile", style:  Theme.of(context).textTheme.headline5!.copyWith(color: Colors.green, fontSize: 18),)
                                               ],
                                             ),
                                           ),
                                         ),
                                         const SizedBox(height: 15,),
                                         InkWell(
                                           onTap: (){
                                             _controller.navigateToNextPage(index: index);
                                             _controller.getSelectedItem();
                                             _showAvailableScheduleTime(context);
                                           },
                                           child: Container(height: 35,
                                             decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
                                             child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                               children: [
                                                 const Icon(Icons.access_time, color: Colors.green,),
                                                 Text("Schedule a Meeting", style:  Theme.of(context).textTheme.headline5!.copyWith(color: Colors.green, fontSize: 18),)
                                               ],
                                             ),
                                           ),
                                         )
                                       ],
                                     ),
                                   )
                               )
                              ],
                            ),
                          ),
                        )
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }

  void _showAvailableScheduleTime(BuildContext context){
    MyBottomSheet().showDismissibleBottomSheet(context: context, height: MediaQuery.of(context).size.height / 3, children: [
      Row(
        children: [
          Text("Working Time", style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.black,fontWeight: FontWeight.w700),),
          const SizedBox(width: 20,),
          const Icon(Icons.notifications, color: Colors.green,),
        ],
      ),
      const SizedBox(height: 30,),
      Row(
        children: [
          Text(Jiffy().format("MMMM")),
          const SizedBox(width: 20,),
          const Icon(Icons.access_time, color: Colors.green,),
        ],
      ),
      const SizedBox(height: 60,),
      DatePicker(
        DateTime.now(),
        initialSelectedDate: DateTime.now(),
        selectionColor: Colors.green,
        selectedTextColor: Colors.white,
        onDateChange: (date) {
          // New date selected
          // setState(() {
          //   _selectedValue = date;
          // });
          Get.off(()=>const ConsultantAvailableTime());
        },
      ),
    ]
    );
  }
}

class ConsultantDetails{
  String? name;
  String? imagePath;
  List<String>? dayTimeAvailableTime;
  ConsultantDetails({this.name,this.imagePath, this.dayTimeAvailableTime});

  static List<ConsultantDetails> consultantDetails = <ConsultantDetails>[
    ConsultantDetails(
      imagePath: 'assets/images/consultant1.jpg',
      name: "Dr Jack Shepherd",
    ),
    ConsultantDetails(
        imagePath: 'assets/images/consultant2.jpg',
        name: "Mr Sam Jonas",
      dayTimeAvailableTime: [
        "08:00 AM",
        "10:00 Am",
        "11:00 Am",
        "01:00 PM",
        "02:00 PM",
        "04:00 PM",
        "05:00 PM",
      ]
    ),
    ConsultantDetails(
        imagePath: 'assets/images/consultant3.jpg',
        name: "Mr Jameson Ronald",
        dayTimeAvailableTime: [
          "07:00 AM",
          "19:00 AM",
          "10:00 AM",
          "11:00 AM",
          "12:00 PM",
          "01:00 PM",
          "02:00 PM",
          "03:00 PM",
        ]
    ),
    ConsultantDetails(
        imagePath: 'assets/images/consultant4.jpg',
        name: "Mr Stephenie Sigma",
        dayTimeAvailableTime: [
          "08:00 AM",
          "09:00 AM",
          "10:00 AM",
          "11:00 AM",
          "12:00 PM",
          "01:00 PM",
          "03:00 PM",
        ]
    ),
    ConsultantDetails(
        imagePath: 'assets/images/consultant5.jpg',
        name: "Engr Lukas Dallas",
        dayTimeAvailableTime: [
          "08:00 AM",
          "10:00 AM",
          "11:00 Am",
          "01:00 PM",
          "02:00 PM",
          "03:00 PM",
          "04:00 PM",
        ]
    ),
    ConsultantDetails(
        imagePath: 'assets/images/consultant7.jpg',
        name: "Mr Ayomide Azeez",
        dayTimeAvailableTime: [
          "08:00 AM",
          "09:00 AM",
          "10:00 AM",
          "11:00 Am",
          "12:00 PM",
          "01:00 PM",
          "02:00 PM",
        ]
    ),
  ];
}
