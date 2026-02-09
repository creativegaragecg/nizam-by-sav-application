// To parse this JSON data, do
//
//     final visitorAppartmentModel = visitorAppartmentModelFromJson(jsonString);

import 'dart:convert';

VisitorAppartmentModel visitorAppartmentModelFromJson(String str) => VisitorAppartmentModel.fromJson(json.decode(str));

String visitorAppartmentModelToJson(VisitorAppartmentModel data) => json.encode(data.toJson());

class VisitorAppartmentModel {
  bool? success;
  String? message;
  Data? data;

  VisitorAppartmentModel({
    this.success,
    this.message,
    this.data,
  });

  factory VisitorAppartmentModel.fromJson(Map<String, dynamic> json) => VisitorAppartmentModel(
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
  List<Apartment>? apartments;

  Data({
    this.apartments,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    apartments: json["apartments"] == null ? [] : List<Apartment>.from(json["apartments"]!.map((x) => Apartment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "apartments": apartments == null ? [] : List<dynamic>.from(apartments!.map((x) => x.toJson())),
  };
}

class Apartment {
  int? id;
  String? apartmentNumber;

  Apartment({
    this.id,
    this.apartmentNumber,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) => Apartment(
    id: json["id"],
    apartmentNumber: json["apartment_number"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "apartment_number": apartmentNumber,
  };
}
