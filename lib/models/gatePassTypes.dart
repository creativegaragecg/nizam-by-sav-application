// To parse this JSON data, do
//
//     final gatePassTypesModel = gatePassTypesModelFromJson(jsonString);

import 'dart:convert';

GatePassTypesModel gatePassTypesModelFromJson(String str) => GatePassTypesModel.fromJson(json.decode(str));

String gatePassTypesModelToJson(GatePassTypesModel data) => json.encode(data.toJson());

class GatePassTypesModel {
  bool? success;
  String? message;
  Data? data;

  GatePassTypesModel({
    this.success,
    this.message,
    this.data,
  });

  factory GatePassTypesModel.fromJson(Map<String, dynamic> json) => GatePassTypesModel(
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
  List<PassType>? passTypes;

  Data({
    this.passTypes,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    passTypes: json["pass_types"] == null ? [] : List<PassType>.from(json["pass_types"]!.map((x) => PassType.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pass_types": passTypes == null ? [] : List<dynamic>.from(passTypes!.map((x) => x.toJson())),
  };
}

class PassType {
  String? id;
  String? name;
  String? description;

  PassType({
    this.id,
    this.name,
    this.description,
  });

  factory PassType.fromJson(Map<String, dynamic> json) => PassType(
    id: json["id"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
  };
}
