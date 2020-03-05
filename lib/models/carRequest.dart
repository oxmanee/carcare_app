
import 'dart:convert';

class CarRequest{
  int car;
  String license;
  int province;

  CarRequest({
    this.car,
    this.license,
    this.province
  });

  factory CarRequest.fromJson(Map<String, dynamic> json) => CarRequest(
    car: json["car"],
    license: json["license"],
    province: json["province"],
  );

  Map<String, dynamic> toJson() => {
    "car": car,
    "license": license,
    "province": province
  };

  @override
  String toString() {
    return 'CarRequest{car: $car, license: $license, province: $province}';
  }


}