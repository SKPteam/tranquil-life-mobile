import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:get/get.dart';

class ConsultantAvailableTime extends StatefulWidget {
  const ConsultantAvailableTime({Key? key}) : super(key: key);

  @override
  State<ConsultantAvailableTime> createState() => _ConsultantAvailableTimeState();
}

class _ConsultantAvailableTimeState extends State<ConsultantAvailableTime> {
  //final _controller = Get.put(ConsultantDetailsController());
  //List<ConsultantDetails> consultants = ConsultantDetails.consultantDetails;

  bool? isDayTimeSelected = true;
  bool? isNightTimeSelected = false;

  Widget _dayTimeAvailableButton({void Function()? onTap}){
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 70, width: MediaQuery.of(context).size.width/ 3,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: isDayTimeSelected == true ?  Colors.green : Colors.white),
        child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 45, width: 45,
              decoration: BoxDecoration(color: isDayTimeSelected == true ? Colors.white : Colors.grey.shade300, borderRadius: BorderRadius.circular(5)),
              child: Icon(Icons.calendar_today_outlined, color: isDayTimeSelected == true ? Colors.green : Colors.black,),
            ),
            const SizedBox(width: 10,),
            Text("DayTime", style: Theme.of(context).textTheme.headline5?.copyWith(color: isDayTimeSelected == true ? Colors.white : Colors.black
                , fontWeight: FontWeight.w400, fontSize: 18),),
          ],
        ),
      ),
    );
  }
  Widget _nightTimeAvailableButton({void Function()? onTap}){
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 70, width: MediaQuery.of(context).size.width/ 3,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: isNightTimeSelected == true ? Colors.green : Colors.white),
        child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 45, width: 45,
              decoration: BoxDecoration(color: isNightTimeSelected == true ? Colors.white : Colors.grey.shade300, borderRadius: BorderRadius.circular(5)),
              child: Icon(Icons.calendar_today_outlined, color: isNightTimeSelected == true ? Colors.green : Colors.black,),
            ),
            const SizedBox(width: 10,),
            Text("NightTime", style: Theme.of(context).textTheme.headline5?.copyWith(color:isNightTimeSelected == true ? Colors.white : Colors.black,
                 fontWeight: FontWeight.w400, fontSize: 18),),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    String date = Jiffy(DateTime.now()).yMMMMEEEEd;
    return SafeArea(bottom: false, top: false,
        child: Scaffold(backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            centerTitle: true, elevation: 0.0, backgroundColor: Colors.transparent,
            //title: Text(consultants[_controller.selectedIndex!].name!, style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.black, fontWeight: FontWeight.w400),),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50,),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _dayTimeAvailableButton(onTap: (){
                      setState(() {
                        isNightTimeSelected = false;
                        isDayTimeSelected = true;
                      });
                    }),
                    _nightTimeAvailableButton(onTap: (){
                      setState(() {
                        isDayTimeSelected = false;
                        isNightTimeSelected = true;
                      });
                    }),
                  ],
                ),
                const SizedBox(height: 60,),
                // Wrap(crossAxisAlignment: WrapCrossAlignment.start,
                //   children: [
                //     ...consultants[_controller.selectedIndex!].dayTimeAvailableTime!.map((e) =>Padding(
                //       padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                //       child: Container(
                //         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)), height: 60, width: MediaQuery.of(context).size.width/3.5,
                //         child: Center(child: Text(e, style:Theme.of(context).textTheme.headline5?.copyWith(color: Colors.black, fontSize: 20),)),
                //       ),
                //     ))
                //   ],
                // ),
                const SizedBox(height: 80,),

                Container(
                  height: 90, width: double.maxFinite,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(children: [
                      const Icon(Icons.access_time, color: Colors.black, size: 50,),
                      const Spacer(),
                      Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Date", style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.black, fontSize: 23, fontWeight: FontWeight.w700),),
                          const SizedBox(height: 10,),
                          Text(date, style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.black, fontSize: 20),),
                        ],
                      ),
                      const Spacer(flex: 4,),
                    ],),
                  ),
                ),

                const SizedBox(height: 50,),

                Container(
                  height: 90, width: double.maxFinite,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(children: [
                      const Icon(Icons.access_time, color: Colors.black, size: 50,),
                      const Spacer(),
                      Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Fee", style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.black, fontSize: 23, fontWeight: FontWeight.w700),),
                          const SizedBox(height: 10,),
                          Text("N20,000", style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.black, fontSize: 20),),
                        ],
                      ),
                      const Spacer(flex: 4,),
                    ],),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
