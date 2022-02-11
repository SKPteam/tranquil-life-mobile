// ignore_for_file: prefer__ructors, prefer__ructors_in_immutables, prefer__literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_full_hex_values_for_flutter_colors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';
import 'package:tranquil_life/models/consultant_porfolio_model.dart';
import 'package:tranquil_life/models/consultant_profile_model.dart';

class ConsultantProfileInfoWidget extends StatefulWidget {
  // final ConsultantProfileModel consultantProfileModel;
  //  ConsultantProfileInfoWidget({required Key? key, required this.consultantProfileModel})
  //     : super(key: key);

  late final ConsultantPortfolioModel consultantProfileModel;

  ConsultantProfileInfoWidget({Key? key, required this.consultantProfileModel})
      : super(key: key);

  @override
  _ConsultantProfileInfoWidgetState createState() =>
      _ConsultantProfileInfoWidgetState();
}

class _ConsultantProfileInfoWidgetState
    extends State<ConsultantProfileInfoWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _sliderAnimation;

  @override
  void initState() {
    super.initState();
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
    var consultantProfileModel = widget.consultantProfileModel;
    return Transform.translate(
      offset: Offset(0, _sliderAnimation.value),
      child: Container(
        padding: EdgeInsets.all(35),
        height: displayHeight(context) * 0.55,
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
                consultantProfileModel.f_name! +
                    ' ' +
                    consultantProfileModel.l_name!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(
                height: 20,
              ),
              //------------------------
              // CONSULTANT DESIGNATION
              //------------------------
              Text(
                'consultantProfileModel.description!',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              SizedBox(
                height: 20,
              ),
              //------------------------
              // SESSION CONTAINER
              //------------------------
              Container(
                height: displayHeight(context) * 0.08,
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
                      size: displayWidth(context) * 0.05,
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
                                'consultantProfileModel.fee',
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
                height: displayHeight(context) * 0.08,
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
                      size: displayWidth(context) * 0.05,
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
                              'consultantProfileModel.preferredLangs',
                              //'${consultantProfileModel.preferredLangs!.isEmpty ? 'Any' : consultantProfileModel.preferredLangs}',
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
                height: displayHeight(context) * 0.08,
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
                      size: displayWidth(context) * 0.05,
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