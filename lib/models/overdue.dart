// To parse this JSON data, do
//
//     final overDueAmountModel = overDueAmountModelFromJson(jsonString);

import 'dart:convert';

OverDueAmountModel overDueAmountModelFromJson(String str) => OverDueAmountModel.fromJson(json.decode(str));

String overDueAmountModelToJson(OverDueAmountModel data) => json.encode(data.toJson());

class OverDueAmountModel {
  bool? success;
  String? message;
  Data? data;

  OverDueAmountModel({
    this.success,
    this.message,
    this.data,
  });

  factory OverDueAmountModel.fromJson(Map<String, dynamic> json) => OverDueAmountModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  dynamic? dueAmount;

  Data({
    this.dueAmount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    dueAmount: json["due_amount"],
  );

  Map<String, dynamic> toJson() => {
    "due_amount": dueAmount,
  };
}
