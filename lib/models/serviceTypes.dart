// To parse this JSON data, do
//
//     final serviceTypesModel = serviceTypesModelFromJson(jsonString);

import 'dart:convert';

ServiceTypesModel serviceTypesModelFromJson(String str) => ServiceTypesModel.fromJson(json.decode(str));

String serviceTypesModelToJson(ServiceTypesModel data) => json.encode(data.toJson());

class ServiceTypesModel {
  bool? success;
  String? message;
  List<Datum>? data;

  ServiceTypesModel({
    this.success,
    this.message,
    this.data,
  });

  factory ServiceTypesModel.fromJson(Map<String, dynamic> json) => ServiceTypesModel(
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
  String? name;
  String? icon;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.name,
    this.icon,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    icon: json["icon"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": icon,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
