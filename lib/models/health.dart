// To parse this JSON data, do
//
//     final healthModel = healthModelFromJson(jsonString);

import 'dart:convert';

HealthModel healthModelFromJson(String str) => HealthModel.fromJson(json.decode(str));

String healthModelToJson(HealthModel data) => json.encode(data.toJson());

class HealthModel {
  User? user;
  Health? health;
  Breakdown? breakdown;
  List<Tenant>? tenants;
  int? totalTenants;

  HealthModel({
    this.user,
    this.health,
    this.breakdown,
    this.tenants,
    this.totalTenants,
  });

  factory HealthModel.fromJson(Map<String, dynamic> json) => HealthModel(
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    health: json["health"] == null ? null : Health.fromJson(json["health"]),
    breakdown: json["breakdown"] == null ? null : Breakdown.fromJson(json["breakdown"]),
    tenants: json["tenants"] == null ? [] : List<Tenant>.from(json["tenants"]!.map((x) => Tenant.fromJson(x))),
    totalTenants: json["total_tenants"],
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "health": health?.toJson(),
    "breakdown": breakdown?.toJson(),
    "tenants": tenants == null ? [] : List<dynamic>.from(tenants!.map((x) => x.toJson())),
    "total_tenants": totalTenants,
  };
}

class Breakdown {
  Verification? verification;
  Violations? violations;
  LegalNotices? legalNotices;
  ServiceSuspensions? serviceSuspensions;
  UnpaidBills? unpaidBills;

  Breakdown({
    this.verification,
    this.violations,
    this.legalNotices,
    this.serviceSuspensions,
    this.unpaidBills,
  });

  factory Breakdown.fromJson(Map<String, dynamic> json) => Breakdown(
    verification: json["verification"] == null ? null : Verification.fromJson(json["verification"]),
    violations: json["violations"] == null ? null : Violations.fromJson(json["violations"]),
    legalNotices: json["legal_notices"] == null ? null : LegalNotices.fromJson(json["legal_notices"]),
    serviceSuspensions: json["service_suspensions"] == null ? null : ServiceSuspensions.fromJson(json["service_suspensions"]),
    unpaidBills: json["unpaid_bills"] == null ? null : UnpaidBills.fromJson(json["unpaid_bills"]),
  );

  Map<String, dynamic> toJson() => {
    "verification": verification?.toJson(),
    "violations": violations?.toJson(),
    "legal_notices": legalNotices?.toJson(),
    "service_suspensions": serviceSuspensions?.toJson(),
    "unpaid_bills": unpaidBills?.toJson(),
  };
}

class LegalNotices {
  int? weight;
  int? penalty;
  int? remaining;
  LegalNoticesDetails? details;

  LegalNotices({
    this.weight,
    this.penalty,
    this.remaining,
    this.details,
  });

  factory LegalNotices.fromJson(Map<String, dynamic> json) => LegalNotices(
    weight: json["weight"],
    penalty: json["penalty"],
    remaining: json["remaining"],
    details: json["details"] == null ? null : LegalNoticesDetails.fromJson(json["details"]),
  );

  Map<String, dynamic> toJson() => {
    "weight": weight,
    "penalty": penalty,
    "remaining": remaining,
    "details": details?.toJson(),
  };
}

class LegalNoticesDetails {
  int? activeNotices;
  int? maxAllowed;

  LegalNoticesDetails({
    this.activeNotices,
    this.maxAllowed,
  });

  factory LegalNoticesDetails.fromJson(Map<String, dynamic> json) => LegalNoticesDetails(
    activeNotices: json["active_notices"],
    maxAllowed: json["max_allowed"],
  );

  Map<String, dynamic> toJson() => {
    "active_notices": activeNotices,
    "max_allowed": maxAllowed,
  };
}

class ServiceSuspensions {
  int? weight;
  int? penalty;
  int? remaining;
  ServiceSuspensionsDetails? details;

  ServiceSuspensions({
    this.weight,
    this.penalty,
    this.remaining,
    this.details,
  });

  factory ServiceSuspensions.fromJson(Map<String, dynamic> json) => ServiceSuspensions(
    weight: json["weight"],
    penalty: json["penalty"],
    remaining: json["remaining"],
    details: json["details"] == null ? null : ServiceSuspensionsDetails.fromJson(json["details"]),
  );

  Map<String, dynamic> toJson() => {
    "weight": weight,
    "penalty": penalty,
    "remaining": remaining,
    "details": details?.toJson(),
  };
}

class ServiceSuspensionsDetails {
  int? activeSuspensions;
  int? maxAllowed;

  ServiceSuspensionsDetails({
    this.activeSuspensions,
    this.maxAllowed,
  });

