// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:tranquil_life/constants/style.dart';
// import 'package:tranquil_life/helpers/sizes_helpers.dart';
//
// ///Container for building individual time Slot
// class TimeSlotContainer extends StatelessWidget {
//   const TimeSlotContainer({
//     Key? key,
//     required this.time,
//     this.selectedIndexOfTimeSlot,
//     this.selectedIndexOfTimeSlotsList,
//     required this.bookedIndex,
//     this.enabled = true,
//     required this.indexOfTimeSlot,
//     this.onTapped,
//   }) :
//   // assert(
//   //           (selectedIndexOfTimeSlot == null &&
//   //                   selectedIndexOfTimeSlotsList != null) ||
//   //               selectedIndexOfTimeSlotsList == null,
//   //           'if selectedIndexOfTimeSlotsList is null, then selectedIndexOfTimeSlot must not be null and vice Versa'),
//         super(key: key);
//
//   final String time;
//   final int? selectedIndexOfTimeSlot;
//   final List<int>? selectedIndexOfTimeSlotsList;
//   final List<int>? bookedIndex;
//   final bool enabled;
//   final int indexOfTimeSlot;
//   final Function(int)? onTapped;
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         print('tapped on TimeSlot');
//         //changing the index of the selected Time Slot
//         onTapped?.call(indexOfTimeSlot);
//       },
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         width: (displayWidth(context) * 0.86 / 4) - 10,
//         height: 40,
//         decoration: BoxDecoration(
//           color: enabled || (bookedIndex!.contains(indexOfTimeSlot))
//               ? bookedIndex?.contains(indexOfTimeSlot) ?? false
//               ? Colors.blue
//               : (selectedIndexOfTimeSlot == indexOfTimeSlot ||
//               (selectedIndexOfTimeSlotsList != null &&
//                   selectedIndexOfTimeSlotsList!
//                       .contains(indexOfTimeSlot)))
//               ? kPrimaryColor
//               : Colors.white
//               : Colors.red[100],
//           borderRadius: BorderRadius.circular(8),
//         ),
//         //------------------------
//         // TItle
//         //------------------------
//         child: Center(
//           child: FittedBox(
//             fit: BoxFit.scaleDown,
//             child: Text(
//               time,
//               style: TextStyle(
//                 color:
//                 enabled || (bookedIndex?.contains(indexOfTimeSlot) ?? false)
//                     ? bookedIndex?.contains(indexOfTimeSlot) ?? false
//                     ? Colors.white
//                     : (selectedIndexOfTimeSlot == indexOfTimeSlot ||
//                     (selectedIndexOfTimeSlotsList != null &&
//                         selectedIndexOfTimeSlotsList!
//                             .contains(indexOfTimeSlot)))
//                     ? Colors.white
//                     : Colors.grey[600]
//                     : Colors.red[300],
//                 fontSize: 14,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }