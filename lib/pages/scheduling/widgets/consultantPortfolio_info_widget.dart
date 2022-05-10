// ignore_for_file: prefer__ructors, prefer__ructors_in_immutables, prefer__literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_full_hex_values_for_flutter_colors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:get/get_core/src/get_main.dart';


class ConsultantProfileInfoWidget extends StatefulWidget {
  final String? fName;
  final String? lName;
  final double? latitude;
  final double? longitude;
  final List? specialties;
  final String? yearsOfExperience;
  final double? fee;
  final List? languages;

  ConsultantProfileInfoWidget({
    Key? key,
    this.fName,
    this.lName,
    this.latitude,
    this.longitude,
    this.specialties,
    this.yearsOfExperience,
    this.fee, this.languages}) : super(key: key);


  @override
  _ConsultantProfileInfoWidgetState createState() =>
      _ConsultantProfileInfoWidgetState();
}

class _ConsultantProfileInfoWidgetState

    extends State<ConsultantProfileInfoWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _sliderAnimation;

  Size size = MediaQuery.of(Get.context!).size;

  String description = "";

  @override
  void initState() {
    super.initState();

    setState(() {
      description = "Specialist in matters relating to ${widget.specialties.toString()}";
    });

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _sliderAnimation =
        Tween<double>(begin: 400, end: 0).animate(_animationController)
          ..addListener(() {
            setState(() {});
          });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, _sliderAnimation.value),
      child: Container(
        padding: EdgeInsets.all(35),
        height: size.height * 0.55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        //------------------------
        // SCROLL VIEW FOR INFO SO THAT CONTAINERS DON'T
        // GO BELOW THE SCREEN [OVERFLOWED]
        //------------------------
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //------------------------
              // CONSULTANT NAME
              //------------------------
              Text(
                widget.fName! +
                    ' ' +
                    widget.lName!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(
                height: 20,
              ),
              //------------------------
              // CONSULTANT DESIGNATION
              //------------------------
              Text(
                description,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              SizedBox(
                height: 20,
              ),
              //------------------------
              // SESSION CONTAINER
              //------------------------
              Container(
                height: size.height * 0.08,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: kPrimaryColor,
                ),
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.schedule,
                      size: size.width * 0.05,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '1 hour session',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                widget.fee.toString(),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //------------------------
              // FLUENCY CONTAINER
              //------------------------
              Container(
                height: size.height * 0.08,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: kPrimaryColor,
                ),
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.language,
                      size: size.width * 0.05,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fluent in',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Expanded(
                            child: Text(
                              '${widget.languages!.isEmpty ? 'Any' : widget.languages}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //------------------------
              // CURRENT LOCATION CONTAINER
              //------------------------
              Container(
                height: size.height * 0.08,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xffFF9E9E9E),
                  ),
                ),
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.place,
                      size: size.width * 0.05,
                      color: kPrimaryColor,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My current location',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Expanded(
                            child: Text(
                              'consultantProfileModel.location!',
                              //'${consultantProfileModel.location!.isEmpty ? '' : consultantProfileModel.location}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}