  factory ServiceSuspensionsDetails.fromJson(Map<String, dynamic> json) => ServiceSuspensionsDetails(
    activeSuspensions: json["active_suspensions"],
    maxAllowed: json["max_allowed"],
  );

  Map<String, dynamic> toJson() => {
    "active_suspensions": activeSuspensions,
    "max_allowed": maxAllowed,
  };
}

class UnpaidBills {
  int? weight;
  int? penalty;
  int? remaining;
  UnpaidBillsDetails? details;

  UnpaidBills({
    this.weight,
    this.penalty,
    this.remaining,
    this.details,
  });

  factory UnpaidBills.fromJson(Map<String, dynamic> json) => UnpaidBills(
    weight: json["weight"],
    penalty: json["penalty"],
    remaining: json["remaining"],
    details: json["details"] == null ? null : UnpaidBillsDetails.fromJson(json["details"]),
  );

  Map<String, dynamic> toJson() => {
    "weight": weight,
    "penalty": penalty,
    "remaining": remaining,
    "details": details?.toJson(),
  };
}

class UnpaidBillsDetails {
  int? overdueBills;
  int? maxAllowed;

  UnpaidBillsDetails({
    this.overdueBills,
    this.maxAllowed,
  });

  factory UnpaidBillsDetails.fromJson(Map<String, dynamic> json) => UnpaidBillsDetails(
    overdueBills: json["overdue_bills"],
    maxAllowed: json["max_allowed"],
  );

  Map<String, dynamic> toJson() => {
    "overdue_bills": overdueBills,
    "max_allowed": maxAllowed,
  };
}

class Verification {
  int? weight;
  int? penalty;
  int? remaining;
  VerificationDetails? details;

  Verification({
    this.weight,
    this.penalty,
    this.remaining,
    this.details,
  });

  factory Verification.fromJson(Map<String, dynamic> json) => Verification(
    weight: json["weight"],
    penalty: json["penalty"],
    remaining: json["remaining"],
    details: json["details"] == null ? null : VerificationDetails.fromJson(json["details"]),
  );

  Map<String, dynamic> toJson() => {
    "weight": weight,
    "penalty": penalty,
    "remaining": remaining,
    "details": details?.toJson(),
  };
}

class VerificationDetails {
  int? totalVerifications;
  int? pendingVerifications;

  VerificationDetails({
    this.totalVerifications,
    this.pendingVerifications,
  });

  factory VerificationDetails.fromJson(Map<String, dynamic> json) => VerificationDetails(
    totalVerifications: json["total_verifications"],
    pendingVerifications: json["pending_verifications"],
  );

  Map<String, dynamic> toJson() => {
    "total_verifications": totalVerifications,
    "pending_verifications": pendingVerifications,
  };
}

class Violations {
  int? weight;
  int? penalty;
  int? remaining;
  ViolationsDetails? details;

  Violations({
    this.weight,
    this.penalty,
    this.remaining,
    this.details,
  });

  factory Violations.fromJson(Map<String, dynamic> json) => Violations(
    weight: json["weight"],
    penalty: json["penalty"],
    remaining: json["remaining"],
    details: json["details"] == null ? null : ViolationsDetails.fromJson(json["details"]),
  );

  Map<String, dynamic> toJson() => {
    "weight": weight,
    "penalty": penalty,
    "remaining": remaining,
    "details": details?.toJson(),
  };
}

class ViolationsDetails {
  int? activeViolations;
  int? maxAllowed;

  ViolationsDetails({
    this.activeViolations,
    this.maxAllowed,
  });

  factory ViolationsDetails.fromJson(Map<String, dynamic> json) => ViolationsDetails(
    activeViolations: json["active_violations"],
    maxAllowed: json["max_allowed"],
  );

  Map<String, dynamic> toJson() => {
    "active_violations": activeViolations,
    "max_allowed": maxAllowed,
  };
}

class Health {
  dynamic? percentage;
  String? status;
  String? color;

  Health({
    this.percentage,
    this.status,
    this.color,
  });

  factory Health.fromJson(Map<String, dynamic> json) => Health(
    percentage: json["percentage"],
    status: json["status"],
    color: json["color"],
  );

  Map<String, dynamic> toJson() => {
    "percentage": percentage,
    "status": status,
    "color": color,
  };
}

class Tenant {
  int? id;
  String? refNo;
  dynamic name;
  String? profileImage;

  Tenant({
    this.id,
    this.refNo,
    this.name,
    this.profileImage,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) => Tenant(
    id: json["id"],
    refNo: json["ref_no"],
    name: json["name"],
    profileImage: json["profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ref_no": refNo,
    "name": name,
    "profile_image": profileImage,
  };
}

class User {
  int? id;
  String? name;
  String? email;

  User({
    this.id,
    this.name,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
  };
}
