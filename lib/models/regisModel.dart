import 'dart:convert';

RegisModel regisModelFromJson(String str) => RegisModel.fromJson(json.decode(str));

String regisModelToJson(RegisModel data) => json.encode(data.toJson());

class RegisModel {
  String username;
  String password;
  String fname;
  String lname;
  String address;
  String tel;
  String cashierId;

  RegisModel({
    this.username,
    this.password,
    this.fname,
    this.lname,
    this.address,
    this.tel,
    this.cashierId,
  });

  factory RegisModel.fromJson(Map<String, dynamic> json) => RegisModel(
    username: json["username"],
    password: json["password"],
    fname: json["fname"],
    lname: json["lname"],
    address: json["address"],
    tel: json["tel"],
    cashierId: json["cashier_id"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password,
    "fname": fname,
    "lname": lname,
    "address": address,
    "tel": tel,
    "cashier_id": cashierId,
  };
}
