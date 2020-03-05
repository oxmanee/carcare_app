// To parse this JSON data, do
//
//     final promotionModel = promotionModelFromJson(jsonString);

import 'dart:convert';

MemberDetailModel MemberDetailModelFromJson(String str) => MemberDetailModel.fromJson(json.decode(str));

String MemberDetailModelToJson(MemberDetailModel data) => json.encode(data.toJson());

class MemberDetailModel {
  bool result;
  List<MemberDetail> data;

  MemberDetailModel({
    this.result,
    this.data,
  });

  factory MemberDetailModel.fromJson(Map<String, dynamic> json) => MemberDetailModel(
    result: json["result"],
    data: List<MemberDetail>.from(json["data"].map((x) => MemberDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class MemberDetail {
  int memberDetailId;
  String memberLicense;
  String provinceName;
  int memberProvince;
  String car;
  int memberCarDetailId;
  int memberId;

  MemberDetail({
    this.memberDetailId,
    this.memberLicense,
    this.provinceName,
    this.memberProvince,
    this.car,
    this.memberCarDetailId,
    this.memberId,
  });

  factory MemberDetail.fromJson(Map<String, dynamic> json) => MemberDetail(
    memberDetailId: json["members_detail_id"],
    memberLicense: json["member_license"],
    provinceName: json["province_name"],
    memberProvince: json["members_province"],
    car: json["car"],
    memberCarDetailId: json["member_car_detail_id"],
    memberId: json["members_id"],
  );

  Map<String, dynamic> toJson() => {
    "members_detail_id": memberDetailId,
    "member_license": memberLicense,
    "province_name": provinceName,
    "members_province": memberProvince,
    "car": car,
    "member_car_detail_id": memberCarDetailId,
    "members_id": memberId,
  };
}
