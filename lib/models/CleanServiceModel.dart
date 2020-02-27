
import 'dart:convert';

CleanServiceModel cleanServiceModelFromJson(String str) => CleanServiceModel.fromJson(json.decode(str));

String cleanServiceToJson(CleanServiceModel data) => json.encode(data.toJson());

class CleanServiceModel {
  bool result;
  List<CleanService> data;

  factory CleanServiceModel.fromJson(Map<String, dynamic> json) =>
      CleanServiceModel(
        result: json["result"],
        data: List<CleanService>.from(
            json["data"].map((x) => CleanService.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "result": result,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  CleanServiceModel({
    this.result,
    this.data,
  });
}

class CleanService {
  int cleanServiceDetailId;
  int servicePrice;
  String serviceDuration;
  int cleanServiceId;
  int typeCarId;
  String serviceName;
  int washToolId;

  CleanService(
      {this.cleanServiceDetailId,
      this.servicePrice,
      this.serviceDuration,
      this.cleanServiceId,
      this.typeCarId,
      this.serviceName,
      this.washToolId});

  factory CleanService.fromJson(Map<String, dynamic> json) => CleanService(
      cleanServiceDetailId: json["clean_service_detail_id"],
      servicePrice: json["service_price"],
      serviceDuration: json["service_duration"],
      cleanServiceId: json["clean_service_id"],
      typeCarId: json["type_car_id"],
      serviceName: json["service_name"],
      washToolId: json["wash_tool_id"]);

  Map<String, dynamic> toJson() => {
        "clean_service_detail_id": cleanServiceDetailId,
        "service_price": servicePrice,
        "service_duration": serviceDuration,
        "clean_service_id": cleanServiceId,
        "type_car_id": typeCarId,
        "service_name": serviceName,
        "wash_tool_id": washToolId
      };
}
