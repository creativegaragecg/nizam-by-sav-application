// To parse this JSON data, do
//
//     final legalNoticeDetailModel = legalNoticeDetailModelFromJson(jsonString);

import 'dart:convert';

LegalNoticeDetailModel legalNoticeDetailModelFromJson(String str) => LegalNoticeDetailModel.fromJson(json.decode(str));

String legalNoticeDetailModelToJson(LegalNoticeDetailModel data) => json.encode(data.toJson());

class LegalNoticeDetailModel {
  LegalNotice? legalNotice;
  List<Comment>? comments;

  LegalNoticeDetailModel({
    this.legalNotice,
    this.comments,
  });

  factory LegalNoticeDetailModel.fromJson(Map<String, dynamic> json) => LegalNoticeDetailModel(
    legalNotice: json["legalNotice"] == null ? null : LegalNotice.fromJson(json["legalNotice"]),
    comments: json["comments"] == null ? [] : List<Comment>.from(json["comments"]!.map((x) => Comment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "legalNotice": legalNotice?.toJson(),
    "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x.toJson())),
  };
}

class Comment {
  int? id;
  String? message;
  List<DocumentUrl>? attachments;
  DateTime? createdAt;
  IssuedBy? user;
  List<dynamic>? replies;

  Comment({
    this.id,
    this.message,
    this.attachments,
    this.createdAt,
    this.user,
    this.replies,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    message: json["message"],
    attachments: json["attachments"] == null ? [] : List<DocumentUrl>.from(json["attachments"]!.map((x) => DocumentUrl.fromJson(x))),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    user: json["user"] == null ? null : IssuedBy.fromJson(json["user"]),
    replies: json["replies"] == null ? [] : List<dynamic>.from(json["replies"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "message": message,
    "attachments": attachments == null ? [] : List<dynamic>.from(attachments!.map((x) => x.toJson())),
    "created_at": createdAt?.toIso8601String(),
    "user": user?.toJson(),
    "replies": replies == null ? [] : List<dynamic>.from(replies!.map((x) => x)),
  };
}

class DocumentUrl {
  String? fileName;
  String? fileUrl;

  DocumentUrl({
    this.fileName,
    this.fileUrl,
  });

  factory DocumentUrl.fromJson(Map<String, dynamic> json) => DocumentUrl(
    fileName: json["file_name"],
    fileUrl: json["file_url"],
  );

  Map<String, dynamic> toJson() => {
    "file_name": fileName,
    "file_url": fileUrl,
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

class LegalNotice {
  int? id;
  String? refNo;
  String? lawyerName;
  String? title;
  String? notes;
  String? status;
  DateTime? issuedDate;
  String? followUpRequired;
  DateTime? followUpDate;
  String? responseReceived;
  DateTime? responseDate;
  IssuedBy? tenant;
  IssuedBy? issuedBy;
  DocumentUrl? documentUrl;
  DateTime? createdAt;
  DateTime? updatedAt;

  LegalNotice({
    this.id,
    this.refNo,
    this.lawyerName,
    this.title,
    this.notes,
    this.status,
    this.issuedDate,
    this.followUpRequired,
    this.followUpDate,
    this.responseReceived,
    this.responseDate,
    this.tenant,
    this.issuedBy,
    this.documentUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory LegalNotice.fromJson(Map<String, dynamic> json) => LegalNotice(
    id: json["id"],
    refNo: json["ref_no"],
    lawyerName: json["lawyer_name"],
    title: json["title"],
    notes: json["notes"],
    status: json["status"],
    issuedDate: json["issued_date"] == null ? null : DateTime.parse(json["issued_date"]),
    followUpRequired: json["follow_up_required"],
    followUpDate: json["follow_up_date"] == null ? null : DateTime.parse(json["follow_up_date"]),
    responseReceived: json["response_received"],
    responseDate: json["response_date"] == null ? null : DateTime.parse(json["response_date"]),
    tenant: json["tenant"] == null ? null : IssuedBy.fromJson(json["tenant"]),
    issuedBy: json["issued_by"] == null ? null : IssuedBy.fromJson(json["issued_by"]),
    documentUrl: json["document_url"] == null ? null : DocumentUrl.fromJson(json["document_url"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ref_no": refNo,
    "lawyer_name": lawyerName,
    "title": title,
    "notes": notes,
    "status": status,
    "issued_date": issuedDate?.toIso8601String(),
    "follow_up_required": followUpRequired,
    "follow_up_date": followUpDate?.toIso8601String(),
    "response_received": responseReceived,
    "response_date": responseDate?.toIso8601String(),
    "tenant": tenant?.toJson(),
    "issued_by": issuedBy?.toJson(),
    "document_url": documentUrl?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
