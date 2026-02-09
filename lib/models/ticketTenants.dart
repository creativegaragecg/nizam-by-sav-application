// To parse this JSON data, do
//
//     final ticketTenantModel = ticketTenantModelFromJson(jsonString);

import 'dart:convert';

TicketTenantModel ticketTenantModelFromJson(String str) => TicketTenantModel.fromJson(json.decode(str));

String ticketTenantModelToJson(TicketTenantModel data) => json.encode(data.toJson());

class TicketTenantModel {
  bool? success;
  String? message;
  Data? data;

  TicketTenantModel({
    this.success,
    this.message,
    this.data,
  });

  factory TicketTenantModel.fromJson(Map<String, dynamic> json) => TicketTenantModel(
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
  List<Tenant>? tenants;

  Data({
    this.tenants,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    tenants: json["tenants"] == null ? [] : List<Tenant>.from(json["tenants"]!.map((x) => Tenant.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "tenants": tenants == null ? [] : List<dynamic>.from(tenants!.map((x) => x.toJson())),
  };
}

class Tenant {
  int? id;
  String? refNo;
  int? societyId;
  int? userId;
  dynamic taxDefinationId;
  int? isApproved;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  User? user;

  Tenant({
    this.id,
    this.refNo,
    this.societyId,
    this.userId,
    this.taxDefinationId,
    this.isApproved,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.user,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) => Tenant(
    id: json["id"],
    refNo: json["ref_no"],
    societyId: json["society_id"],
    userId: json["user_id"],
    taxDefinationId: json["tax_defination_id"],
    isApproved: json["is_approved"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ref_no": refNo,
    "society_id": societyId,
    "user_id": userId,
    "tax_defination_id": taxDefinationId,
    "is_approved": isApproved,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "user": user?.toJson(),
  };
}

class User {
  int? id;
  String? name;
  String? email;
  String? profilePhotoUrl;

  User({
    this.id,
    this.name,
    this.email,
    this.profilePhotoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    profilePhotoUrl: json["profile_photo_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "profile_photo_url": profilePhotoUrl,
  };
}
