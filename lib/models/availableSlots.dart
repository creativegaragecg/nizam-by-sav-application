// To parse this JSON data, do
//
//     final availableSlots = availableSlotsFromJson(jsonString);

import 'dart:convert';

AvailableSlots availableSlotsFromJson(String str) => AvailableSlots.fromJson(json.decode(str));

String availableSlotsToJson(AvailableSlots data) => json.encode(data.toJson());

class AvailableSlots {
  bool? success;
  String? message;
  List<Datum>? data;

  AvailableSlots({
    this.success,
    this.message,
    this.data,
  });

  factory AvailableSlots.fromJson(Map<String, dynamic> json) => AvailableSlots(
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
  String? time;
  bool? isDisabled;
  dynamic? remaining;
  String? formattedTime;

  Datum({
    this.time,
    this.isDisabled,
    this.remaining,
    this.formattedTime,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    time: json["time"],
    isDisabled: json["is_disabled"],
    remaining: json["remaining"],
    formattedTime: json["formatted_time"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "is_disabled": isDisabled,
    "remaining": remaining,
    "formatted_time": formattedTime,
  };
}
