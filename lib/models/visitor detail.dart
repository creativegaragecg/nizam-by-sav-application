// To parse this JSON data, do
//
//     final visitorDetailModel = visitorDetailModelFromJson(jsonString);

import 'dart:convert';

VisitorDetailModel visitorDetailModelFromJson(String str) => VisitorDetailModel.fromJson(json.decode(str));

String visitorDetailModelToJson(VisitorDetailModel data) => json.encode(data.toJson());

class VisitorDetailModel {
  bool? success;
  String? message;
  Data? data;

  VisitorDetailModel({
    this.success,
    this.message,
    this.data,
  });

  factory VisitorDetailModel.fromJson(Map<String, dynamic> json) => VisitorDetailModel(
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
  Visitor? visitor;
  QrCode? qrCode;
  ActivityLog? activityLog;

  Data({
    this.visitor,
    this.qrCode,
    this.activityLog,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    visitor: json["visitor"] == null ? null : Visitor.fromJson(json["visitor"]),
    qrCode: json["qr_code"] == null ? null : QrCode.fromJson(json["qr_code"]),
    activityLog: json["activity_log"] == null ? null : ActivityLog.fromJson(json["activity_log"]),
  );

  Map<String, dynamic> toJson() => {
    "visitor": visitor?.toJson(),
    "qr_code": qrCode?.toJson(),
    "activity_log": activityLog?.toJson(),
  };
}

class ActivityLog {
  Summary? summary;
  List<Log>? logs;

  ActivityLog({
    this.summary,
    this.logs,
  });

  factory ActivityLog.fromJson(Map<String, dynamic> json) => ActivityLog(
    summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
    logs: json["logs"] == null ? [] : List<Log>.from(json["logs"]!.map((x) => Log.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "summary": summary?.toJson(),
    "logs": logs == null ? [] : List<dynamic>.from(logs!.map((x) => x.toJson())),
  };
}

class Log {
  int? id;
  String? direction;
  DateTime? activityTime;
  String? scannedBy;
  String? societyId;
  String? remarks;
  ParsedData? parsedData;
  DateTime? createdAt;

  Log({
    this.id,
    this.direction,
    this.activityTime,
    this.scannedBy,
    this.societyId,
    this.remarks,
    this.parsedData,
    this.createdAt,
  });

  factory Log.fromJson(Map<String, dynamic> json) => Log(
    id: json["id"],
    direction: json["direction"],
    activityTime: json["activity_time"] == null ? null : DateTime.parse(json["activity_time"]),
    scannedBy: json["scanned_by"],
    societyId: json["society_id"],
    remarks: json["remarks"],
    parsedData: json["parsed_data"] == null ? null : ParsedData.fromJson(json["parsed_data"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "direction": direction,
    "activity_time": activityTime?.toIso8601String(),
    "scanned_by": scannedBy,
    "society_id": societyId,
    "remarks": remarks,
    "parsed_data": parsedData?.toJson(),
    "created_at": createdAt?.toIso8601String(),
  };
}

class ParsedData {
  String? partyId;
  String? partyType;

  ParsedData({
    this.partyId,
    this.partyType,
  });

  factory ParsedData.fromJson(Map<String, dynamic> json) => ParsedData(
    partyId: json["party_id"],
    partyType: json["party_type"],
  );

  Map<String, dynamic> toJson() => {
    "party_id": partyId,
    "party_type": partyType,
  };
}

class Summary {
  int? totalScans;
  int? totalIn;
  int? totalOut;
  LatestIn? latestIn;
  dynamic latestOut;

  Summary({
    this.totalScans,
    this.totalIn,
    this.totalOut,
    this.latestIn,
    this.latestOut,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    totalScans: json["total_scans"],
    totalIn: json["total_in"],
    totalOut: json["total_out"],
    latestIn: json["latest_in"] == null ? null : LatestIn.fromJson(json["latest_in"]),
    latestOut: json["latest_out"],
  );

  Map<String, dynamic> toJson() => {
    "total_scans": totalScans,
    "total_in": totalIn,
    "total_out": totalOut,
    "latest_in": latestIn?.toJson(),
    "latest_out": latestOut,
  };
}

class LatestIn {
  DateTime? time;
  String? scannedBy;
  String? remarks;

  LatestIn({
    this.time,
    this.scannedBy,
    this.remarks,
  });

  factory LatestIn.fromJson(Map<String, dynamic> json) => LatestIn(
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    scannedBy: json["scanned_by"],
    remarks: json["remarks"],
  );

  Map<String, dynamic> toJson() => {
    "time": time?.toIso8601String(),
    "scanned_by": scannedBy,
    "remarks": remarks,
  };
}

class QrCode {
  Urls? urls;
  Urls? downloadUrls;
  String? text;
  FormattedData? formattedData;

  QrCode({
    this.urls,
    this.downloadUrls,
    this.text,
    this.formattedData,
  });

  factory QrCode.fromJson(Map<String, dynamic> json) => QrCode(
    urls: json["urls"] == null ? null : Urls.fromJson(json["urls"]),
    downloadUrls: json["download_urls"] == null ? null : Urls.fromJson(json["download_urls"]),
    text: json["text"],
    formattedData: json["formatted_data"] == null ? null : FormattedData.fromJson(json["formatted_data"]),
  );

  Map<String, dynamic> toJson() => {
    "urls": urls?.toJson(),
    "download_urls": downloadUrls?.toJson(),
    "text": text,
    "formatted_data": formattedData?.toJson(),
  };
}

class Urls {
  String? png;
  String? svg;
  String? jpg;

  Urls({
    this.png,
    this.svg,
    this.jpg,
  });

  factory Urls.fromJson(Map<String, dynamic> json) => Urls(
    png: json["png"],
    svg: json["svg"],
    jpg: json["jpg"],
  );

  Map<String, dynamic> toJson() => {
    "png": png,
    "svg": svg,
    "jpg": jpg,
  };
}

class FormattedData {
  String? visitor;
  String? name;
  String? phone;
  String? cnic;
  String? apartment;
  String? type;
  String? purpose;
  String? date;
  String? status;
  String? addedBy;

  FormattedData({
    this.visitor,
    this.name,
    this.phone,
    this.cnic,
    this.apartment,
    this.type,
    this.purpose,
    this.date,
    this.status,
    this.addedBy,
  });

  factory FormattedData.fromJson(Map<String, dynamic> json) => FormattedData(
    visitor: json["visitor"],
    name: json["name"],
    phone: json["phone"],
    cnic: json["cnic"],
    apartment: json["apartment"],
    type: json["type"],
    purpose: json["purpose"],
    date: json["date"],
    status: json["status"],
    addedBy: json["added_by"],
  );

  Map<String, dynamic> toJson() => {
    "visitor": visitor,
    "name": name,
    "phone": phone,
    "cnic": cnic,
    "apartment": apartment,
    "type": type,
    "purpose": purpose,
    "date": date,
    "status": status,
    "added_by": addedBy,
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
  DateTime? dateOfExit;
  String? inTime;
  String? outTime;
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
    dateOfExit: json["date_of_exit"] == null ? null : DateTime.parse(json["date_of_exit"]),
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
    "date_of_exit": "${dateOfExit!.year.toString().padLeft(4, '0')}-${dateOfExit!.month.toString().padLeft(2, '0')}-${dateOfExit!.day.toString().padLeft(2, '0')}",
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
