// To parse this JSON data, do
//
//     final visitorTypesModel = visitorTypesModelFromJson(jsonString);

import 'dart:convert';

VisitorTypesModel visitorTypesModelFromJson(String str) => VisitorTypesModel.fromJson(json.decode(str));

String visitorTypesModelToJson(VisitorTypesModel data) => json.encode(data.toJson());

class VisitorTypesModel {
  bool? success;
  String? message;
  Data? data;

  VisitorTypesModel({
    this.success,
    this.message,
    this.data,
  });

  factory VisitorTypesModel.fromJson(Map<String, dynamic> json) => VisitorTypesModel(
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
  List<VisitorType>? visitorTypes;

  Data({
    this.visitorTypes,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    visitorTypes: json["visitor_types"] == null ? [] : List<VisitorType>.from(json["visitor_types"]!.map((x) => VisitorType.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "visitor_types": visitorTypes == null ? [] : List<dynamic>.from(visitorTypes!.map((x) => x.toJson())),
  };
}

class VisitorType {
  int? id;
  String? name;

  VisitorType({
    this.id,
    this.name,
  });

  factory VisitorType.fromJson(Map<String, dynamic> json) => VisitorType(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
