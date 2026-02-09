// To parse this JSON data, do
//
//     final eventsModel = eventsModelFromJson(jsonString);

import 'dart:convert';

EventsModel eventsModelFromJson(String str) => EventsModel.fromJson(json.decode(str));

String eventsModelToJson(EventsModel data) => json.encode(data.toJson());

class EventsModel {
  bool? success;
  String? message;
  Data? data;

  EventsModel({
    this.success,
    this.message,
    this.data,
  });

  factory EventsModel.fromJson(Map<String, dynamic> json) => EventsModel(
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
  List<Event>? events;

  Data({
    this.events,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    events: json["events"] == null ? [] : List<Event>.from(json["events"]!.map((x) => Event.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "events": events == null ? [] : List<dynamic>.from(events!.map((x) => x.toJson())),
  };
}

class Event {
  int? id;
  int? societyId;
  String? eventName;
  String? where;
  String? description;
  DateTime? startDateTime;
  DateTime? endDateTime;
  String? status;
  String? assignTo;
  DateTime? createdAt;
  DateTime? updatedAt;

  Event({
    this.id,
    this.societyId,
    this.eventName,
    this.where,
    this.description,
    this.startDateTime,
    this.endDateTime,
    this.status,
    this.assignTo,
    this.createdAt,
    this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json["id"],
    societyId: json["society_id"],
    eventName: json["event_name"],
    where: json["where"],
    description: json["description"],
    startDateTime: json["start_date_time"] == null ? null : DateTime.parse(json["start_date_time"]),
    endDateTime: json["end_date_time"] == null ? null : DateTime.parse(json["end_date_time"]),
    status: json["status"],
    assignTo: json["assign_to"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "society_id": societyId,
    "event_name": eventName,
    "where": where,
    "description": description,
    "start_date_time": startDateTime?.toIso8601String(),
    "end_date_time": endDateTime?.toIso8601String(),
    "status": status,
    "assign_to": assignTo,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
