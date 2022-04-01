import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/pages/speak_with_consultant.dart';

import '../controllers/consultant_detail_controller.dart';

class ConsultantDetailsAndInformation extends StatefulWidget {
  const ConsultantDetailsAndInformation({Key? key}) : super(key: key);

  @override
  _ConsultantDetailsAndInformationState createState() => _ConsultantDetailsAndInformationState();
}

class _ConsultantDetailsAndInformationState extends State<ConsultantDetailsAndInformation> {

  List<ConsultantDetails> consultants = ConsultantDetails.consultantDetails;
  final _controller = Get.put(ConsultantDetailsController());

  @override
  Widget build(BuildContext context) {
    final double tempHeight = MediaQuery.of(context).size.height - (MediaQuery.of(context).size.width / 2) + 24.0;
    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2,
                      decoration: BoxDecoration(image: DecorationImage(image: AssetImage(consultants[_controller.selectedIndex!].imagePath!), fit: BoxFit.fitHeight)),
                      child: Stack(
                        children: [
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 50),
                            child:  Row(
                              children: [
                                Container(
                                    height: MediaQuery.of(context).size.width / 9,
                                    width: MediaQuery.of(context).size.width / 9,
                                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle),
                                    child: IconButton(
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(Icons.clear, color: Colors.white,),)),

                              ],
                            ),
                          )],
                      ),
                    ),
                  ],
                ),
                Positioned(top: 530,bottom: 0,left: 0,right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(32.0),
                            topRight: Radius.circular(32.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              offset: const Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),
                      child: Container(
                        constraints: BoxConstraints(
                            minHeight: 365,
                            maxHeight: tempHeight > 365 ? tempHeight : 365
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 25),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 35,),
                                Text(consultants[_controller.selectedIndex!].name!, style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.black, fontSize: 35, fontWeight: FontWeight.w700),),
                                const SizedBox(height: 15,),
                                Text("Specialist in matter relating to anxiety, self-esteem and depression with over 4 years of experience", style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.black, fontSize: 18,),),
                                const SizedBox(height: 15,),
                                Container(
                                  height: 90, width: double.maxFinite,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.green),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                    child: Row(children: [
                                      Icon(Icons.access_time, color: Colors.white, size: 50,),
                                      SizedBox(width: 15,),
                                      Column(mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("1 hour Session", style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w700),),
                                          SizedBox(height: 10,),
                                          Text("N20,000", style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.white, fontSize: 20),),
                                        ],
                                      )
                                    ],),
                                  ),
                                ),
                                const SizedBox(height: 20,),

                                Container(
                                  height: 90, width: double.maxFinite,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.green),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                    child: Row(children: [
                                      const Icon(Icons.access_time, color: Colors.white, size: 50,),
                                      const SizedBox(width: 15,),
                                      Column(mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Fluent In", style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w700),),
                                          const SizedBox(height: 10,),
                                          Text("English | Chinese | Yoruba", style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.white, fontSize: 20),),
                                        ],
                                      ),
                                    ],),
                                  ),
                                ),

                                const SizedBox(height: 20,),

                                Container(
                                  height: 90, width: double.maxFinite,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                    child: Row(children: [
                                      const Icon(Icons.access_time, color: Colors.black, size: 50,),
                                      const SizedBox(width: 15,),
                                      Column(mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("My current Location", style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.black, fontSize: 23, fontWeight: FontWeight.w700),),
                                          const SizedBox(height: 10,),
                                          Text("Nigeria/Lagos", style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.black, fontSize: 20),),
                                        ],
                                      ),
                                    ],),
                                  ),
                                ),
                                
                              ]
                          ),
                        ),
                      ),
                    )
                )
              ],
            )
        )
    );
  }
}
