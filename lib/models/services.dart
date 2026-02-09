// To parse this JSON data, do
//
//     final servicesModel = servicesModelFromJson(jsonString);

import 'dart:convert';

ServicesModel servicesModelFromJson(String str) => ServicesModel.fromJson(json.decode(str));

String servicesModelToJson(ServicesModel data) => json.encode(data.toJson());

class ServicesModel {
  bool? success;
  String? message;
  List<Service>? data;

  ServicesModel({
    this.success,
    this.message,
    this.data,
  });

  factory ServicesModel.fromJson(Map<String, dynamic> json) => ServicesModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Service>.from(json["data"]!.map((x) => Service.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Service {
  int? id;
  int? serviceTypeId;
  String? serviceTypeName;
  String? companyName;
  String? contactPersonName;
  String? phoneNumber;
  String? websiteLink;
  int? price;
  String? description;
  String? status;
  String? paymentFrequency;
  bool? dailyHelp;
  String? servicePhoto;
  DateTime? createdAt;
  DateTime? updatedAt;

  Service({
    this.id,
    this.serviceTypeId,
    this.serviceTypeName,
    this.companyName,
    this.contactPersonName,
    this.phoneNumber,
    this.websiteLink,
    this.price,
    this.description,
    this.status,
    this.paymentFrequency,
    this.dailyHelp,
    this.servicePhoto,
    this.createdAt,
    this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["id"],
    serviceTypeId: json["service_type_id"],
    serviceTypeName: json["service_type_name"],
    companyName: json["company_name"],
    contactPersonName: json["contact_person_name"],
    phoneNumber: json["phone_number"],
    websiteLink: json["website_link"],
    price: json["price"],
    description: json["description"],
    status: json["status"],
    paymentFrequency: json["payment_frequency"],
    dailyHelp: json["daily_help"],
    servicePhoto: json["service_photo"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "service_type_id": serviceTypeId,
    "service_type_name": serviceTypeName,
    "company_name": companyName,
    "contact_person_name": contactPersonName,
    "phone_number": phoneNumber,
    "website_link": websiteLink,
    "price": price,
    "description": description,
    "status": status,
    "payment_frequency": paymentFrequency,
    "daily_help": dailyHelp,
    "service_photo": servicePhoto,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}





