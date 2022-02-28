// ignore_for_file: file_names

import 'dart:math';

import 'package:tranquil_life/pages/wallet/widgets/card_color.dart';

class CardModel {
  int? id;
  String? cardOwner;
  String? cardNumber;
  String? cardType;
  String? cardExpiryMonth;
  String? cardExpiryYear;
  String? cvv;
  bool? isDefault;

  CardColor? color;
  String? logoAsset;

  CardModel(
      {this.id,
        this.cardOwner,
        this.cardNumber,
        this.cardType,
        this.cardExpiryMonth,
        this.cardExpiryYear,
        this.cvv,
        this.isDefault}){
    var ran = Random().nextInt(4);
    color = CardColor.values[ran];
  }

  CardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cardOwner = json['cardOwner'];
    cardNumber = json['cardNumber'];
    cardType = json['cardType'];
    cardExpiryMonth = json['cardExpiryMonth'];
    cardExpiryYear = json['cardExpiryYear'];
    cvv = json['cvv'];
    isDefault = json['isDefault'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cardOwner'] = this.cardOwner;
    data['cardNumber'] = this.cardNumber;
    data['cardType'] = this.cardType;
    data['cardExpiryMonth'] = this.cardExpiryMonth;
    data['cardExpiryYear'] = this.cardExpiryYear;
    data['cvv'] = this.cvv;
    data['isDefault'] = this.isDefault;
    return data;
  }
}