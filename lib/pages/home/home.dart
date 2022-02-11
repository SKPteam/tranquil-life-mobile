// // ignore_for_file: avoid_unnecessary_containers, prefer__ructors, prefer__literals_to_create_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables
//
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:tranquil_life/constants/style.dart';
// import 'package:tranquil_life/helpers/responsive_safe_area.dart';
// import 'package:tranquil_life/helpers/sizes_helpers.dart';
// import 'package:tranquil_life/pages/home/widgets/meetings_section.dart';
// import 'package:tranquil_life/pages/scheduling/consultant_list_view.dart';
// import 'package:tranquil_life/routes/app_pages.dart';
// import 'package:tranquil_life/widgets/custom_text.dart';
// import 'package:tranquil_life/widgets/top_nav.dart';
//
// import 'widgets/moods_section.dart';
// import 'widgets/notificationBadge.dart';
//
// class Home extends StatelessWidget {
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
//
//   bool? toggleValue = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey,
//       backgroundColor: light,
//       appBar: topNavigationBar(context, scaffoldKey),
//       body: ResponsiveSafeArea(
//         responsiveBuilder: (context, size){
//           return Stack(
//             children: [
//               Container(
//                 height: size.height * .35,
//                 decoration: BoxDecoration(
//                   color: lightBgColor,
//                   gradient: LinearGradient(
//                       colors: [Color(0xffC9D8CD), lightBgColor],
//                       begin: Alignment.bottomCenter,
//                       end: Alignment.topCenter),
//                 ),
//               ),
//
//               Container(
//                 width: double.infinity,
//                 margin: EdgeInsets.only(
//                     left: size.width * 0.1,
//                     top: size.width * 0.1),
//                 child: Stack(
//                   children: [
//                     SizedBox(
//                         width: size.width * 0.6,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Hi,',
//                               style: TextStyle(
//                                 color: active,
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.normal,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             CustomText(
//                               text: "Joseph",
//                               color: active,
//                               weight: FontWeight.w700,
//                               size: 28,
//                               align: TextAlign.start,
//                             ),
//                           ],
//                         )),
//
//                     Positioned(
//                         right: size.width * 0.1,
//                         child: Padding(
//                           padding: EdgeInsets.only(
//                               top: size.width * 0.01),
//
//                           child: Row(
//                             children: [
//                               GestureDetector(
//                                 onTap: (){
//                                   //Get.toNamed(Routes.CONSULTANT_LIST);
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(builder: (context)
//                                       => ConsultantListView()));
//
//                                   print("Consutlant list");
//                                 },
//                                 child: Container(
//                                   margin: EdgeInsets.only(
//                                       left: size.width * 0.2),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white70,
//                                     borderRadius:
//                                     BorderRadius.circular(10.0),
//                                     boxShadow:  [
//                                       BoxShadow(
//                                         color: Colors.grey,
//                                         blurRadius: 10,
//                                         spreadRadius: 0,
//                                         offset: Offset(3, 6),
//                                       ),
//                                     ],
//                                   ),
//                                   child: SizedBox(
//                                       width: 46,
//                                       height: 46,
//                                       child: Icon(
//                                         Icons.people,
//                                         size: 28,
//                                         color: active,
//                                       )),
//                                 ),
//                               )
//                             ],
//                           ),
//                         )
//                     )
//                   ],
//                 ),
//               )
//
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
