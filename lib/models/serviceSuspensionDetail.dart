// To parse this JSON data, do
//
//     final serviceSuspensionDetailModel = serviceSuspensionDetailModelFromJson(jsonString);

import 'dart:convert';

ServiceSuspensionDetailModel serviceSuspensionDetailModelFromJson(String str) => ServiceSuspensionDetailModel.fromJson(json.decode(str));

String serviceSuspensionDetailModelToJson(ServiceSuspensionDetailModel data) => json.encode(data.toJson());

class ServiceSuspensionDetailModel {
  bool? success;
  String? message;
  Data? data;

  ServiceSuspensionDetailModel({
    this.success,
    this.message,
    this.data,
  });

  factory ServiceSuspensionDetailModel.fromJson(Map<String, dynamic> json) => ServiceSuspensionDetailModel(
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
  ServiceSuspension? serviceSuspension;

  Data({
    this.tenantId,
    this.serviceSuspension,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    tenantId: json["tenant_id"],
    serviceSuspension: json["service_suspension"] == null ? null : ServiceSuspension.fromJson(json["service_suspension"]),
  );

  Map<String, dynamic> toJson() => {
    "tenant_id": tenantId,
    "service_suspension": serviceSuspension?.toJson(),
  };
}

class ServiceSuspension {
  int? id;
  int? societyId;
  int? suspensionNumber;
  int? tenantId;
  int? typeId;
  String? status;
  int? agentId;
  String? subject;
  List<Reply>? reply;
  dynamic resolvedTime;
  DateTime? createdAt;
  DateTime? updatedAt;
  SuspensionType? suspensionType;
  Agent? agent;
  Tenant? tenant;
  Society? society;

  ServiceSuspension({
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

  factory ServiceSuspension.fromJson(Map<String, dynamic> json) => ServiceSuspension(
    id: json["id"],
    societyId: json["society_id"],
    suspensionNumber: json["suspension_number"],
    tenantId: json["tenant_id"],
    typeId: json["type_id"],
    status: json["status"],
    agentId: json["agent_id"],
    subject: json["subject"],
    reply: json["reply"] == null ? [] : List<Reply>.from(json["reply"]!.map((x) => Reply.fromJson(x))),
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
    "reply": reply == null ? [] : List<dynamic>.from(reply!.map((x) => x.toJson())),
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

class Reply {
  int? id;
  int? suspensionId;
  int? userId;
  int? parentId;
  String? message;
  DateTime? createdAt;
  DateTime? updatedAt;
  Agent? user;
  List<dynamic>? files;

  Reply({
    this.id,
    this.suspensionId,
    this.userId,
    this.parentId,
    this.message,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.files,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
    id: json["id"],
    suspensionId: json["suspension_id"],
    userId: json["user_id"],
    parentId: json["parent_id"],
    message: json["message"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    user: json["user"] == null ? null : Agent.fromJson(json["user"]),
    files: json["files"] == null ? [] : List<dynamic>.from(json["files"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "suspension_id": suspensionId,
    "user_id": userId,
    "parent_id": parentId,
    "message": message,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "user": user?.toJson(),
    "files": files == null ? [] : List<dynamic>.from(files!.map((x) => x)),
  };
}

class Society {
  int? id;
  String? name;
  String? hash;
  String? slug;
  String? email;
  String? phoneNumber;
  dynamic propertyMeasurement;
  String? logo;
  dynamic fevicon;
  String? themeRgb;
  String? themeHex;
  String? timezone;
  String? address;
  String? key;
  int? countryId;
  int? currencyId;
  String? licenseType;
  int? isActive;
  String? aboutUs;
  int? showLogoText;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? customerLoginRequired;
  int? packageId;
  String? packageType;
  String? status;
  DateTime? licenseExpireOn;
  DateTime? trialEndsAt;
  DateTime? licenseUpdatedAt;
  DateTime? subscriptionUpdatedAt;
  dynamic stripeId;
  dynamic pmType;
  dynamic pmLastFour;
  String? facebookLink;
  String? instagramLink;
  String? twitterLink;
  String? approvalStatus;
  dynamic rejectionReason;
  dynamic metaKeyword;
  dynamic metaDescription;
  dynamic uploadFavIconAndroidChrome192;
  dynamic uploadFavIconAndroidChrome512;
  dynamic uploadFavIconAppleTouchIcon;
  dynamic uploadFavicon16;
  dynamic uploadFavicon32;
  dynamic favicon;
  dynamic webmanifest;
  int? isPwaInstallAlertShow;
  dynamic countryPhonecode;
  String? logoUrl;

  Society({
    this.id,
    this.name,
    this.hash,
    this.slug,
    this.email,
    this.phoneNumber,
    this.propertyMeasurement,
    this.logo,
    this.fevicon,
    this.themeRgb,
    this.themeHex,
    this.timezone,
    this.address,
    this.key,
    this.countryId,
    this.currencyId,
    this.licenseType,
    this.isActive,
    this.aboutUs,
    this.showLogoText,
    this.createdAt,
    this.updatedAt,
    this.customerLoginRequired,
    this.packageId,
    this.packageType,
    this.status,
    this.licenseExpireOn,
    this.trialEndsAt,
    this.licenseUpdatedAt,
    this.subscriptionUpdatedAt,
    this.stripeId,
    this.pmType,
    this.pmLastFour,
    this.facebookLink,
    this.instagramLink,
    this.twitterLink,
    this.approvalStatus,
    this.rejectionReason,
    this.metaKeyword,
    this.metaDescription,
    this.uploadFavIconAndroidChrome192,
    this.uploadFavIconAndroidChrome512,
    this.uploadFavIconAppleTouchIcon,
    this.uploadFavicon16,
    this.uploadFavicon32,
    this.favicon,
    this.webmanifest,
    this.isPwaInstallAlertShow,
    this.countryPhonecode,
    this.logoUrl,
  });

  factory Society.fromJson(Map<String, dynamic> json) => Society(
    id: json["id"],
    name: json["name"],
    hash: json["hash"],
    slug: json["slug"],
    email: json["email"],
    phoneNumber: json["phone_number"],
    propertyMeasurement: json["property_measurement"],
    logo: json["logo"],
    fevicon: json["fevicon"],
    themeRgb: json["theme_rgb"],
    themeHex: json["theme_hex"],
    timezone: json["timezone"],
    address: json["address"],
    key: json["key"],
    countryId: json["country_id"],
    currencyId: json["currency_id"],
    licenseType: json["license_type"],
    isActive: json["is_active"],
    aboutUs: json["about_us"],
    showLogoText: json["show_logo_text"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    customerLoginRequired: json["customer_login_required"],
    packageId: json["package_id"],
    packageType: json["package_type"],
    status: json["status"],
    licenseExpireOn: json["license_expire_on"] == null ? null : DateTime.parse(json["license_expire_on"]),
    trialEndsAt: json["trial_ends_at"] == null ? null : DateTime.parse(json["trial_ends_at"]),
    licenseUpdatedAt: json["license_updated_at"] == null ? null : DateTime.parse(json["license_updated_at"]),
    subscriptionUpdatedAt: json["subscription_updated_at"] == null ? null : DateTime.parse(json["subscription_updated_at"]),
    stripeId: json["stripe_id"],
    pmType: json["pm_type"],
    pmLastFour: json["pm_last_four"],
    facebookLink: json["facebook_link"],
    instagramLink: json["instagram_link"],
    twitterLink: json["twitter_link"],
    approvalStatus: json["approval_status"],
    rejectionReason: json["rejection_reason"],
    metaKeyword: json["meta_keyword"],
    metaDescription: json["meta_description"],
    uploadFavIconAndroidChrome192: json["upload_fav_icon_android_chrome_192"],
    uploadFavIconAndroidChrome512: json["upload_fav_icon_android_chrome_512"],
    uploadFavIconAppleTouchIcon: json["upload_fav_icon_apple_touch_icon"],
    uploadFavicon16: json["upload_favicon_16"],
    uploadFavicon32: json["upload_favicon_32"],
    favicon: json["favicon"],
    webmanifest: json["webmanifest"],
    isPwaInstallAlertShow: json["is_pwa_install_alert_show"],
    countryPhonecode: json["country_phonecode"],
    logoUrl: json["logo_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "hash": hash,
    "slug": slug,
    "email": email,
    "phone_number": phoneNumber,
    "property_measurement": propertyMeasurement,
    "logo": logo,
    "fevicon": fevicon,
    "theme_rgb": themeRgb,
    "theme_hex": themeHex,
    "timezone": timezone,
    "address": address,
    "key": key,
    "country_id": countryId,
    "currency_id": currencyId,
    "license_type": licenseType,
    "is_active": isActive,
    "about_us": aboutUs,
    "show_logo_text": showLogoText,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "customer_login_required": customerLoginRequired,
    "package_id": packageId,
    "package_type": packageType,
    "status": status,
    "license_expire_on": licenseExpireOn?.toIso8601String(),
    "trial_ends_at": trialEndsAt?.toIso8601String(),
    "license_updated_at": licenseUpdatedAt?.toIso8601String(),
    "subscription_updated_at": subscriptionUpdatedAt?.toIso8601String(),
    "stripe_id": stripeId,
    "pm_type": pmType,
    "pm_last_four": pmLastFour,
    "facebook_link": facebookLink,
    "instagram_link": instagramLink,
    "twitter_link": twitterLink,
    "approval_status": approvalStatus,
    "rejection_reason": rejectionReason,
    "meta_keyword": metaKeyword,
    "meta_description": metaDescription,
    "upload_fav_icon_android_chrome_192": uploadFavIconAndroidChrome192,
    "upload_fav_icon_android_chrome_512": uploadFavIconAndroidChrome512,
    "upload_fav_icon_apple_touch_icon": uploadFavIconAppleTouchIcon,
    "upload_favicon_16": uploadFavicon16,
    "upload_favicon_32": uploadFavicon32,
    "favicon": favicon,
    "webmanifest": webmanifest,
    "is_pwa_install_alert_show": isPwaInstallAlertShow,
    "country_phonecode": countryPhonecode,
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
