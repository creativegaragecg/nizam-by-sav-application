// To parse this JSON data, do
//
//     final leaseDetailModel = leaseDetailModelFromJson(jsonString);

import 'dart:convert';

LeaseDetailModel leaseDetailModelFromJson(String str) => LeaseDetailModel.fromJson(json.decode(str));

String leaseDetailModelToJson(LeaseDetailModel data) => json.encode(data.toJson());

class LeaseDetailModel {
  bool? success;
  String? message;
  Data? data;

  LeaseDetailModel({
    this.success,
    this.message,
    this.data,
  });

  factory LeaseDetailModel.fromJson(Map<String, dynamic> json) => LeaseDetailModel(
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
  Lease? lease;
  PaymentProfile? paymentProfile;

  Data({
    this.tenant,
    this.lease,
    this.paymentProfile,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    tenant: json["tenant"] == null ? null : Tenant.fromJson(json["tenant"]),
    lease: json["lease"] == null ? null : Lease.fromJson(json["lease"]),
    paymentProfile: json["payment_profile"] == null ? null : PaymentProfile.fromJson(json["payment_profile"]),
  );

  Map<String, dynamic> toJson() => {
    "tenant": tenant?.toJson(),
    "lease": lease?.toJson(),
    "payment_profile": paymentProfile?.toJson(),
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
  dynamic renewalFee;
  dynamic companyId;
  dynamic commission;
  int? companyCommission;
  int? agentId;
  int? agentCommission;
  String? rentBillingCycle;
  ContractType? contractType;
  String? sourceTenancy;
  String? status;
  DateTime? moveInDate;
  DateTime? moveOutDate;
  DateTime? createdAt;
  DateTime? updatedAt;
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
    this.companyId,
    this.commission,
    this.companyCommission,
    this.agentId,
    this.agentCommission,
    this.rentBillingCycle,
    this.contractType,
    this.sourceTenancy,
    this.status,
    this.moveInDate,
    this.moveOutDate,
    this.createdAt,
    this.updatedAt,
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
    companyId: json["company_id"],
    commission: json["commission"],
    companyCommission: json["company_commission"],
    agentId: json["agent_id"],
    agentCommission: json["agent_commission"],
    rentBillingCycle: json["rent_billing_cycle"],
    contractType: json["contract_type"] == null ? null : ContractType.fromJson(json["contract_type"]),
    sourceTenancy: json["source_tenancy"],
    status: json["status"],
    moveInDate: json["move_in_date"] == null ? null : DateTime.parse(json["move_in_date"]),
    moveOutDate: json["move_out_date"] == null ? null : DateTime.parse(json["move_out_date"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
    "company_id": companyId,
    "commission": commission,
    "company_commission": companyCommission,
    "agent_id": agentId,
    "agent_commission": agentCommission,
    "rent_billing_cycle": rentBillingCycle,
    "contract_type": contractType?.toJson(),
    "source_tenancy": sourceTenancy,
    "status": status,
    "move_in_date": "${moveInDate!.year.toString().padLeft(4, '0')}-${moveInDate!.month.toString().padLeft(2, '0')}-${moveInDate!.day.toString().padLeft(2, '0')}",
    "move_out_date": "${moveOutDate!.year.toString().padLeft(4, '0')}-${moveOutDate!.month.toString().padLeft(2, '0')}-${moveOutDate!.day.toString().padLeft(2, '0')}",
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "apartment": apartment?.toJson(),
  };
}

class Apartment {
  int? id;
  String? apartmentNumber;
  int? apartmentId;
  int? floorId;
  int? towerId;
  int? societyId;
  Floors? floors;
  Towers? towers;
  Society? society;

  Apartment({
    this.id,
    this.apartmentNumber,
    this.apartmentId,
    this.floorId,
    this.towerId,
    this.societyId,
    this.floors,
    this.towers,
    this.society,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) => Apartment(
    id: json["id"],
    apartmentNumber: json["apartment_number"],
    apartmentId: json["apartment_id"],
    floorId: json["floor_id"],
    towerId: json["tower_id"],
    societyId: json["society_id"],
    floors: json["floors"] == null ? null : Floors.fromJson(json["floors"]),
    towers: json["towers"] == null ? null : Towers.fromJson(json["towers"]),
    society: json["society"] == null ? null : Society.fromJson(json["society"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "apartment_number": apartmentNumber,
    "apartment_id": apartmentId,
    "floor_id": floorId,
    "tower_id": towerId,
    "society_id": societyId,
    "floors": floors?.toJson(),
    "towers": towers?.toJson(),
    "society": society?.toJson(),
  };
}

class Floors {
  int? id;
  String? floorName;

  Floors({
    this.id,
    this.floorName,
  });

  factory Floors.fromJson(Map<String, dynamic> json) => Floors(
    id: json["id"],
    floorName: json["floor_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "floor_name": floorName,
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

class Towers {
  int? id;
  String? towerName;

  Towers({
    this.id,
    this.towerName,
  });

  factory Towers.fromJson(Map<String, dynamic> json) => Towers(
    id: json["id"],
    towerName: json["tower_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tower_name": towerName,
  };
}

class ContractType {
  int? id;
  String? name;

  ContractType({
    this.id,
    this.name,
  });

  factory ContractType.fromJson(Map<String, dynamic> json) => ContractType(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class PaymentProfile {
  PaymentSummary? paymentSummary;
  PaymentHistory? paymentHistory;

  PaymentProfile({
    this.paymentSummary,
    this.paymentHistory,
  });

  factory PaymentProfile.fromJson(Map<String, dynamic> json) => PaymentProfile(
    paymentSummary: json["payment_summary"] == null ? null : PaymentSummary.fromJson(json["payment_summary"]),
    paymentHistory: json["payment_history"] == null ? null : PaymentHistory.fromJson(json["payment_history"]),
  );

  Map<String, dynamic> toJson() => {
    "payment_summary": paymentSummary?.toJson(),
    "payment_history": paymentHistory?.toJson(),
  };
}

class PaymentHistory {
  List<Rent>? rents;
  List<Rent>? utilities;

  PaymentHistory({
    this.rents,
    this.utilities,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) => PaymentHistory(
    rents: json["rents"] == null ? [] : List<Rent>.from(json["rents"]!.map((x) => Rent.fromJson(x))),
    utilities: json["utilities"] == null ? [] : List<Rent>.from(json["utilities"]!.map((x) => Rent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "rents": rents == null ? [] : List<dynamic>.from(rents!.map((x) => x.toJson())),
    "utilities": utilities == null ? [] : List<dynamic>.from(utilities!.map((x) => x.toJson())),
  };
}

class Rent {
  int? id;
  String? type;
  String? apartmentNumber;
  String? rentFor;
  String? rentAmount;
  String? paidAmount;
  String? status;
  DateTime? billDate;
  DateTime? billDueDate;
  DateTime? paymentDate;
  DateTime? createdAt;
  String? billType;

  Rent({
    this.id,
    this.type,
    this.apartmentNumber,
    this.rentFor,
    this.rentAmount,
    this.paidAmount,
    this.status,
    this.billDate,
    this.billDueDate,
    this.paymentDate,
    this.createdAt,
    this.billType,
  });

  factory Rent.fromJson(Map<String, dynamic> json) => Rent(
    id: json["id"],
    type: json["type"],
    apartmentNumber: json["apartment_number"],
    rentFor: json["rent_for"],
    rentAmount: json["rent_amount"],
    paidAmount: json["paid_amount"],
    status: json["status"],
    billDate: json["bill_date"] == null ? null : DateTime.parse(json["bill_date"]),
    billDueDate: json["bill_due_date"] == null ? null : DateTime.parse(json["bill_due_date"]),
    paymentDate: json["payment_date"] == null ? null : DateTime.parse(json["payment_date"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    billType: json["bill_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "apartment_number": apartmentNumber,
    "rent_for": rentFor,
    "rent_amount": rentAmount,
    "paid_amount": paidAmount,
    "status": status,
    "bill_date": "${billDate!.year.toString().padLeft(4, '0')}-${billDate!.month.toString().padLeft(2, '0')}-${billDate!.day.toString().padLeft(2, '0')}",
    "bill_due_date": "${billDueDate!.year.toString().padLeft(4, '0')}-${billDueDate!.month.toString().padLeft(2, '0')}-${billDueDate!.day.toString().padLeft(2, '0')}",
    "payment_date": "${paymentDate!.year.toString().padLeft(4, '0')}-${paymentDate!.month.toString().padLeft(2, '0')}-${paymentDate!.day.toString().padLeft(2, '0')}",
    "created_at": createdAt?.toIso8601String(),
    "bill_type": billType,
  };
}

class PaymentSummary {
  String? totalAmount;
  String? remainingUnpaid;
  String? totalPaid;
  DateTime? lastPayment;
  String? lastPaymentAmount;
  dynamic nextDueDate;

  PaymentSummary({
    this.totalAmount,
    this.remainingUnpaid,
    this.totalPaid,
    this.lastPayment,
    this.lastPaymentAmount,
    this.nextDueDate,
  });

  factory PaymentSummary.fromJson(Map<String, dynamic> json) => PaymentSummary(
    totalAmount: json["total_amount"],
    remainingUnpaid: json["remaining_unpaid"],
    totalPaid: json["total_paid"],
    lastPayment: json["last_payment"] == null ? null : DateTime.parse(json["last_payment"]),
    lastPaymentAmount: json["last_payment_amount"],
    nextDueDate: json["next_due_date"],
  );

  Map<String, dynamic> toJson() => {
    "total_amount": totalAmount,
    "remaining_unpaid": remainingUnpaid,
    "total_paid": totalPaid,
    "last_payment": "${lastPayment!.year.toString().padLeft(4, '0')}-${lastPayment!.month.toString().padLeft(2, '0')}-${lastPayment!.day.toString().padLeft(2, '0')}",
    "last_payment_amount": lastPaymentAmount,
    "next_due_date": nextDueDate,
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
  List<Document>? documents;
  List<FamilyMember>? familyMembers;

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
    documents: json["documents"] == null ? [] : List<Document>.from(json["documents"]!.map((x) => Document.fromJson(x))),
    familyMembers: json["family_members"] == null ? [] : List<FamilyMember>.from(json["family_members"]!.map((x) => FamilyMember.fromJson(x))),
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
    "documents": documents == null ? [] : List<dynamic>.from(documents!.map((x) => x.toJson())),
    "family_members": familyMembers == null ? [] : List<dynamic>.from(familyMembers!.map((x) => x.toJson())),
  };
}

class Document {
  int? id;
  int? tenantId;
  String? filename;
  String? hashname;

  Document({
    this.id,
    this.tenantId,
    this.filename,
    this.hashname,
  });

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    id: json["id"],
    tenantId: json["tenant_id"],
    filename: json["filename"],
    hashname: json["hashname"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenant_id": tenantId,
    "filename": filename,
    "hashname": hashname,
  };
}

class FamilyMember {
  int? id;
  int? tenantId;
  String? name;
  String? relation;

  FamilyMember({
    this.id,
    this.tenantId,
    this.name,
    this.relation,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) => FamilyMember(
    id: json["id"],
    tenantId: json["tenant_id"],
    name: json["name"],
    relation: json["relation"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenant_id": tenantId,
    "name": name,
    "relation": relation,
  };
}

class User {
  int? id;
  String? name;
  String? email;
  String? profilePhotoUrl;

  User({
    this.id,
    this.name,
    this.email,
    this.profilePhotoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    profilePhotoUrl: json["profile_photo_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "profile_photo_url": profilePhotoUrl,
  };
}
