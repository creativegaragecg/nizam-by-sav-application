// To parse this JSON data, do
//
//     final violationRecordDetailsModel = violationRecordDetailsModelFromJson(jsonString);

import 'dart:convert';

ViolationRecordDetailsModel violationRecordDetailsModelFromJson(String str) => ViolationRecordDetailsModel.fromJson(json.decode(str));

String violationRecordDetailsModelToJson(ViolationRecordDetailsModel data) => json.encode(data.toJson());

class ViolationRecordDetailsModel {
  bool? success;
  String? message;
  Data? data;

  ViolationRecordDetailsModel({
    this.success,
    this.message,
    this.data,
  });

  factory ViolationRecordDetailsModel.fromJson(Map<String, dynamic> json) => ViolationRecordDetailsModel(
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
  Violation? violation;
  List<Comment>? comments;

  Data({
    this.violation,
    this.comments,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    violation: json["violation"] == null ? null : Violation.fromJson(json["violation"]),
    comments: json["comments"] == null ? [] : List<Comment>.from(json["comments"]!.map((x) => Comment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "violation": violation?.toJson(),
    "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x.toJson())),
  };
}

class Comment {
  int? id;
  String? message;
  DateTime? createdAt;
  ReportedBy? user;
  List<Comment>? replies;

  Comment({
    this.id,
    this.message,
    this.createdAt,
    this.user,
    this.replies,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    message: json["message"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    user: json["user"] == null ? null : ReportedBy.fromJson(json["user"]),
    replies: json["replies"] == null ? [] : List<Comment>.from(json["replies"]!.map((x) => Comment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "message": message,
    "created_at": createdAt?.toIso8601String(),
    "user": user?.toJson(),
    "replies": replies == null ? [] : List<dynamic>.from(replies!.map((x) => x.toJson())),
  };
}

class ReportedBy {
  int? id;
  String? name;
  String? profileImage;
  String? refNo;

  ReportedBy({
    this.id,
    this.name,
    this.profileImage,
    this.refNo,
  });

  factory ReportedBy.fromJson(Map<String, dynamic> json) => ReportedBy(
    id: json["id"],
    name: json["name"],
    profileImage: json["profile_image"],
    refNo: json["ref_no"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "profile_image": profileImage,
    "ref_no": refNo,
  };
}

class Violation {
  int? id;
  String? refNo;
  DateTime? dateReported;
  String? violationType;
  String? violationSeverity;
  String? description;
  String? resolvedStatus;
  dynamic resolvedAt;
  dynamic remarks;
  Apartment? apartment;
  ReportedBy? tenant;
  ReportedBy? reportedBy;
  List<dynamic>? evidenceImages;
  DateTime? createdAt;
  DateTime? updatedAt;

  Violation({
    this.id,
    this.refNo,
    this.dateReported,
    this.violationType,
    this.violationSeverity,
    this.description,
    this.resolvedStatus,
    this.resolvedAt,
    this.remarks,
    this.apartment,
    this.tenant,
    this.reportedBy,
    this.evidenceImages,
    this.createdAt,
    this.updatedAt,
  });

  factory Violation.fromJson(Map<String, dynamic> json) => Violation(
    id: json["id"],
    refNo: json["ref_no"],
    dateReported: json["date_reported"] == null ? null : DateTime.parse(json["date_reported"]),
    violationType: json["violation_type"],
    violationSeverity: json["violation_severity"],
    description: json["description"],
    resolvedStatus: json["resolved_status"],
    resolvedAt: json["resolved_at"],
    remarks: json["remarks"],
    apartment: json["apartment"] == null ? null : Apartment.fromJson(json["apartment"]),
    tenant: json["tenant"] == null ? null : ReportedBy.fromJson(json["tenant"]),
    reportedBy: json["reported_by"] == null ? null : ReportedBy.fromJson(json["reported_by"]),
    evidenceImages: json["evidence_images"] == null ? [] : List<dynamic>.from(json["evidence_images"]!.map((x) => x)),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ref_no": refNo,
    "date_reported": "${dateReported!.year.toString().padLeft(4, '0')}-${dateReported!.month.toString().padLeft(2, '0')}-${dateReported!.day.toString().padLeft(2, '0')}",
    "violation_type": violationType,
    "violation_severity": violationSeverity,
    "description": description,
    "resolved_status": resolvedStatus,
    "resolved_at": resolvedAt,
    "remarks": remarks,
    "apartment": apartment?.toJson(),
    "tenant": tenant?.toJson(),
    "reported_by": reportedBy?.toJson(),
    "evidence_images": evidenceImages == null ? [] : List<dynamic>.from(evidenceImages!.map((x) => x)),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Apartment {
  int? id;
  String? apartmentNumber;
  String? floor;
  String? tower;

  Apartment({
    this.id,
    this.apartmentNumber,
    this.floor,
    this.tower,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) => Apartment(
    id: json["id"],
    apartmentNumber: json["apartment_number"],
    floor: json["floor"],
    tower: json["tower"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "apartment_number": apartmentNumber,
    "floor": floor,
    "tower": tower,
  };
}
