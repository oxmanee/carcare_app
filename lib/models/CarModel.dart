import 'dart:convert';

CarModel carModelFromJson(String str) => CarModel.fromJson(json.decode(str));

String carModelToJson(CarModel data) => json.encode(data.toJson());

class CarModel {
  bool result;
  List<CarDetail> data;

  CarModel({
    this.result,
    this.data,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
        result: json["result"],
        data: List<CarDetail>.from(
            json["data"].map((x) => CarDetail.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "result": result,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CarDetail {
  int carDetailId;
  String modelName;
  String brand;
  String size;
  int typeCarId;

  CarDetail(
      {this.carDetailId,
      this.modelName,
      this.brand,
      this.size,
      this.typeCarId});

  factory CarDetail.fromJson(Map<String, dynamic> json) => CarDetail(
      carDetailId: json["member_car_detail_id"],
      modelName: json["model_name"],
      brand: json["brand"],
      size: json["size"],
      typeCarId: json["type_car_id"]);

  Map<String, dynamic> toJson() => {
        "car_detail_id": carDetailId,
        "model_name": modelName,
        "brand": brand,
        "size": size,
        "type_car_id": typeCarId
      };
}
