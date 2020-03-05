import 'dart:convert';

ProvinceModel provinceModelFromJson(String str) => ProvinceModel.fromJson(json.decode(str));

String provinceModelToJson(ProvinceModel data) => json.encode(data.toJson());

class ProvinceModel {
  bool result;
  List<Province> data;

  ProvinceModel({
    this.result,
    this.data,
  });

  factory ProvinceModel.fromJson(Map<String, dynamic> json) => ProvinceModel(
    result: json["result"],
    data: List<Province>.from(json["data"].map((x) => Province.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Province {
  int provinceId;
  String provinceName;

  Province({
    this.provinceId,
    this.provinceName,
  });

  factory Province.fromJson(Map<String, dynamic> json) => Province(
    provinceId: json["province_id"],
    provinceName: json["province_name"],
  );

  Map<String, dynamic> toJson() => {
    "province_id": provinceId,
    "province_name": provinceName,
  };
}
