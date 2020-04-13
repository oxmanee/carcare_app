// To parse this JSON data, do
//
//     final carAllModel = carAllModelFromJson(jsonString);

import 'dart:convert';

CarAllModel carAllModelFromJson(String str) => CarAllModel.fromJson(json.decode(str));

String carAllModelToJson(CarAllModel data) => json.encode(data.toJson());

class CarAllModel {
  bool result;
  List<Datum> data;

  CarAllModel({
    this.result,
    this.data,
  });

  factory CarAllModel.fromJson(Map<String, dynamic> json) => CarAllModel(
    result: json["result"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int carId;
  String brand;

  Datum({
    this.carId,
    this.brand,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    carId: json["car_id"],
    brand: json["brand"],
  );

  Map<String, dynamic> toJson() => {
    "car_id": carId,
    "brand": brand,
  };
}
