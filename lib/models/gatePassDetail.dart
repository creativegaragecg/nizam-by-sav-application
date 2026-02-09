// To parse this JSON data, do
//
//     final gatePassRequestDetailModel = gatePassRequestDetailModelFromJson(jsonString);

import 'dart:convert';

GatePassRequestDetailModel gatePassRequestDetailModelFromJson(String str) => GatePassRequestDetailModel.fromJson(json.decode(str));

String gatePassRequestDetailModelToJson(GatePassRequestDetailModel data) => json.encode(data.toJson());

class GatePassRequestDetailModel {
  bool? success;
  String? message;
  Data? data;

  GatePassRequestDetailModel({
    this.success,
    this.message,
    this.data,
  });

  factory GatePassRequestDetailModel.fromJson(Map<String, dynamic> json) => GatePassRequestDetailModel(
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
  GatePassRequest? gatePassRequest;
  QrCode? qrCode;

  Data({
    this.gatePassRequest,
    this.qrCode,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    gatePassRequest: json["gate_pass_request"] == null ? null : GatePassRequest.fromJson(json["gate_pass_request"]),
    qrCode: json["qr_code"] == null ? null : QrCode.fromJson(json["qr_code"]),
  );

  Map<String, dynamic> toJson() => {
    "gate_pass_request": gatePassRequest?.toJson(),
    "qr_code": qrCode?.toJson(),
  };
}

class GatePassRequest {
  int? id;
  int? societyId;
  int? tenantId;
  String? item;
  String? passType;
  int? issuedBy;
  String? passNumber;
  dynamic passPurpose;
  DateTime? expectedOutTime;
  dynamic actualOutTime;
  dynamic returnedOn;
  dynamic returnVerifiedBy;
  dynamic approvedBy;
  String? returnStatus;
  dynamic remarks;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  Tenant? tenant;
  Issuer? issuer;
  dynamic returnVerifier;

  GatePassRequest({
    this.id,
    this.societyId,
    this.tenantId,
    this.item,
    this.passType,
    this.issuedBy,
    this.passNumber,
    this.passPurpose,
    this.expectedOutTime,
    this.actualOutTime,
    this.returnedOn,
    this.returnVerifiedBy,
    this.approvedBy,
    this.returnStatus,
    this.remarks,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.tenant,
    this.issuer,
    this.returnVerifier,
  });

  factory GatePassRequest.fromJson(Map<String, dynamic> json) => GatePassRequest(
    id: json["id"],
    societyId: json["society_id"],
    tenantId: json["tenant_id"],
    item: json["item"],
    passType: json["pass_type"],
    issuedBy: json["issued_by"],
    passNumber: json["pass_number"],
    passPurpose: json["pass_purpose"],
    expectedOutTime: json["expected_out_time"] == null ? null : DateTime.parse(json["expected_out_time"]),
    actualOutTime: json["actual_out_time"],
    returnedOn: json["returned_on"],
    returnVerifiedBy: json["return_verified_by"],
    approvedBy: json["approved_by"],
    returnStatus: json["return_status"],
    remarks: json["remarks"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    tenant: json["tenant"] == null ? null : Tenant.fromJson(json["tenant"]),
    issuer: json["issuer"] == null ? null : Issuer.fromJson(json["issuer"]),
    returnVerifier: json["return_verifier"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "society_id": societyId,
    "tenant_id": tenantId,
    "item": item,
    "pass_type": passType,
    "issued_by": issuedBy,
    "pass_number": passNumber,
    "pass_purpose": passPurpose,
    "expected_out_time": expectedOutTime?.toIso8601String(),
    "actual_out_time": actualOutTime,
    "returned_on": returnedOn,
    "return_verified_by": returnVerifiedBy,
    "approved_by": approvedBy,
    "return_status": returnStatus,
    "remarks": remarks,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "tenant": tenant?.toJson(),
    "issuer": issuer?.toJson(),
    "return_verifier": returnVerifier,
  };
}

class Issuer {
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

  Issuer({
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

  factory Issuer.fromJson(Map<String, dynamic> json) => Issuer(
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
  Issuer? user;

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
    user: json["user"] == null ? null : Issuer.fromJson(json["user"]),
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
  String? gatePass;
  String? tenant;
  String? ref;
  String? item;
  String? type;
  String? expectedOut;
  String? status;
  String? issuedBy;
  String? created;

  FormattedData({
    this.gatePass,
    this.tenant,
    this.ref,
    this.item,
    this.type,
    this.expectedOut,
    this.status,
    this.issuedBy,
    this.created,
  });

  factory FormattedData.fromJson(Map<String, dynamic> json) => FormattedData(
    gatePass: json["gate_pass"],
    tenant: json["tenant"],
    ref: json["ref"],
    item: json["item"],
    type: json["type"],
    expectedOut: json["expected_out"],
    status: json["status"],
    issuedBy: json["issued_by"],
    created: json["created"],
  );

  Map<String, dynamic> toJson() => {
    "gate_pass": gatePass,
    "tenant": tenant,
    "ref": ref,
    "item": item,
    "type": type,
    "expected_out": expectedOut,
    "status": status,
    "issued_by": issuedBy,
    "created": created,
  };
}
