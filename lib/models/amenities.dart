// To parse this JSON data, do
//
//     final amenitiesModel = amenitiesModelFromJson(jsonString);

import 'dart:convert';

AmenitiesModel amenitiesModelFromJson(String str) => AmenitiesModel.fromJson(json.decode(str));

String amenitiesModelToJson(AmenitiesModel data) => json.encode(data.toJson());

class AmenitiesModel {
  bool? success;
  String? message;
  List<Datum>? data;

  AmenitiesModel({
    this.success,
    this.message,
    this.data,
  });

  factory AmenitiesModel.fromJson(Map<String, dynamic> json) => AmenitiesModel(
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
  String? amenitiesName;
  String? status;
  bool? bookingStatus;
  String? startTime;
  String? endTime;
  int? slotTime;
  bool? multipleBookingStatus;
  int? numberOfPerson;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.amenitiesName,
    this.status,
    this.bookingStatus,
    this.startTime,
    this.endTime,
    this.slotTime,
    this.multipleBookingStatus,
    this.numberOfPerson,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    amenitiesName: json["amenities_name"],
    status: json["status"],
    bookingStatus: json["booking_status"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    slotTime: json["slot_time"],
    multipleBookingStatus: json["multiple_booking_status"],
    numberOfPerson: json["number_of_person"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amenities_name": amenitiesName,
    "status": status,
    "booking_status": bookingStatus,
    "start_time": startTime,
    "end_time": endTime,
    "slot_time": slotTime,
    "multiple_booking_status": multipleBookingStatus,
    "number_of_person": numberOfPerson,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}




