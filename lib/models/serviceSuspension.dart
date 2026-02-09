// To parse this JSON data, do
//
//     final serviceSuspensionModel = serviceSuspensionModelFromJson(jsonString);

import 'dart:convert';

ServiceSuspensionModel serviceSuspensionModelFromJson(String str) => ServiceSuspensionModel.fromJson(json.decode(str));

String serviceSuspensionModelToJson(ServiceSuspensionModel data) => json.encode(data.toJson());

class ServiceSuspensionModel {
  bool? success;
  String? message;
  Data? data;

  ServiceSuspensionModel({
    this.success,
    this.message,
    this.data,
  });

  factory ServiceSuspensionModel.fromJson(Map<String, dynamic> json) => ServiceSuspensionModel(
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
  int? tenantId;
  List<Suspension>? suspensions;
  Statistics? statistics;

  Data({
    this.tenantId,
    this.suspensions,
    this.statistics,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    tenantId: json["tenant_id"],
    suspensions: json["suspensions"] == null ? [] : List<Suspension>.from(json["suspensions"]!.map((x) => Suspension.fromJson(x))),
    statistics: json["statistics"] == null ? null : Statistics.fromJson(json["statistics"]),
  );

  Map<String, dynamic> toJson() => {
    "tenant_id": tenantId,
    "suspensions": suspensions == null ? [] : List<dynamic>.from(suspensions!.map((x) => x.toJson())),
    "statistics": statistics?.toJson(),
  };
}

class Statistics {
  int? total;
  int? submitted;
  int? underReview;
  int? inProgress;
  int? suspended;
  int? restored;

  Statistics({
    this.total,
    this.submitted,
    this.underReview,
    this.inProgress,
    this.suspended,
    this.restored,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) => Statistics(
    total: json["total"],
    submitted: json["submitted"],
    underReview: json["under_review"],
    inProgress: json["in_progress"],
    suspended: json["suspended"],
    restored: json["restored"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "submitted": submitted,
    "under_review": underReview,
    "in_progress": inProgress,
    "suspended": suspended,
    "restored": restored,
  };
}

class Suspension {
  int? id;
  int? societyId;
  int? suspensionNumber;
  int? tenantId;
  int? typeId;
  String? status;
  int? agentId;
  String? subject;
  String? reply;
  dynamic resolvedTime;
  DateTime? createdAt;
  DateTime? updatedAt;
  SuspensionType? suspensionType;
  Agent? agent;
  Tenant? tenant;
  Society? society;

  Suspension({
    this.id,
    this.societyId,
    this.suspensionNumber,
    this.tenantId,
    this.typeId,
    this.status,
    this.agentId,
    this.subject,
    this.reply,
    this.resolvedTime,
    this.createdAt,
    this.updatedAt,
    this.suspensionType,
    this.agent,
    this.tenant,
    this.society,
  });

  factory Suspension.fromJson(Map<String, dynamic> json) => Suspension(
    id: json["id"],
    societyId: json["society_id"],
    suspensionNumber: json["suspension_number"],
    tenantId: json["tenant_id"],
    typeId: json["type_id"],
    status: json["status"],
    agentId: json["agent_id"],
    subject: json["subject"],
    reply: json["reply"],
    resolvedTime: json["resolved_time"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    suspensionType: json["suspension_type"] == null ? null : SuspensionType.fromJson(json["suspension_type"]),
    agent: json["agent"] == null ? null : Agent.fromJson(json["agent"]),
    tenant: json["tenant"] == null ? null : Tenant.fromJson(json["tenant"]),
    society: json["society"] == null ? null : Society.fromJson(json["society"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "society_id": societyId,
    "suspension_number": suspensionNumber,
    "tenant_id": tenantId,
    "type_id": typeId,
    "status": status,
    "agent_id": agentId,
    "subject": subject,
    "reply": reply,
    "resolved_time": resolvedTime,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "suspension_type": suspensionType?.toJson(),
    "agent": agent?.toJson(),
    "tenant": tenant?.toJson(),
    "society": society?.toJson(),
  };
}

class Agent {
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

  Agent({
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

  factory Agent.fromJson(Map<String, dynamic> json) => Agent(
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

class Society {
  int? id;
  String? name;
  String? logoUrl;

  Society({
    this.id,
    this.name,
    this.logoUrl,
  });

  factory Society.fromJson(Map<String, dynamic> json) => Society(
    id: json["id"],
    name: json["name"],
    logoUrl: json["logo_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "logo_url": logoUrl,
  };
}

class SuspensionType {
  int? id;
  int? societyId;
  String? typeName;
  dynamic resolvedTime;
  DateTime? createdAt;
  DateTime? updatedAt;

  SuspensionType({
    this.id,
    this.societyId,
    this.typeName,
    this.resolvedTime,
    this.createdAt,
    this.updatedAt,
  });

  factory SuspensionType.fromJson(Map<String, dynamic> json) => SuspensionType(
    id: json["id"],
    societyId: json["society_id"],
    typeName: json["type_name"],
    resolvedTime: json["resolved_time"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "society_id": societyId,
    "type_name": typeName,
    "resolved_time": resolvedTime,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
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
  Agent? user;

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
    user: json["user"] == null ? null : Agent.fromJson(json["user"]),
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
