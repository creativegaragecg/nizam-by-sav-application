// To parse this JSON data, do
//
//     final violationRecordsModel = violationRecordsModelFromJson(jsonString);

import 'dart:convert';

ViolationRecordsModel violationRecordsModelFromJson(String str) => ViolationRecordsModel.fromJson(json.decode(str));

String violationRecordsModelToJson(ViolationRecordsModel data) => json.encode(data.toJson());

class ViolationRecordsModel {
  bool? success;
  String? message;
  Data? data;

  ViolationRecordsModel({
    this.success,
    this.message,
    this.data,
  });

  factory ViolationRecordsModel.fromJson(Map<String, dynamic> json) => ViolationRecordsModel(
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
  List<Violation>? violations;
  Statistics? statistics;

  Data({
    this.violations,
    this.statistics,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    violations: json["violations"] == null ? [] : List<Violation>.from(json["violations"]!.map((x) => Violation.fromJson(x))),
    statistics: json["statistics"] == null ? null : Statistics.fromJson(json["statistics"]),
  );

  Map<String, dynamic> toJson() => {
    "violations": violations == null ? [] : List<dynamic>.from(violations!.map((x) => x.toJson())),
    "statistics": statistics?.toJson(),
  };
}

class Statistics {
  int? total;
  int? pending;
  int? resolved;
  int? critical;

  Statistics({
    this.total,
    this.pending,
    this.resolved,
    this.critical,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) => Statistics(
    total: json["total"],
    pending: json["pending"],
    resolved: json["resolved"],
    critical: json["critical"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "pending": pending,
    "resolved": resolved,
    "critical": critical,
  };
}

class Violation {
  int? id;
  String? refNo;
  DateTime? dateReported;
  String? violationType;
  String? description;
  String? violationSeverity;
  String? resolvedStatus;
  dynamic resolvedAt;
  dynamic remarks;
  Apartment? apartment;
  ReportedBy? tenant;
  ReportedBy? reportedBy;
  List<dynamic>? evidenceImages;

  Violation({
    this.id,
    this.refNo,
    this.dateReported,
    this.violationType,
    this.description,
    this.violationSeverity,
    this.resolvedStatus,
    this.resolvedAt,
    this.remarks,
    this.apartment,
    this.tenant,
    this.reportedBy,
    this.evidenceImages,
  });

  factory Violation.fromJson(Map<String, dynamic> json) => Violation(
    id: json["id"],
    refNo: json["ref_no"],
    dateReported: json["date_reported"] == null ? null : DateTime.parse(json["date_reported"]),
    violationType: json["violation_type"],
    description: json["description"],
    violationSeverity: json["violation_severity"],
    resolvedStatus: json["resolved_status"],
    resolvedAt: json["resolved_at"],
    remarks: json["remarks"],
    apartment: json["apartment"] == null ? null : Apartment.fromJson(json["apartment"]),
    tenant: json["tenant"] == null ? null : ReportedBy.fromJson(json["tenant"]),
    reportedBy: json["reported_by"] == null ? null : ReportedBy.fromJson(json["reported_by"]),
    evidenceImages: json["evidence_images"] == null ? [] : List<dynamic>.from(json["evidence_images"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ref_no": refNo,
    "date_reported": "${dateReported!.year.toString().padLeft(4, '0')}-${dateReported!.month.toString().padLeft(2, '0')}-${dateReported!.day.toString().padLeft(2, '0')}",
    "violation_type": violationType,
    "description": description,
    "violation_severity": violationSeverity,
    "resolved_status": resolvedStatus,
    "resolved_at": resolvedAt,
    "remarks": remarks,
    "apartment": apartment?.toJson(),
    "tenant": tenant?.toJson(),
    "reported_by": reportedBy?.toJson(),
    "evidence_images": evidenceImages == null ? [] : List<dynamic>.from(evidenceImages!.map((x) => x)),
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
