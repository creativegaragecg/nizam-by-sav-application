// To parse this JSON data, do
//
//     final unitInspectionDetailModel = unitInspectionDetailModelFromJson(jsonString);

import 'dart:convert';

UnitInspectionDetailModel unitInspectionDetailModelFromJson(String str) => UnitInspectionDetailModel.fromJson(json.decode(str));

String unitInspectionDetailModelToJson(UnitInspectionDetailModel data) => json.encode(data.toJson());

class UnitInspectionDetailModel {
  bool? success;
  String? message;
  Data? data;

  UnitInspectionDetailModel({
    this.success,
    this.message,
    this.data,
  });

  factory UnitInspectionDetailModel.fromJson(Map<String, dynamic> json) => UnitInspectionDetailModel(
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
  Inspection? inspection;
  List<Comment>? comments;

  Data({
    this.inspection,
    this.comments,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    inspection: json["inspection"] == null ? null : Inspection.fromJson(json["inspection"]),
    comments: json["comments"] == null ? [] : List<Comment>.from(json["comments"]!.map((x) => Comment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "inspection": inspection?.toJson(),
    "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x.toJson())),
  };
}

class Comment {
  int? id;
  String? message;
  DateTime? createdAt;
  InspectedBy? user;
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
    user: json["user"] == null ? null : InspectedBy.fromJson(json["user"]),
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

class InspectedBy {
  int? id;
  String? name;
  String? profileImage;
  String? refNo;

  InspectedBy({
    this.id,
    this.name,
    this.profileImage,
    this.refNo,
  });

  factory InspectedBy.fromJson(Map<String, dynamic> json) => InspectedBy(
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

class Inspection {
  int? id;
  String? refNo;
  DateTime? inspectionDate;
  String? inspectionType;
  int? cleanlinessRating;
  int? damageFound;
  dynamic damageDescription;
  dynamic damageSeverity;
  String? actionRequired;
  dynamic followUpDate;
  dynamic inspectionDuration;
  dynamic notes;
  Apartment? apartment;
  InspectedBy? tenant;
  InspectedBy? inspectedBy;
  List<dynamic>? inspectionEvidenceImages;
  List<dynamic>? damageEvidenceImages;
  DateTime? createdAt;
  DateTime? updatedAt;

  Inspection({
    this.id,
    this.refNo,
    this.inspectionDate,
    this.inspectionType,
    this.cleanlinessRating,
    this.damageFound,
    this.damageDescription,
    this.damageSeverity,
    this.actionRequired,
    this.followUpDate,
    this.inspectionDuration,
    this.notes,
    this.apartment,
    this.tenant,
    this.inspectedBy,
    this.inspectionEvidenceImages,
    this.damageEvidenceImages,
    this.createdAt,
    this.updatedAt,
  });

  factory Inspection.fromJson(Map<String, dynamic> json) => Inspection(
    id: json["id"],
    refNo: json["ref_no"],
    inspectionDate: json["inspection_date"] == null ? null : DateTime.parse(json["inspection_date"]),
    inspectionType: json["inspection_type"],
    cleanlinessRating: json["cleanliness_rating"],
    damageFound: json["damage_found"],
    damageDescription: json["damage_description"],
    damageSeverity: json["damage_severity"],
    actionRequired: json["action_required"],
    followUpDate: json["follow_up_date"],
    inspectionDuration: json["inspection_duration"],
    notes: json["notes"],
    apartment: json["apartment"] == null ? null : Apartment.fromJson(json["apartment"]),
    tenant: json["tenant"] == null ? null : InspectedBy.fromJson(json["tenant"]),
    inspectedBy: json["inspected_by"] == null ? null : InspectedBy.fromJson(json["inspected_by"]),
    inspectionEvidenceImages: json["inspection_evidence_images"] == null ? [] : List<dynamic>.from(json["inspection_evidence_images"]!.map((x) => x)),
    damageEvidenceImages: json["damage_evidence_images"] == null ? [] : List<dynamic>.from(json["damage_evidence_images"]!.map((x) => x)),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ref_no": refNo,
    "inspection_date": inspectionDate?.toIso8601String(),
    "inspection_type": inspectionType,
    "cleanliness_rating": cleanlinessRating,
    "damage_found": damageFound,
    "damage_description": damageDescription,
    "damage_severity": damageSeverity,
    "action_required": actionRequired,
    "follow_up_date": followUpDate,
    "inspection_duration": inspectionDuration,
    "notes": notes,
    "apartment": apartment?.toJson(),
    "tenant": tenant?.toJson(),
    "inspected_by": inspectedBy?.toJson(),
    "inspection_evidence_images": inspectionEvidenceImages == null ? [] : List<dynamic>.from(inspectionEvidenceImages!.map((x) => x)),
    "damage_evidence_images": damageEvidenceImages == null ? [] : List<dynamic>.from(damageEvidenceImages!.map((x) => x)),
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
