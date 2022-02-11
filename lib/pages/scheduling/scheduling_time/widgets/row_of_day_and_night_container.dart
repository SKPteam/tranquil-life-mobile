// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:tranquil_life/constants/style.dart';
// import 'package:tranquil_life/helpers/sizes_helpers.dart';
//
// /// Row of DayTime and NightTime containers
// class RowOfDayAndNightContainer extends StatefulWidget {
//   const RowOfDayAndNightContainer({Key? key, this.onAnyContainerTapped})
//       : super(key: key);
//   final Function(int)? onAnyContainerTapped;
//   @override
//   _RowOfDayAndNightContainerState createState() =>
//       _RowOfDayAndNightContainerState();
// }
//
// class _RowOfDayAndNightContainerState extends State<RowOfDayAndNightContainer> {
//   int selectedIndexOfTimeSections = 0;
//   final List<Map<String, String>> timeSections = [
//     {'svgUrl': 'assets/icons/icon-sunny.svg', 'title': 'Daytime'},
//     {'svgUrl': 'assets/icons/icon-partly-sunny.svg', 'title': 'Nightime'}
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: displayWidth(context) * 0.07),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: timeSections.map(
//               (timeSectionItem) {
//             int index = timeSections.indexOf(timeSectionItem);
//             //------------------------
//             // TIME SECTON CONTAINER
//             //------------------------
//             return InkWell(
//               onTap: () {
//                 //setting the state by changing the timeSections
//                 setState(() {
//                   //changing the selected index of the sections of the time
//                   selectedIndexOfTimeSections = index;
//                 });
//
//                 //calling the external function
//                 widget.onAnyContainerTapped?.call(index);
//               },
//               child: Container(
//                 width: displayWidth(context) * 0.405,
//                 height: 70,
//                 decoration: BoxDecoration(
//                   color: selectedIndexOfTimeSections == index
//                       ? kPrimaryColor
//                       : Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 //------------------------
//                 // Row of svg and heading
//                 //------------------------
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Container(
//                       width: 45,
//                       height: 45,
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: selectedIndexOfTimeSections == index
//                             ? Colors.white
//                             : kLightBackgroundColor,
//                       ),
//                       child: SvgPicture.asset(
//                         timeSectionItem['svgUrl']!,
//                         color: selectedIndexOfTimeSections == index
//                             ? kPrimaryColor
//                             : Colors.grey[600],
//                         fit: BoxFit.none,
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 15,
//                     ),
//                     //------------------------
//                     // TITLE
//                     //------------------------
//                     Expanded(
//                       child: FittedBox(
//                         fit: BoxFit.scaleDown,
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           timeSectionItem['title']!,
//                           style: TextStyle(
//                             color: selectedIndexOfTimeSections == index
//                                 ? Colors.white70
//                                 : Colors.grey[600],
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ).toList(),
//       ),
//     );
//   }
// }