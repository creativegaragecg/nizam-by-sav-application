// To parse this JSON data, do
//
//     final legalNoticeModel = legalNoticeModelFromJson(jsonString);

import 'dart:convert';

LegalNoticeModel legalNoticeModelFromJson(String str) => LegalNoticeModel.fromJson(json.decode(str));

String legalNoticeModelToJson(LegalNoticeModel data) => json.encode(data.toJson());

class LegalNoticeModel {
  bool? success;
  String? message;
  Data? data;

  LegalNoticeModel({
    this.success,
    this.message,
    this.data,
  });

  factory LegalNoticeModel.fromJson(Map<String, dynamic> json) => LegalNoticeModel(
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
  List<LegalNotice>? legalNotices;
  Statistics? statistics;

  Data({
    this.legalNotices,
    this.statistics,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    legalNotices: json["legal_notices"] == null ? [] : List<LegalNotice>.from(json["legal_notices"]!.map((x) => LegalNotice.fromJson(x))),
    statistics: json["statistics"] == null ? null : Statistics.fromJson(json["statistics"]),
  );

  Map<String, dynamic> toJson() => {
    "legal_notices": legalNotices == null ? [] : List<dynamic>.from(legalNotices!.map((x) => x.toJson())),
    "statistics": statistics?.toJson(),
  };
}

class LegalNotice {
  int? id;
  String? refNo;
  String? title;
  String? notes;
  String? status;
  DateTime? issuedDate;
  String? lawyerName;
  IssuedBy? tenant;
  IssuedBy? issuedBy;
  IssuedBy? resolvedBy;
  Type? type;
  List<dynamic>? attachments;

  LegalNotice({
    this.id,
    this.refNo,
    this.title,
    this.notes,
    this.status,
    this.issuedDate,
    this.lawyerName,
    this.tenant,
    this.issuedBy,
    this.resolvedBy,
    this.type,
    this.attachments,
  });

  factory LegalNotice.fromJson(Map<String, dynamic> json) => LegalNotice(
    id: json["id"],
    refNo: json["ref_no"],
    title: json["title"],
    notes: json["notes"],
    status: json["status"],
    issuedDate: json["issued_date"] == null ? null : DateTime.parse(json["issued_date"]),
    lawyerName: json["lawyer_name"],
    tenant: json["tenant"] == null ? null : IssuedBy.fromJson(json["tenant"]),
    issuedBy: json["issued_by"] == null ? null : IssuedBy.fromJson(json["issued_by"]),
    resolvedBy: json["resolved_by"] == null ? null : IssuedBy.fromJson(json["resolved_by"]),
    type: json["type"] == null ? null : Type.fromJson(json["type"]),
    attachments: json["attachments"] == null ? [] : List<dynamic>.from(json["attachments"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ref_no": refNo,
    "title": title,
    "notes": notes,
    "status": status,
    "issued_date": issuedDate?.toIso8601String(),
    "lawyer_name": lawyerName,
    "tenant": tenant?.toJson(),
    "issued_by": issuedBy?.toJson(),
    "resolved_by": resolvedBy?.toJson(),
    "type": type?.toJson(),
    "attachments": attachments == null ? [] : List<dynamic>.from(attachments!.map((x) => x)),
  };
}

class IssuedBy {
  int? id;
  String? name;
  String? profileImage;
  String? refNo;

  IssuedBy({
    this.id,
    this.name,
    this.profileImage,
    this.refNo,
  });

  factory IssuedBy.fromJson(Map<String, dynamic> json) => IssuedBy(
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

class Type {
  int? id;
  String? name;

  Type({
    this.id,
    this.name,
  });

  factory Type.fromJson(Map<String, dynamic> json) => Type(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class Statistics {
  int? total;
  int? open;
  int? pending;
  int? resolved;
  int? closed;

  Statistics({
    this.total,
    this.open,
    this.pending,
    this.resolved,
    this.closed,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) => Statistics(
    total: json["total"],
    open: json["open"],
    pending: json["pending"],
    resolved: json["resolved"],
    closed: json["closed"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "open": open,
    "pending": pending,
    "resolved": resolved,
    "closed": closed,
  };
}
