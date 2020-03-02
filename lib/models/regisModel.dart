import 'dart:convert';

import 'package:booking_carcare_app/models/carRequest.dart';

RegisModel regisModelFromJson(String str) => RegisModel.fromJson(json.decode(str));

String regisModelToJson(RegisModel data) => json.encode(data.toJson());

class RegisModel {
  String username;
  String password;
  String fname;
  String lname;
  String address;
  String tel;
  int cashierId;
  List<CarRequest> carDetail;

  RegisModel({
    this.username,
    this.password,
    this.fname,
    this.lname,
    this.address,
    this.tel,
    this.carDetail
  });

  factory RegisModel.fromJson(Map<String, Object> json) => RegisModel(
    username: json["username"],
    password: json["password"],
    fname: json["fname"],
    lname: json["lname"],
    address: json["address"],
    tel: json["tel"],
      carDetail: json["car_detail_id"]
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password,
    "fname": fname,
    "lname": lname,
    "address": address,
    "tel": tel,
    "car_detail_id" : carDetail
  };


}
