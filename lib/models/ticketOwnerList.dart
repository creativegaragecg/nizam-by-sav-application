// To parse this JSON data, do
//
//     final ticketOwnerModel = ticketOwnerModelFromJson(jsonString);

import 'dart:convert';

TicketOwnerModel ticketOwnerModelFromJson(String str) => TicketOwnerModel.fromJson(json.decode(str));

String ticketOwnerModelToJson(TicketOwnerModel data) => json.encode(data.toJson());

class TicketOwnerModel {
  bool? success;
  String? message;
  Data? data;

  TicketOwnerModel({
    this.success,
    this.message,
    this.data,
  });

  factory TicketOwnerModel.fromJson(Map<String, dynamic> json) => TicketOwnerModel(
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
  List<Owner>? owners;

  Data({
    this.owners,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    owners: json["owners"] == null ? [] : List<Owner>.from(json["owners"]!.map((x) => Owner.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "owners": owners == null ? [] : List<dynamic>.from(owners!.map((x) => x.toJson())),
  };
}

class Owner {
  int? id;
  int? societyId;
  String? refNo;
  int? apartmentId;
  int? userId;
  DateTime? contractDate;
  int? contractType;
  dynamic price;
  int? totalPrice;
  int? netPrice;
  String? paymentType;
  int? status;
  int? isApproved;
  User? user;

  Owner({
    this.id,
    this.societyId,
    this.refNo,
    this.apartmentId,
    this.userId,
    this.contractDate,
    this.contractType,
    this.price,
    this.totalPrice,
    this.netPrice,
    this.paymentType,
    this.status,
    this.isApproved,
    this.user,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
    id: json["id"],
    societyId: json["society_id"],
    refNo: json["ref_no"],
    apartmentId: json["apartment_id"],
    userId: json["user_id"],
    contractDate: json["contract_date"] == null ? null : DateTime.parse(json["contract_date"]),
    contractType: json["contract_type"],
    price: json["price"],
    totalPrice: json["total_price"],
    netPrice: json["net_price"],
    paymentType: json["payment_type"],
    status: json["status"],
    isApproved: json["is_approved"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "society_id": societyId,
    "ref_no": refNo,
    "apartment_id": apartmentId,
    "user_id": userId,
    "contract_date": "${contractDate!.year.toString().padLeft(4, '0')}-${contractDate!.month.toString().padLeft(2, '0')}-${contractDate!.day.toString().padLeft(2, '0')}",
    "contract_type": contractType,
    "price": price,
    "total_price": totalPrice,
    "net_price": netPrice,
    "payment_type": paymentType,
    "status": status,
    "is_approved": isApproved,
    "user": user?.toJson(),
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
