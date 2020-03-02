// To parse this JSON data, do
//
//     final resultModel = resultModelFromJson(jsonString);

import 'dart:convert';

ResultModel resultModelFromJson(String str) => ResultModel.fromJson(json.decode(str));

String resultModelToJson(ResultModel data) => json.encode(data.toJson());

class ResultModel {
  String result;
  String data;

  ResultModel({
    this.result,
    this.data,
  });

  factory ResultModel.fromJson(Map<String, dynamic> json) => ResultModel(
    result: json["result"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "data": data,
  };
}
