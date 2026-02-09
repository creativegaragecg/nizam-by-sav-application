// To parse this JSON data, do
//
//     final unitDetails = unitDetailsFromJson(jsonString);

import 'dart:convert';

UnitDetails unitDetailsFromJson(String str) => UnitDetails.fromJson(json.decode(str));

String unitDetailsToJson(UnitDetails data) => json.encode(data.toJson());

class UnitDetails {
  bool? success;
  String? message;
  Data? data;

  UnitDetails({
    this.success,
    this.message,
    this.data,
  });

  factory UnitDetails.fromJson(Map<String, dynamic> json) => UnitDetails(
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
  Unit? unit;
  PaymentProfile? paymentProfile;

  Data({
    this.unit,
    this.paymentProfile,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    unit: json["unit"] == null ? null : Unit.fromJson(json["unit"]),
    paymentProfile: json["payment_profile"] == null ? null : PaymentProfile.fromJson(json["payment_profile"]),
  );

  Map<String, dynamic> toJson() => {
    "unit": unit?.toJson(),
    "payment_profile": paymentProfile?.toJson(),
  };
}

class PaymentProfile {
  PaymentSummary? paymentSummary;
  dynamic installment;
  List<InstallmentPayment>? installmentPayments;
  List<dynamic>? otherCharges;

  PaymentProfile({
    this.paymentSummary,
    this.installment,
    this.installmentPayments,
    this.otherCharges,
  });

  factory PaymentProfile.fromJson(Map<String, dynamic> json) => PaymentProfile(
    paymentSummary: json["payment_summary"] == null ? null : PaymentSummary.fromJson(json["payment_summary"]),
    installment: json["installment"],
    installmentPayments: json["installment_payments"] == null ? [] : List<InstallmentPayment>.from(json["installment_payments"]!.map((x) => InstallmentPayment.fromJson(x))),
    otherCharges: json["other_charges"] == null ? [] : List<dynamic>.from(json["other_charges"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "payment_summary": paymentSummary?.toJson(),
    "installment": installment,
    "installment_payments": installmentPayments == null ? [] : List<dynamic>.from(installmentPayments!.map((x) => x.toJson())),
    "other_charges": otherCharges == null ? [] : List<dynamic>.from(otherCharges!.map((x) => x)),
  };
}

class InstallmentPayment {
  int? id;
  int? dueAmount;
  int? paidAmount;
  int? advanceAmount;
  String? status;
  DateTime? dueDate;
  dynamic paymentDate;
  dynamic financialStatus;
  DateTime? createdAt;

  InstallmentPayment({
    this.id,
    this.dueAmount,
    this.paidAmount,
    this.advanceAmount,
    this.status,
    this.dueDate,
    this.paymentDate,
    this.financialStatus,
    this.createdAt,
  });

  factory InstallmentPayment.fromJson(Map<String, dynamic> json) => InstallmentPayment(
    id: json["id"],
    dueAmount: json["due_amount"],
    paidAmount: json["paid_amount"],
    advanceAmount: json["advance_amount"],
    status: json["status"],
    dueDate: json["due_date"] == null ? null : DateTime.parse(json["due_date"]),
    paymentDate: json["payment_date"],
    financialStatus: json["financial_status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "due_amount": dueAmount,
    "paid_amount": paidAmount,
    "advance_amount": advanceAmount,
    "status": status,
    "due_date": "${dueDate!.year.toString().padLeft(4, '0')}-${dueDate!.month.toString().padLeft(2, '0')}-${dueDate!.day.toString().padLeft(2, '0')}",
    "payment_date": paymentDate,
    "financial_status": financialStatus,
    "created_at": createdAt?.toIso8601String(),
  };
}

class PaymentSummary {
  String? totalAmount;
  String? totalDueAmount;
  String? totalPaidAmount;
  dynamic lastPaidAmount;
  dynamic lastPaymentDate;

  PaymentSummary({
    this.totalAmount,
    this.totalDueAmount,
    this.totalPaidAmount,
    this.lastPaidAmount,
    this.lastPaymentDate,
  });

  factory PaymentSummary.fromJson(Map<String, dynamic> json) => PaymentSummary(
    totalAmount: json["total_amount"],
    totalDueAmount: json["total_due_amount"],
    totalPaidAmount: json["total_paid_amount"],
    lastPaidAmount: json["last_paid_amount"],
    lastPaymentDate: json["last_payment_date"],
  );

  Map<String, dynamic> toJson() => {
    "total_amount": totalAmount,
    "total_due_amount": totalDueAmount,
    "total_paid_amount": totalPaidAmount,
    "last_paid_amount": lastPaidAmount,
    "last_payment_date": lastPaymentDate,
  };
}

class Unit {
  int? id;
  String? refNo;
  int? apartmentId;
  int? userId;
  DateTime? contractDate;
  ContractType? contractType;
  String? commission;
  String? companyCommission;
  String? agentCommission;
  int? totalPrice;
  int? discountAmount;
  int? netPrice;
  String? paymentType;
  int? advanceAmount;
  dynamic installmentStartDate;
  dynamic installmentId;
  int? sourceId;
  dynamic status;
  int? financialStatus;
  int? isApproved;
  DateTime? createdAt;
  DateTime? updatedAt;
  Apartment? apartment;
  ContractType? source;
  User? user;

  Unit({
    this.id,
    this.refNo,
    this.apartmentId,
    this.userId,
    this.contractDate,
    this.contractType,
    this.commission,
    this.companyCommission,
    this.agentCommission,
    this.totalPrice,
    this.discountAmount,
    this.netPrice,
    this.paymentType,
    this.advanceAmount,
    this.installmentStartDate,
    this.installmentId,
    this.sourceId,
    this.status,
    this.financialStatus,
    this.isApproved,
    this.createdAt,
    this.updatedAt,
    this.apartment,
    this.source,
    this.user,
  });

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
    id: json["id"],
    refNo: json["ref_no"],
    apartmentId: json["apartment_id"],
    userId: json["user_id"],
    contractDate: json["contract_date"] == null ? null : DateTime.parse(json["contract_date"]),
    contractType: json["contract_type"] == null ? null : ContractType.fromJson(json["contract_type"]),
    commission: json["commission"],
    companyCommission: json["company_commission"],
    agentCommission: json["agent_commission"],
    totalPrice: json["total_price"],
    discountAmount: json["discount_amount"],
    netPrice: json["net_price"],
    paymentType: json["payment_type"],
    advanceAmount: json["advance_amount"],
    installmentStartDate: json["installment_start_date"],
    installmentId: json["installment_id"],
    sourceId: json["source_id"],
    status: json["status"],
    financialStatus: json["financial_status"],
    isApproved: json["is_approved"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    apartment: json["apartment"] == null ? null : Apartment.fromJson(json["apartment"]),
    source: json["source"] == null ? null : ContractType.fromJson(json["source"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ref_no": refNo,
    "apartment_id": apartmentId,
    "user_id": userId,
    "contract_date": contractDate?.toIso8601String(),
    "contract_type": contractType?.toJson(),
    "commission": commission,
    "company_commission": companyCommission,
    "agent_commission": agentCommission,
    "total_price": totalPrice,
    "discount_amount": discountAmount,
    "net_price": netPrice,
    "payment_type": paymentType,
    "advance_amount": advanceAmount,
    "installment_start_date": installmentStartDate,
    "installment_id": installmentId,
    "source_id": sourceId,
    "status": status,
    "financial_status": financialStatus,
    "is_approved": isApproved,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "apartment": apartment?.toJson(),
    "source": source?.toJson(),
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
  List<dynamic>? tenants;
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
    this.tenants,
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
    tenants: json["tenants"] == null ? [] : List<dynamic>.from(json["tenants"]!.map((x) => x)),
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
    "tenants": tenants == null ? [] : List<dynamic>.from(tenants!.map((x) => x)),
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

class ContractType {
  int? id;
  int? lookupId;
  String? key;
  String? name;
  int? orderId;
  int? isActive;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;

  ContractType({
    this.id,
    this.lookupId,
    this.key,
    this.name,
    this.orderId,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory ContractType.fromJson(Map<String, dynamic> json) => ContractType(
    id: json["id"],
    lookupId: json["lookup_id"],
    key: json["key"],
    name: json["name"],
    orderId: json["order_id"],
    isActive: json["is_active"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "lookup_id": lookupId,
    "key": key,
    "name": name,
    "order_id": orderId,
    "is_active": isActive,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "deleted_at": deletedAt,
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
