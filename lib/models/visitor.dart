// To parse this JSON data, do
//
//     final visitorModel = visitorModelFromJson(jsonString);

import 'dart:convert';

VisitorModel visitorModelFromJson(String str) => VisitorModel.fromJson(json.decode(str));

String visitorModelToJson(VisitorModel data) => json.encode(data.toJson());

class VisitorModel {
  bool? success;
  String? message;
  Data? data;

  VisitorModel({
    this.success,
    this.message,
    this.data,
  });

  factory VisitorModel.fromJson(Map<String, dynamic> json) => VisitorModel(
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
  List<Visitor>? visitors;
  Statistics? statistics;
  List<List<String>>? qrData;

  Data({
    this.visitors,
    this.statistics,
    this.qrData,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    visitors: json["visitors"] == null ? [] : List<Visitor>.from(json["visitors"]!.map((x) => Visitor.fromJson(x))),
    statistics: json["statistics"] == null ? null : Statistics.fromJson(json["statistics"]),
    qrData: json["qr_data"] == null ? [] : List<List<String>>.from(json["qr_data"]!.map((x) => List<String>.from(x.map((x) => x)))),
  );

  Map<String, dynamic> toJson() => {
    "visitors": visitors == null ? [] : List<dynamic>.from(visitors!.map((x) => x.toJson())),
    "statistics": statistics?.toJson(),
    "qr_data": qrData == null ? [] : List<dynamic>.from(qrData!.map((x) => List<dynamic>.from(x.map((x) => x)))),
  };
}

class Statistics {
  int? total;
  int? pending;
  int? allowed;
  int? notAllowed;

  Statistics({
    this.total,
    this.pending,
    this.allowed,
    this.notAllowed,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) => Statistics(
    total: json["total"],
    pending: json["pending"],
    allowed: json["allowed"],
    notAllowed: json["not_allowed"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "pending": pending,
    "allowed": allowed,
    "not_allowed": notAllowed,
  };
}

class Visitor {
  int? id;
  String? refNo;
  int? societyId;
  String? visitorName;
  dynamic visitorPhoto;
  String? phoneNumber;
  dynamic cnic;
  String? address;
  int? apartmentId;
  DateTime? dateOfVisit;
  dynamic dateOfExit;
  String? inTime;
  dynamic outTime;
  int? tenantId;
  int? addedBy;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic purposeOfVisit;
  int? visitorTypeId;
  dynamic countryPhonecode;
  dynamic visitorPhotoUrl;
  Apartment? apartment;
  VisitorType? visitorType;
  User? user;

  Visitor({
    this.id,
    this.refNo,
    this.societyId,
    this.visitorName,
    this.visitorPhoto,
    this.phoneNumber,
    this.cnic,
    this.address,
    this.apartmentId,
    this.dateOfVisit,
    this.dateOfExit,
    this.inTime,
    this.outTime,
    this.tenantId,
    this.addedBy,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.purposeOfVisit,
    this.visitorTypeId,
    this.countryPhonecode,
    this.visitorPhotoUrl,
    this.apartment,
    this.visitorType,
    this.user,
  });

  factory Visitor.fromJson(Map<String, dynamic> json) => Visitor(
    id: json["id"],
    refNo: json["ref_no"],
    societyId: json["society_id"],
    visitorName: json["visitor_name"],
    visitorPhoto: json["visitor_photo"],
    phoneNumber: json["phone_number"],
    cnic: json["cnic"],
    address: json["address"],
    apartmentId: json["apartment_id"],
    dateOfVisit: json["date_of_visit"] == null ? null : DateTime.parse(json["date_of_visit"]),
    dateOfExit: json["date_of_exit"],
    inTime: json["in_time"],
    outTime: json["out_time"],
    tenantId: json["tenant_id"],
    addedBy: json["added_by"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    purposeOfVisit: json["purpose_of_visit"],
    visitorTypeId: json["visitor_type_id"],
    countryPhonecode: json["country_phonecode"],
    visitorPhotoUrl: json["visitor_photo_url"],
    apartment: json["apartment"] == null ? null : Apartment.fromJson(json["apartment"]),
    visitorType: json["visitor_type"] == null ? null : VisitorType.fromJson(json["visitor_type"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ref_no": refNo,
    "society_id": societyId,
    "visitor_name": visitorName,
    "visitor_photo": visitorPhoto,
    "phone_number": phoneNumber,
    "cnic": cnic,
    "address": address,
    "apartment_id": apartmentId,
    "date_of_visit": dateOfVisit?.toIso8601String(),
    "date_of_exit": dateOfExit,
    "in_time": inTime,
    "out_time": outTime,
    "tenant_id": tenantId,
    "added_by": addedBy,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "purpose_of_visit": purposeOfVisit,
    "visitor_type_id": visitorTypeId,
    "country_phonecode": countryPhonecode,
    "visitor_photo_url": visitorPhotoUrl,
    "apartment": apartment?.toJson(),
    "visitor_type": visitorType?.toJson(),
    "user": user?.toJson(),
  };
}

class Apartment {
  int? id;
  String? refNo;
  int? societyId;
  String? apartmentNumber;
  int? apartmentArea;
  String? apartmentAreaUnit;
  int? isFurnished;
  dynamic location;
  dynamic subLocation;
  dynamic view;
  dynamic images;
  dynamic description;
  int? floorId;
  int? towerId;
  int? apartmentId;
  int? userId;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic parkingCodeId;
  int? isSold;
  User? user;
  Floors? floors;
  Towers? towers;

  Apartment({
    this.id,
    this.refNo,
    this.societyId,
    this.apartmentNumber,
    this.apartmentArea,
    this.apartmentAreaUnit,
    this.isFurnished,
    this.location,
    this.subLocation,
    this.view,
    this.images,
    this.description,
    this.floorId,
    this.towerId,
    this.apartmentId,
    this.userId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.parkingCodeId,
    this.isSold,
    this.user,
    this.floors,
    this.towers,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) => Apartment(
    id: json["id"],
    refNo: json["ref_no"],
    societyId: json["society_id"],
    apartmentNumber: json["apartment_number"],
    apartmentArea: json["apartment_area"],
    apartmentAreaUnit: json["apartment_area_unit"],
    isFurnished: json["is_furnished"],
    location: json["location"],
    subLocation: json["sub_location"],
    view: json["view"],
    images: json["images"],
    description: json["description"],
    floorId: json["floor_id"],
    towerId: json["tower_id"],
    apartmentId: json["apartment_id"],
    userId: json["user_id"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    parkingCodeId: json["parking_code_id"],
    isSold: json["is_sold"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    floors: json["floors"] == null ? null : Floors.fromJson(json["floors"]),
    towers: json["towers"] == null ? null : Towers.fromJson(json["towers"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ref_no": refNo,
    "society_id": societyId,
    "apartment_number": apartmentNumber,
    "apartment_area": apartmentArea,
    "apartment_area_unit": apartmentAreaUnit,
    "is_furnished": isFurnished,
    "location": location,
    "sub_location": subLocation,
    "view": view,
    "images": images,
    "description": description,
    "floor_id": floorId,
    "tower_id": towerId,
    "apartment_id": apartmentId,
    "user_id": userId,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "parking_code_id": parkingCodeId,
    "is_sold": isSold,
    "user": user?.toJson(),
    "floors": floors?.toJson(),
    "towers": towers?.toJson(),
  };
}

class Floors {
  int? id;
  String? floorName;
  String? image;
  int? towerId;
  int? isParking;
  int? societyId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Floors({
    this.id,
    this.floorName,
    this.image,
    this.towerId,
    this.isParking,
    this.societyId,
    this.createdAt,
    this.updatedAt,
  });

  factory Floors.fromJson(Map<String, dynamic> json) => Floors(
    id: json["id"],
    floorName: json["floor_name"],
    image: json["image"],
    towerId: json["tower_id"],
    isParking: json["is_parking"],
    societyId: json["society_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "floor_name": floorName,
    "image": image,
    "tower_id": towerId,
    "is_parking": isParking,
    "society_id": societyId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Towers {
  int? id;
  int? societyId;
  String? towerName;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;

  Towers({
    this.id,
    this.societyId,
    this.towerName,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory Towers.fromJson(Map<String, dynamic> json) => Towers(
    id: json["id"],
    societyId: json["society_id"],
    towerName: json["tower_name"],
    image: json["image"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "society_id": societyId,
    "tower_name": towerName,
    "image": image,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class User {
  int? id;
  String? name;
  int? societyId;
  String? email;
  String? phoneNumber;
  int? roleId;
  int? owner;
  int? tenant;
  String? status;
  dynamic emailVerifiedAt;
  dynamic twoFactorConfirmedAt;
  int? emailNotifications;
  int? pushNotifications;
  int? smsNotifications;
  int? weeklyDigest;
  dynamic currentTeamId;
  String? profilePhotoPath;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? locale;
  dynamic stripeId;
  dynamic pmType;
  dynamic pmLastFour;
  dynamic trialEndsAt;
  int? countryPhonecode;
  String? profilePhotoUrl;

  User({
    this.id,
    this.name,
    this.societyId,
    this.email,
    this.phoneNumber,
    this.roleId,
    this.owner,
    this.tenant,
    this.status,
    this.emailVerifiedAt,
    this.twoFactorConfirmedAt,
    this.emailNotifications,
    this.pushNotifications,
    this.smsNotifications,
    this.weeklyDigest,
    this.currentTeamId,
    this.profilePhotoPath,
    this.createdAt,
    this.updatedAt,
    this.locale,
    this.stripeId,
    this.pmType,
    this.pmLastFour,
    this.trialEndsAt,
    this.countryPhonecode,
    this.profilePhotoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    societyId: json["society_id"],
    email: json["email"],
    phoneNumber: json["phone_number"],
    roleId: json["role_id"],
    owner: json["owner"],
    tenant: json["tenant"],
    status: json["status"],
    emailVerifiedAt: json["email_verified_at"],
    twoFactorConfirmedAt: json["two_factor_confirmed_at"],
    emailNotifications: json["email_notifications"],
    pushNotifications: json["push_notifications"],
    smsNotifications: json["sms_notifications"],
    weeklyDigest: json["weekly_digest"],
    currentTeamId: json["current_team_id"],
    profilePhotoPath: json["profile_photo_path"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    locale: json["locale"],
    stripeId: json["stripe_id"],
    pmType: json["pm_type"],
    pmLastFour: json["pm_last_four"],
    trialEndsAt: json["trial_ends_at"],
    countryPhonecode: json["country_phonecode"],
    profilePhotoUrl: json["profile_photo_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "society_id": societyId,
    "email": email,
    "phone_number": phoneNumber,
    "role_id": roleId,
    "owner": owner,
    "tenant": tenant,
    "status": status,
    "email_verified_at": emailVerifiedAt,
    "two_factor_confirmed_at": twoFactorConfirmedAt,
    "email_notifications": emailNotifications,
    "push_notifications": pushNotifications,
    "sms_notifications": smsNotifications,
    "weekly_digest": weeklyDigest,
    "current_team_id": currentTeamId,
    "profile_photo_path": profilePhotoPath,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "locale": locale,
    "stripe_id": stripeId,
    "pm_type": pmType,
    "pm_last_four": pmLastFour,
    "trial_ends_at": trialEndsAt,
    "country_phonecode": countryPhonecode,
    "profile_photo_url": profilePhotoUrl,
  };
}

class VisitorType {
  int? id;
  int? societyId;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  VisitorType({
    this.id,
    this.societyId,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory VisitorType.fromJson(Map<String, dynamic> json) => VisitorType(
    id: json["id"],
    societyId: json["society_id"],
    name: json["name"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "society_id": societyId,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
