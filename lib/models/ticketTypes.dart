// To parse this JSON data, do
//
//     final ticketTypesModel = ticketTypesModelFromJson(jsonString);

import 'dart:convert';

TicketTypesModel ticketTypesModelFromJson(String str) => TicketTypesModel.fromJson(json.decode(str));

String ticketTypesModelToJson(TicketTypesModel data) => json.encode(data.toJson());

class TicketTypesModel {
  bool? success;
  String? message;
  Data? data;

  TicketTypesModel({
    this.success,
    this.message,
    this.data,
  });

  factory TicketTypesModel.fromJson(Map<String, dynamic> json) => TicketTypesModel(
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
  List<TicketType>? ticketTypes;

  Data({
    this.ticketTypes,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    ticketTypes: json["ticket_types"] == null ? [] : List<TicketType>.from(json["ticket_types"]!.map((x) => TicketType.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ticket_types": ticketTypes == null ? [] : List<dynamic>.from(ticketTypes!.map((x) => x.toJson())),
  };
}

class TicketType {
  int? id;
  String? typeName;

  TicketType({
    this.id,
    this.typeName,
  });

  factory TicketType.fromJson(Map<String, dynamic> json) => TicketType(
    id: json["id"],
    typeName: json["type_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type_name": typeName,
  };
}
