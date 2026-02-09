// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) => UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) => json.encode(data.toJson());

class UserProfileModel {
  bool? success;
  Data? data;

  UserProfileModel({
    this.success,
    this.data,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
    success: json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
  };
}

class Data {
  User? user;

  Data({
    this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
  };
}

class User {
  Info? info;
  Meta? meta;
  Society? society;
  Role? role;

  User({
    this.info,
    this.meta,
    this.society,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    info: json["info"] == null ? null : Info.fromJson(json["info"]),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    society: json["society"] == null ? null : Society.fromJson(json["society"]),
    role: json["role"] == null ? null : Role.fromJson(json["role"]),
  );

  Map<String, dynamic> toJson() => {
    "info": info?.toJson(),
    "meta": meta?.toJson(),
    "society": society?.toJson(),
    "role": role?.toJson(),
  };
}

class Info {
  int? id;
  String? name;
  String? email;
  String? phoneNumber;
  int? roleId;
  int? owner;
  int? tenant;
  String? status;
  String? profilePhotoUrl;

  Info({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.roleId,
    this.owner,
    this.tenant,
    this.status,
    this.profilePhotoUrl,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phoneNumber: json["phone_number"],
    roleId: json["role_id"],
    owner: json["owner"],
    tenant: json["tenant"],
    status: json["status"],
    profilePhotoUrl: json["profile_photo_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone_number": phoneNumber,
    "role_id": roleId,
    "owner": owner,
    "tenant": tenant,
    "status": status,
    "profile_photo_url": profilePhotoUrl,
  };
}

class Meta {
  String? firstName;
  String? email;
  String? phoneNumber;
  String? nationalIdNumber;
  String? address;
  DateTime? dob;
  String? bloodGroup;
  String? passport;
  String? country;
  String? companyName;
  String? companyRegistrationNumber;
  String? alternatePhone;
  String? whatsappNumber;
  String? emergencyContactName;
  String? emergencyContactNo;

  Meta({
    this.firstName,
    this.email,
    this.phoneNumber,
    this.nationalIdNumber,
    this.address,
    this.dob,
    this.bloodGroup,
    this.passport,
    this.country,
    this.companyName,
    this.companyRegistrationNumber,
    this.alternatePhone,
    this.whatsappNumber,
    this.emergencyContactName,
    this.emergencyContactNo,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    firstName: json["first_name"],
    email: json["email"],
    phoneNumber: json["phone_number"],
    nationalIdNumber: json["national_id_number"],
    address: json["address"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    bloodGroup: json["blood_group"],
    passport: json["passport"],
    country: json["country"],
    companyName: json["company_name"],
    companyRegistrationNumber: json["company_registration_number"],
    alternatePhone: json["alternate_phone"],
    whatsappNumber: json["whatsapp_number"],
    emergencyContactName: json["emergency_contact_name"],
    emergencyContactNo: json["emergency_contact_no"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "email": email,
    "phone_number": phoneNumber,
    "national_id_number": nationalIdNumber,
    "address": address,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "blood_group": bloodGroup,
    "passport": passport,
    "country": country,
    "company_name": companyName,
    "company_registration_number": companyRegistrationNumber,
    "alternate_phone": alternatePhone,
    "whatsapp_number": whatsappNumber,
    "emergency_contact_name": emergencyContactName,
    "emergency_contact_no": emergencyContactNo,
  };
}

class Role {
  int? id;
  String? name;

  Role({
    this.id,
    this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
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
