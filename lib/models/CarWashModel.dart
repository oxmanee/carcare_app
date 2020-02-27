import 'dart:convert';

CarWashModel carModelFromJson(String str) => CarWashModel.fromJson(json.decode(str));

String carModelToJson(CarWashModel data) => json.encode(data.toJson());

class CarWashModel {
  bool result;
  List<CarWash> data;

  CarWashModel({
    this.result,
    this.data,
  });

  factory CarWashModel.fromJson(Map<String, dynamic> json) => CarWashModel(
    result: json["result"],
    data: List<CarWash>.from(
        json["data"].map((x) => CarWash.fromJson(x))),
  );
  Map<String, dynamic> toJson() => {
    "result": result,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CarWash {
  int carWashId;
  String carWashName;
  int employeeId;

  CarWash(
      {this.carWashId,
        this.carWashName,
        this.employeeId});

  factory CarWash.fromJson(Map<String, dynamic> json) => CarWash(
      carWashId: json["car_wash_id"],
      carWashName: json["car_wash_name"],
      employeeId: json["employee_id"]);

  Map<String, dynamic> toJson() => {
    "car_wash_id": carWashId,
    "car_wash_name": carWashName,
    "employee_id": employeeId,
  };
}
