
import 'dart:convert';

BillsModel billsModelFromJson(String str) => BillsModel.fromJson(json.decode(str));

String billsModelToJson(BillsModel data) => json.encode(data.toJson());

class BillsModel {
  bool? success;
  String? message;
  Data? data;

  BillsModel({
    this.success,
    this.message,
    this.data,
  });

  factory BillsModel.fromJson(Map<String, dynamic> json) => BillsModel(
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
  List<Bill>? bills;

  Data({
    this.bills,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    bills: json["bills"] == null ? [] : List<Bill>.from(json["bills"]!.map((x) => Bill.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "bills": bills == null ? [] : List<dynamic>.from(bills!.map((x) => x.toJson())),
  };
}

class Bill {
  int? id;
  int? societyId;
  int? apartmentId;
  int? tenantId;
  String? forYear;
  String? forMonth;
  String? dueAmount;
  String? advanceAmount;
  String? status;
  dynamic paymentDate;
  String? tax;
  String? postStatus;
  int? billTypeId;
  DateTime? billDate;
  DateTime? billDueDate;
  String? paidAmount;
  String? type;
  int? financialStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  Bill({
    this.id,
    this.societyId,
    this.apartmentId,
    this.tenantId,
    this.forYear,
    this.forMonth,
    this.dueAmount,
    this.advanceAmount,
    this.status,
    this.paymentDate,
    this.tax,
    this.postStatus,
    this.billTypeId,
    this.billDate,
    this.billDueDate,
    this.paidAmount,
    this.type,
    this.financialStatus,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Bill.fromJson(Map<String, dynamic> json) => Bill(
    id: json["id"],
    societyId: json["society_id"],
    apartmentId: json["apartment_id"],
    tenantId: json["tenant_id"],
    forYear: json["for_year"],
    forMonth: json["for_month"],
    dueAmount: json["due_amount"],
    advanceAmount: json["advance_amount"],
    status: json["status"],
    paymentDate: json["payment_date"],
    tax: json["tax"],
    postStatus: json["post_status"],
    billTypeId: json["bill_type_id"],
    billDate: json["bill_date"] == null ? null : DateTime.parse(json["bill_date"]),
    billDueDate: json["bill_due_date"] == null ? null : DateTime.parse(json["bill_due_date"]),
    paidAmount: json["paid_amount"],
    type: json["type"],
    financialStatus: json["financial_status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "society_id": societyId,
    "apartment_id": apartmentId,
    "tenant_id": tenantId,
    "for_year": forYear,
    "for_month": forMonth,
    "due_amount": dueAmount,
    "advance_amount": advanceAmount,
    "status": status,
    "payment_date": paymentDate,
    "tax": tax,
    "post_status": postStatus,
    "bill_type_id": billTypeId,
    "bill_date": billDate?.toIso8601String(),
    "bill_due_date": billDueDate?.toIso8601String(),
    "paid_amount": paidAmount,
    "type":type,
    "financial_status": financialStatus,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}





