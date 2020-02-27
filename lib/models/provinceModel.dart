// To parse this JSON data, do
//
//     final provinceModel = provinceModelFromJson(jsonString);

import 'dart:convert';

ProvinceModel provinceModelFromJson(String str) => ProvinceModel.fromJson(json.decode(str));

String provinceModelToJson(ProvinceModel data) => json.encode(data.toJson());

class ProvinceModel {
  bool result;
  List<Datum> data;

  ProvinceModel({
    this.result,
    this.data,
  });

  factory ProvinceModel.fromJson(Map<String, dynamic> json) => ProvinceModel(
    result: json["result"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int provinceId;
  String provinceName;

  Datum({
    this.provinceId,
    this.provinceName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    provinceId: json["province_id"],
    provinceName: json["province_name"],
  );

  Map<String, dynamic> toJson() => {
    "province_id": provinceId,
    "province_name": provinceName,
  };
}
