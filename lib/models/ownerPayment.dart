// To parse this JSON data, do
//
//     final ownerPaymentModel = ownerPaymentModelFromJson(jsonString);

import 'dart:convert';

OwnerPaymentModel ownerPaymentModelFromJson(String str) => OwnerPaymentModel.fromJson(json.decode(str));

String ownerPaymentModelToJson(OwnerPaymentModel data) => json.encode(data.toJson());

class OwnerPaymentModel {
  bool? success;
  String? message;
  Data? data;

  OwnerPaymentModel({
    this.success,
    this.message,
    this.data,
  });

  factory OwnerPaymentModel.fromJson(Map<String, dynamic> json) => OwnerPaymentModel(
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
  List<Payment>? payments;

  Data({
    this.payments,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    payments: json["payments"] == null ? [] : List<Payment>.from(json["payments"]!.map((x) => Payment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "payments": payments == null ? [] : List<dynamic>.from(payments!.map((x) => x.toJson())),
  };
}

class Payment {
  int? id;
  int? ownerId;
  int? dueAmount;
  String? status;
  DateTime? dueDate;
  int? paidAmount;
  String? type;

  Payment({
    this.id,
    this.ownerId,
    this.dueAmount,
    this.status,
    this.dueDate,
    this.paidAmount,
    this.type,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    id: json["id"],
    ownerId: json["owner_id"],
    dueAmount: json["due_amount"],
    status: json["status"],
    dueDate: json["due_date"] == null ? null : DateTime.parse(json["due_date"]),
    paidAmount: json["paid_amount"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "owner_id": ownerId,
    "due_amount": dueAmount,
    "status": status,
    "due_date": dueDate?.toIso8601String(),
    "paid_amount": paidAmount,
    "type": type,
  };
}
