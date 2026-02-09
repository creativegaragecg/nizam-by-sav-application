// To parse this JSON data, do
//
//     final agentsModel = agentsModelFromJson(jsonString);

import 'dart:convert';

AgentsModel agentsModelFromJson(String str) => AgentsModel.fromJson(json.decode(str));

String agentsModelToJson(AgentsModel data) => json.encode(data.toJson());

class AgentsModel {
  bool? success;
  String? message;
  Data? data;

  AgentsModel({
    this.success,
    this.message,
    this.data,
  });

  factory AgentsModel.fromJson(Map<String, dynamic> json) => AgentsModel(
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
  List<Agent>? agents;

  Data({
    this.agents,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    agents: json["agents"] == null ? [] : List<Agent>.from(json["agents"]!.map((x) => Agent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "agents": agents == null ? [] : List<dynamic>.from(agents!.map((x) => x.toJson())),
  };
}

class Agent {
  int? id;
  String? name;
  String? email;
  int? ticketTypeId;

  Agent({
    this.id,
    this.name,
    this.email,
    this.ticketTypeId,
  });

  factory Agent.fromJson(Map<String, dynamic> json) => Agent(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    ticketTypeId: json["ticket_type_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "ticket_type_id": ticketTypeId,
  };
}
