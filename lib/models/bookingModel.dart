// To parse this JSON data, do
//
//     final bookingModel = bookingModelFromJson(jsonString);

import 'dart:convert';

BookingModel bookingModelFromJson(String str) =>
    BookingModel.fromJson(json.decode(str));

String bookingModelToJson(BookingModel data) => json.encode(data.toJson());

class BookingModel {
  int memberId;
  int carDetailId;
  int carWashId;
  String startTime;
  String queueDate;
  List<int> cleanServiceDetailId;

  BookingModel({
    this.memberId,
    this.carDetailId,
    this.carWashId,
    this.startTime,
    this.queueDate,
    this.cleanServiceDetailId,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        memberId: json["member_id"],
        carDetailId: json["car_detail_id"],
        carWashId: json["car_wash_id"],
        startTime: json["start_time"],
        queueDate: json["queue_date"],
        cleanServiceDetailId:
            List<int>.from(json["clean_service_detail_id"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "member_id": memberId,
        "car_detail_id": carDetailId,
        "car_wash_id": carWashId,
        "start_time": startTime,
        "queue_date": queueDate,
        "clean_service_detail_id":
            List<dynamic>.from(cleanServiceDetailId.map((x) => x)),
      };
}
