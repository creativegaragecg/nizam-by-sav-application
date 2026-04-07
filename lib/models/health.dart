// To parse this JSON data, do
//
//     final healthModel = healthModelFromJson(jsonString);

import 'dart:convert';

HealthModel healthModelFromJson(String str) => HealthModel.fromJson(json.decode(str));

String healthModelToJson(HealthModel data) => json.encode(data.toJson());

class HealthModel {
  Health? health;
  Breakdown? breakdown;
  dynamic? totalTenants;

  HealthModel({
    this.health,
    this.breakdown,
    this.totalTenants,
  });

  factory HealthModel.fromJson(Map<String, dynamic> json) => HealthModel(
    health: json["health"] == null ? null : Health.fromJson(json["health"]),

    // ✅ Fix: check if breakdown is a Map before parsing, ignore if it's a List/empty
    breakdown: (json["breakdown"] == null || json["breakdown"] is List)
        ? null
        : Breakdown.fromJson(json["breakdown"]),

    totalTenants: json["total_tenants"],
  );

  Map<String, dynamic> toJson() => {
    "health": health?.toJson(),
    "breakdown": breakdown?.toJson(),
    "total_tenants": totalTenants,
  };
}

class Breakdown {
  LegalNotices? violations;
  LegalNotices? serviceSuspensions;
  LegalNotices? tickets;
  LegalNotices? legalNotices;
  LegalNotices? unpaidBills;
  LegalNotices? verification;

  Breakdown({
    this.violations,
    this.serviceSuspensions,
    this.tickets,
    this.legalNotices,
    this.unpaidBills,
    this.verification,
  });

  factory Breakdown.fromJson(Map<String, dynamic> json) => Breakdown(
    violations: json["violations"] == null ? null : LegalNotices.fromJson(json["violations"]),
    serviceSuspensions: json["service_suspensions"] == null ? null : LegalNotices.fromJson(json["service_suspensions"]),
    tickets: json["tickets"] == null ? null : LegalNotices.fromJson(json["tickets"]),
    legalNotices: json["legal_notices"] == null ? null : LegalNotices.fromJson(json["legal_notices"]),
    unpaidBills: json["unpaid_bills"] == null ? null : LegalNotices.fromJson(json["unpaid_bills"]),
    verification: json["verification"] == null ? null : LegalNotices.fromJson(json["verification"]),
  );

  Map<String, dynamic> toJson() => {
    "violations": violations?.toJson(),
    "service_suspensions": serviceSuspensions?.toJson(),
    "tickets": tickets?.toJson(),
    "legal_notices": legalNotices?.toJson(),
    "unpaid_bills": unpaidBills?.toJson(),
    "verification": verification?.toJson(),
  };
}

class LegalNotices {
  String? label;
  double? weight;
  dynamic? maxCountPerTenant;
  dynamic? maxCountTotal;
  dynamic? count;
  double? penalty;
  double? remaining;

  LegalNotices({
    this.label,
    this.weight,
    this.maxCountPerTenant,
    this.maxCountTotal,
    this.count,
    this.penalty,
    this.remaining,
  });

  factory LegalNotices.fromJson(Map<String, dynamic> json) => LegalNotices(
    label: json["label"],
    weight: json["weight"]?.toDouble(),
    maxCountPerTenant: json["max_count_per_tenant"],
    maxCountTotal: json["max_count_total"],
    count: json["count"],
    penalty: json["penalty"]?.toDouble(),
    remaining: json["remaining"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "weight": weight,
    "max_count_per_tenant": maxCountPerTenant,
    "max_count_total": maxCountTotal,
    "count": count,
    "penalty": penalty,
    "remaining": remaining,
  };
}

class Health {
  dynamic? percentage;
  String? status;
  String? color;
  String? period;

  Health({
    this.percentage,
    this.status,
    this.color,
    this.period,
  });

  factory Health.fromJson(Map<String, dynamic> json) => Health(
    percentage: json["percentage"],
    status: json["status"],
    color: json["color"],
    period: json["period"],
  );

  Map<String, dynamic> toJson() => {
    "percentage": percentage,
    "status": status,
    "color": color,
    "period": period,
  };
}
