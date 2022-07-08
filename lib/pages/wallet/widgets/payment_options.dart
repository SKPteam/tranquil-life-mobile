// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/app_font.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/controllers/wallet_controller.dart';
import 'package:tranquil_life/pages/webview/webview.dart';

class PaymentOptions extends StatelessWidget {

  final WalletController _walletController = Get.put(WalletController());

  final figure;

  PaymentOptions({Key? key, this.figure}) : super(key: key);

  Size size = MediaQuery.of(Get.context!).size;

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}

/*
* Container(
      decoration:
      BoxDecoration(color: Colors.white),
      height: size.height * 0.5,
      padding: EdgeInsets.fromLTRB(
          16.0, 16.0, 16.0, 0),
      child: ListView.builder(
          itemCount: top_up_figures.length,
          itemBuilder: (BuildContext context,
              int index) {
            //Figues list
            return ListTile(
              title: InkWell(
                onTap: () async{
                  _walletController.figure.value
                  = (_walletController.rate! *
                      double.parse(
                          top_up_figures[
                          index]
                              .toString()))
                      .toStringAsFixed(3);

                  Get.back();


                  ///Payment Options Bottom Sheet
                  await Get.bottomSheet(
                      Container(
                        decoration: BoxDecoration(color: Colors.white),
                        height: size.height * 0.5,
                        padding: EdgeInsets.fromLTRB(
                            16.0, 16.0, 16.0, 0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Pay with", style: TextStyle(fontSize: 18, fontFamily: josefinSansBold)),
                              SizedBox(height: 20),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: payment_options.length,
                                  itemBuilder: (BuildContext context,
                                      int index){
                                    return ListTile(
                                      title: InkWell(
                                        onTap: () async{
                                          print(_walletController.figure.value);

                                          await _walletController.initialize(
                                              "ayomideseaz@gmail.com",
                                              "+2348130308873",
                                              "Ayomide Ajayi").then((value){
                                            print("$value");

                                            return Navigator.push(context, MaterialPageRoute(builder: (context)=> WebViewUI(
                                                url: "$value"
                                            )));
                                          });
                                        },
                                        child: Text(payment_options[index]),
                                      ),
                                    );
                                  }
                              )
                            ],
                          ),
                        ),
                      )
                  );


                },
                child: Text(
                  "\$${double.parse(top_up_figures[index].toString())}",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            );
          }),
    )
* */