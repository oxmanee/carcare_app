// To parse this JSON data, do
//
//     final promotionModel = promotionModelFromJson(jsonString);

import 'dart:convert';

PromotionModel promotionModelFromJson(String str) => PromotionModel.fromJson(json.decode(str));

String promotionModelToJson(PromotionModel data) => json.encode(data.toJson());

class PromotionModel {
  bool result;
  List<Datum> data;

  PromotionModel({
    this.result,
    this.data,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) => PromotionModel(
    result: json["result"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int promotionId;
  String detail;
  DateTime dateStart;
  DateTime dateEnd;
  int discountPercent;
  String promoImg;

  Datum({
    this.promotionId,
    this.detail,
    this.dateStart,
    this.dateEnd,
    this.discountPercent,
    this.promoImg,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    promotionId: json["promotion_id"],
    detail: json["detail"],
    dateStart: DateTime.parse(json["date_start"]),
    dateEnd: DateTime.parse(json["date_end"]),
    discountPercent: json["discount_percent"],
    promoImg: json["promo_img"],
  );

  Map<String, dynamic> toJson() => {
    "promotion_id": promotionId,
    "detail": detail,
    "date_start": "${dateStart.year.toString().padLeft(4, '0')}-${dateStart.month.toString().padLeft(2, '0')}-${dateStart.day.toString().padLeft(2, '0')}",
    "date_end": "${dateEnd.year.toString().padLeft(4, '0')}-${dateEnd.month.toString().padLeft(2, '0')}-${dateEnd.day.toString().padLeft(2, '0')}",
    "discount_percent": discountPercent,
    "promo_img": promoImg,
  };
}
