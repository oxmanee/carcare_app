import 'dart:convert';

import 'package:booking_carcare_app/pages/profile_member.dart';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  int id;
  String fname;
  String lname;
  String address;
  String tel;
  int cashierId;
  List<MemdetailForm> carDetail;

  ProfileModel({
    this.id,
    this.fname,
    this.lname,
    this.address,
    this.tel,
    this.cashierId,
    this.carDetail
  });

  factory ProfileModel.fromJson(Map<String, Object> json) => ProfileModel(
    id: json['id'],
    fname: json["fname"],
    lname: json["lname"],
    address: json["address"],
    tel: json["tel"],
      carDetail: json["car_detail_id"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fname": fname,
    "lname": lname,
    "address": address,
    "tel": tel,
    "cashier_Id" : this.cashierId,
    "car_detail_id" : carDetail
  };
}

class MemdetailForm {
  int memberCarId;
  String memberLicense;
  int memberProvinceId;

  MemdetailForm({this.memberCarId , this.memberLicense , this.memberProvinceId});

  Map<String, dynamic> toJson() => {
    "memberCarId": memberCarId,
    "memberLicense": memberLicense,
    "memberProvinceId": memberProvinceId,
  };

  @override
  String toString() {
    return 'MemdetailForm{memberCarId: $memberCarId, memberLicense: $memberLicense, memberProvinceId: $memberProvinceId}';
  }


}
