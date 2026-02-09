// To parse this JSON data, do
//
//     final myBookings = myBookingsFromJson(jsonString);

import 'dart:convert';

MyBookings myBookingsFromJson(String str) => MyBookings.fromJson(json.decode(str));

String myBookingsToJson(MyBookings data) => json.encode(data.toJson());

class MyBookings {
  bool? success;
  String? message;
  List<Booking>? data;

  MyBookings({
    this.success,
    this.message,
    this.data,
  });

  factory MyBookings.fromJson(Map<String, dynamic> json) => MyBookings(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Booking>.from(json["data"]!.map((x) => Booking.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Booking {
  int? id;
  int? amenityId;
  String? amenityName;
  DateTime? bookingDate;
  String? bookingTime;
  DateTime? bookingDatetime;
  int? persons;
  String? bookingType;
  String? uniqueId;

  Booking({
    this.id,
    this.amenityId,
    this.amenityName,
    this.bookingDate,
    this.bookingTime,
    this.bookingDatetime,
    this.persons,
    this.bookingType,
    this.uniqueId,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json["id"],
    amenityId: json["amenity_id"],
    amenityName: json["amenity_name"],
    bookingDate: json["booking_date"] == null ? null : DateTime.parse(json["booking_date"]),
    bookingTime: json["booking_time"],
    bookingDatetime: json["booking_datetime"] == null ? null : DateTime.parse(json["booking_datetime"]),
    persons: json["persons"],
    bookingType: json["booking_type"],
    uniqueId: json["unique_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amenity_id": amenityId,
    "amenity_name": amenityName,
    "booking_date": "${bookingDate!.year.toString().padLeft(4, '0')}-${bookingDate!.month.toString().padLeft(2, '0')}-${bookingDate!.day.toString().padLeft(2, '0')}",
    "booking_time": bookingTime,
    "booking_datetime": bookingDatetime?.toIso8601String(),
    "persons": persons,
    "booking_type": bookingType,
    "unique_id": uniqueId,
  };
}
