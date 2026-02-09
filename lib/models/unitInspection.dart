// To parse this JSON data, do
//
//     final unitInspectionModel = unitInspectionModelFromJson(jsonString);

import 'dart:convert';

UnitInspectionModel unitInspectionModelFromJson(String str) => UnitInspectionModel.fromJson(json.decode(str));

String unitInspectionModelToJson(UnitInspectionModel data) => json.encode(data.toJson());

class UnitInspectionModel {
  bool? success;
  String? message;
  Data? data;

  UnitInspectionModel({
    this.success,
    this.message,
    this.data,
  });

  factory UnitInspectionModel.fromJson(Map<String, dynamic> json) => UnitInspectionModel(
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
  List<Inspection>? inspections;
  Statistics? statistics;

  Data({
    this.inspections,
    this.statistics,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    inspections: json["inspections"] == null ? [] : List<Inspection>.from(json["inspections"]!.map((x) => Inspection.fromJson(x))),
    statistics: json["statistics"] == null ? null : Statistics.fromJson(json["statistics"]),
  );

  Map<String, dynamic> toJson() => {
    "inspections": inspections == null ? [] : List<dynamic>.from(inspections!.map((x) => x.toJson())),
    "statistics": statistics?.toJson(),
  };
}

class Inspection {
  int? id;
  String? refNo;
  DateTime? inspectionDate;
  InspectionType? inspectionType;
  int? cleanlinessRating;
  int? damageFound;
  String? damageDescription;
  String? damageSeverity;
  String? actionRequired;
  DateTime? followUpDate;
  String? inspectionDuration;
  String? notes;
  Apartment? apartment;
  InspectedBy? tenant;
  InspectedBy? inspectedBy;
  List<EvidenceImage>? inspectionEvidenceImages;
  List<EvidenceImage>? damageEvidenceImages;

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
  });

  factory Inspection.fromJson(Map<String, dynamic> json) => Inspection(
    id: json["id"],
    refNo: json["ref_no"],
    inspectionDate: json["inspection_date"] == null ? null : DateTime.parse(json["inspection_date"]),
    inspectionType: inspectionTypeValues.map[json["inspection_type"]]!,
    cleanlinessRating: json["cleanliness_rating"],
    damageFound: json["damage_found"],
    damageDescription: json["damage_description"],
    damageSeverity: json["damage_severity"],
    actionRequired: json["action_required"],
    followUpDate: json["follow_up_date"] == null ? null : DateTime.parse(json["follow_up_date"]),
    inspectionDuration: json["inspection_duration"],
    notes: json["notes"],
    apartment: json["apartment"] == null ? null : Apartment.fromJson(json["apartment"]),
    tenant: json["tenant"] == null ? null : InspectedBy.fromJson(json["tenant"]),
    inspectedBy: json["inspected_by"] == null ? null : InspectedBy.fromJson(json["inspected_by"]),
    inspectionEvidenceImages: json["inspection_evidence_images"] == null ? [] : List<EvidenceImage>.from(json["inspection_evidence_images"]!.map((x) => EvidenceImage.fromJson(x))),
    damageEvidenceImages: json["damage_evidence_images"] == null ? [] : List<EvidenceImage>.from(json["damage_evidence_images"]!.map((x) => EvidenceImage.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ref_no": refNo,
    "inspection_date": inspectionDate?.toIso8601String(),
    "inspection_type": inspectionTypeValues.reverse[inspectionType],
    "cleanliness_rating": cleanlinessRating,
    "damage_found": damageFound,
    "damage_description": damageDescription,
    "damage_severity": damageSeverity,
    "action_required": actionRequired,
    "follow_up_date": followUpDate?.toIso8601String(),
    "inspection_duration": inspectionDuration,
    "notes": notes,
    "apartment": apartment?.toJson(),
    "tenant": tenant?.toJson(),
    "inspected_by": inspectedBy?.toJson(),
    "inspection_evidence_images": inspectionEvidenceImages == null ? [] : List<dynamic>.from(inspectionEvidenceImages!.map((x) => x.toJson())),
    "damage_evidence_images": damageEvidenceImages == null ? [] : List<dynamic>.from(damageEvidenceImages!.map((x) => x.toJson())),
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

class EvidenceImage {
  String? fileName;
  String? fileUrl;

  EvidenceImage({
    this.fileName,
    this.fileUrl,
  });

  factory EvidenceImage.fromJson(Map<String, dynamic> json) => EvidenceImage(
    fileName: json["file_name"],
    fileUrl: json["file_url"],
  );

  Map<String, dynamic> toJson() => {
    "file_name": fileName,
    "file_url": fileUrl,
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

enum InspectionType {
  EMPTY,
  HANDOVER,
  TAKEOVER
}

final inspectionTypeValues = EnumValues({
  "": InspectionType.EMPTY,
  "Handover": InspectionType.HANDOVER,
  "Takeover": InspectionType.TAKEOVER
});

class Statistics {
  int? total;
  int? damageFound;
  int? actionRequired;

  Statistics({
    this.total,
    this.damageFound,
    this.actionRequired,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) => Statistics(
    total: json["total"],
    damageFound: json["damage_found"],
    actionRequired: json["action_required"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "damage_found": damageFound,
    "action_required": actionRequired,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
