import 'dart:convert';

QueueModel queueModelFromJson(String str) => QueueModel.fromJson(json.decode(str));

String queueModelToJson(QueueModel data) => json.encode(data.toJson());

class QueueModel {
  bool result;
  List<Queue> data;

  QueueModel({
    this.result,
    this.data,
  });

  factory QueueModel.fromJson(Map<String, dynamic> json) => QueueModel(
    result: json["result"],
    data: List<Queue>.from(json["data"].map((x) => Queue.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Queue {
  int queueId;
  int totalPrice;
  String startDate;
  String endDate;
  int reservStatus;
  String car;
  String carWashName;

  Queue({
    this.queueId,
    this.totalPrice,
    this.startDate,
    this.endDate,
    this.reservStatus,
    this.car,
    this.carWashName
  });

  factory Queue.fromJson(Map<String, dynamic> json) => Queue(
    queueId: json["queue_id"],
    totalPrice: json["total_price"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    reservStatus: json["reserv_status"],
    car: json["car"],
    carWashName: json["car_wash_name"],
  );

  Map<String, dynamic> toJson() => {
    "queue_id": queueId,
    "total_price": totalPrice,
    "start_date": startDate,
    "end_date": endDate,
    "reserv_status": reservStatus,
    "car": car,
    "car_wash_name": carWashName
  };
}
