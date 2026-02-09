// To parse this JSON data, do
//
//     final myLeaseModel = myLeaseModelFromJson(jsonString);

import 'dart:convert';

MyLeaseModel myLeaseModelFromJson(String str) => MyLeaseModel.fromJson(json.decode(str));

String myLeaseModelToJson(MyLeaseModel data) => json.encode(data.toJson());

class MyLeaseModel {
  bool? success;
  String? message;
  Data? data;

  MyLeaseModel({
    this.success,
    this.message,
    this.data,
  });

  factory MyLeaseModel.fromJson(Map<String, dynamic> json) => MyLeaseModel(
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
  Tenant? tenant;
  List<Lease>? leases;

  Data({
    this.tenant,
    this.leases,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    tenant: json["tenant"] == null ? null : Tenant.fromJson(json["tenant"]),
    leases: json["leases"] == null ? [] : List<Lease>.from(json["leases"]!.map((x) => Lease.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "tenant": tenant?.toJson(),
    "leases": leases == null ? [] : List<dynamic>.from(leases!.map((x) => x.toJson())),
  };
}

class Lease {
  int? id;
  int? tenantId;
  int? apartmentId;
  DateTime? contractStartDate;
  DateTime? contractEndDate;
  int? rentAmount;
  int? securityDeposit;
  int? advanceAmount;
  int? renewalFee;
  int? commission;
  int? companyCommission;
  int? agentCommission;
  String? rentBillingCycle;
  dynamic contractType;
  String? sourceTenancy;
  String? status;
  DateTime? moveInDate;
  DateTime? moveOutDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  Tenant? tenant;
  Apartment? apartment;

  Lease({
    this.id,
    this.tenantId,
    this.apartmentId,
    this.contractStartDate,
    this.contractEndDate,
    this.rentAmount,
    this.securityDeposit,
    this.advanceAmount,
    this.renewalFee,
    this.commission,
    this.companyCommission,
    this.agentCommission,
    this.rentBillingCycle,
    this.contractType,
    this.sourceTenancy,
    this.status,
    this.moveInDate,
    this.moveOutDate,
    this.createdAt,
    this.updatedAt,
    this.tenant,
    this.apartment,
  });

  factory Lease.fromJson(Map<String, dynamic> json) => Lease(
    id: json["id"],
    tenantId: json["tenant_id"],
    apartmentId: json["apartment_id"],
    contractStartDate: json["contract_start_date"] == null ? null : DateTime.parse(json["contract_start_date"]),
    contractEndDate: json["contract_end_date"] == null ? null : DateTime.parse(json["contract_end_date"]),
    rentAmount: json["rent_amount"],
    securityDeposit: json["security_deposit"],
    advanceAmount: json["advance_amount"],
    renewalFee: json["renewal_fee"],
    commission: json["commission"],
    companyCommission: json["company_commission"],
    agentCommission: json["agent_commission"],
    rentBillingCycle: json["rent_billing_cycle"],
    contractType: json["contract_type"],
    sourceTenancy: json["source_tenancy"],
    status: json["status"],
    moveInDate: json["move_in_date"] == null ? null : DateTime.parse(json["move_in_date"]),
    moveOutDate: json["move_out_date"] == null ? null : DateTime.parse(json["move_out_date"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    tenant: json["tenant"] == null ? null : Tenant.fromJson(json["tenant"]),
    apartment: json["apartment"] == null ? null : Apartment.fromJson(json["apartment"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenant_id": tenantId,
    "apartment_id": apartmentId,
    "contract_start_date": "${contractStartDate!.year.toString().padLeft(4, '0')}-${contractStartDate!.month.toString().padLeft(2, '0')}-${contractStartDate!.day.toString().padLeft(2, '0')}",
    "contract_end_date": "${contractEndDate!.year.toString().padLeft(4, '0')}-${contractEndDate!.month.toString().padLeft(2, '0')}-${contractEndDate!.day.toString().padLeft(2, '0')}",
    "rent_amount": rentAmount,
    "security_deposit": securityDeposit,
    "advance_amount": advanceAmount,
    "renewal_fee": renewalFee,
    "commission": commission,
    "company_commission": companyCommission,
    "agent_commission": agentCommission,
    "rent_billing_cycle": rentBillingCycle,
    "contract_type": contractType,
    "source_tenancy": sourceTenancy,
    "status": status,
    "move_in_date": "${moveInDate!.year.toString().padLeft(4, '0')}-${moveInDate!.month.toString().padLeft(2, '0')}-${moveInDate!.day.toString().padLeft(2, '0')}",
    "move_out_date": "${moveOutDate!.year.toString().padLeft(4, '0')}-${moveOutDate!.month.toString().padLeft(2, '0')}-${moveOutDate!.day.toString().padLeft(2, '0')}",
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "tenant": tenant?.toJson(),
    "apartment": apartment?.toJson(),
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
  List<String>? images;
  dynamic description;
  int? floorId;
  int? towerId;
  int? apartmentId;
  int? userId;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic parkingCodeId;
  Apartments? apartments;
  Floors? floors;
  Towers? towers;
  Society? society;
  List<dynamic>? parkingCodes;

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
    this.apartments,
    this.floors,
    this.towers,
    this.society,
    this.parkingCodes,
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
    images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
    description: json["description"],
    floorId: json["floor_id"],
    towerId: json["tower_id"],
    apartmentId: json["apartment_id"],
    userId: json["user_id"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    parkingCodeId: json["parking_code_id"],
    apartments: json["apartments"] == null ? null : Apartments.fromJson(json["apartments"]),
    floors: json["floors"] == null ? null : Floors.fromJson(json["floors"]),
    towers: json["towers"] == null ? null : Towers.fromJson(json["towers"]),
    society: json["society"] == null ? null : Society.fromJson(json["society"]),
    parkingCodes: json["parking_codes"] == null ? [] : List<dynamic>.from(json["parking_codes"]!.map((x) => x)),
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
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "description": description,
    "floor_id": floorId,
    "tower_id": towerId,
    "apartment_id": apartmentId,
    "user_id": userId,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "parking_code_id": parkingCodeId,
    "apartments": apartments?.toJson(),
    "floors": floors?.toJson(),
    "towers": towers?.toJson(),
    "society": society?.toJson(),
    "parking_codes": parkingCodes == null ? [] : List<dynamic>.from(parkingCodes!.map((x) => x)),
  };
}

class Apartments {
  int? id;
  int? societyId;
  String? apartmentType;
  dynamic maintenanceValue;
  DateTime? createdAt;
  DateTime? updatedAt;

  Apartments({
    this.id,
    this.societyId,
    this.apartmentType,
    this.maintenanceValue,
    this.createdAt,
    this.updatedAt,
  });

  factory Apartments.fromJson(Map<String, dynamic> json) => Apartments(
    id: json["id"],
    societyId: json["society_id"],
    apartmentType: json["apartment_type"],
    maintenanceValue: json["maintenance_value"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "society_id": societyId,
    "apartment_type": apartmentType,
    "maintenance_value": maintenanceValue,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
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
  User? user;
  List<dynamic>? documents;
  List<dynamic>? familyMembers;
  dynamic taxDefination;

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
    this.documents,
    this.familyMembers,
    this.taxDefination,
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
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    documents: json["documents"] == null ? [] : List<dynamic>.from(json["documents"]!.map((x) => x)),
    familyMembers: json["family_members"] == null ? [] : List<dynamic>.from(json["family_members"]!.map((x) => x)),
    taxDefination: json["tax_defination"],
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
    "documents": documents == null ? [] : List<dynamic>.from(documents!.map((x) => x)),
    "family_members": familyMembers == null ? [] : List<dynamic>.from(familyMembers!.map((x) => x)),
    "tax_defination": taxDefination,
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
