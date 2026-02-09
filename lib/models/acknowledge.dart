// To parse this JSON data, do
//
//     final acknowledgeModel = acknowledgeModelFromJson(jsonString);

import 'dart:convert';

AcknowledgeModel acknowledgeModelFromJson(String str) => AcknowledgeModel.fromJson(json.decode(str));

String acknowledgeModelToJson(AcknowledgeModel data) => json.encode(data.toJson());

class AcknowledgeModel {
  bool? success;
  String? message;
  List<Datum>? data;

  AcknowledgeModel({
    this.success,
    this.message,
    this.data,
  });

  factory AcknowledgeModel.fromJson(Map<String, dynamic> json) => AcknowledgeModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  int? societyId;
  int? userId;
  int? roleId;
  dynamic attendantId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.societyId,
    this.userId,
    this.roleId,
    this.attendantId,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    societyId: json["society_id"],
    userId: json["user_id"],
    roleId: json["role_id"],
    attendantId: json["attendant_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "society_id": societyId,
    "user_id": userId,
    "role_id": roleId,
    "attendant_id": attendantId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
