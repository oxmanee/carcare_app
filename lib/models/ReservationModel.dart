import 'dart:convert';

ReservationModel reserveModelFromJson(String str) => ReservationModel.fromJson(json.decode(str));

String reserveModelToJson(ReservationModel data) => json.encode(data.toJson());

class ReservationModel {
  bool result;
  List<Reservation> data;

  ReservationModel({
    this.result,
    this.data,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) => ReservationModel(
    result: json["result"],
    data: List<Reservation>.from(json["data"].map((x) => Reservation.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Reservation {
  int reservId;
  int totalPrice;
  String startDate;
  String endDate;
  int reservStatus;
  int employeeId;
  int membersId;
  int carDetailId;
  int carWashId;
  int cleanServiceDetailId;
  int queueId;

  Reservation({
    this.reservId,
    this.totalPrice,
    this.startDate,
    this.endDate,
    this.reservStatus,
    this.employeeId,
    this.membersId,
    this.carDetailId,
    this.carWashId,
    this.cleanServiceDetailId,
    this.queueId
  });

  factory Reservation.fromJson(Map<String, dynamic> json) => Reservation(
    reservId: json["reserv_id"],
    totalPrice: json["total_price"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    reservStatus: json["reserv_status"],
    employeeId: json["employee_id"],
    membersId: json["members_id"],
    carDetailId: json["car_detail_id"],
    carWashId: json["car_wash_id"],
    cleanServiceDetailId: json["clean_service_detail_id"],
    queueId: json["queue_id"],
  );

  Map<String, dynamic> toJson() => {
    "reserv_id": reservId,
    "total_price": totalPrice,
    "start_date": startDate,
    "end_date": endDate,
    "reserv_status": reservStatus,
    "employee_id": employeeId,
    "members_id": membersId,
    "car_detail_id": carDetailId,
    "car_wash_id": carWashId,
    "clean_service_detail_id": cleanServiceDetailId,
    "queue_id": queueId,
  };
}
