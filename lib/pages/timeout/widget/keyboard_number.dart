// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:tranquil_life/constants/style.dart';
// import 'package:tranquil_life/helpers/constants.dart';
// import 'package:tranquil_life/helpers/sizes_helpers.dart';
//
// class KeyboardNumber extends StatelessWidget{
//   final int n;
//   final Function() onPressed;
//    KeyboardNumber({required this.n, required this.onPressed});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: displayWidth(context)*0.12,
//       height: displayHeight(context)*0.12,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: kPrimaryColor.withOpacity(0.1),
//       ),
//       alignment: Alignment.center,
//       child: MaterialButton(
//         padding: const EdgeInsets.all(8.0),
//         onPressed: onPressed,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(60.0),
//         ),
//         height: 90.0,
//         child: Text(
//           '$n',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//               fontSize: 24*MediaQuery.of(context).textScaleFactor,
//               color: Colors.white,
//               fontWeight: FontWeight.bold
//           ),
//         ),
//       ),
//     );
//   }
//
// }
