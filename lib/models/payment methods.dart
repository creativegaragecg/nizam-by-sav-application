
import 'dart:convert';

PaymentMethodsModel paymentMethodsModelFromJson(String str) => PaymentMethodsModel.fromJson(json.decode(str));

String paymentMethodsModelToJson(PaymentMethodsModel data) => json.encode(data.toJson());

class PaymentMethodsModel {
  bool? success;
  Data? data;

  PaymentMethodsModel({
    this.success,
    this.data,
  });

  factory PaymentMethodsModel.fromJson(Map<String, dynamic> json) => PaymentMethodsModel(
    success: json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
  };
}

class Data {
  int? rentId;
  String? amount;
  String? currency;
  String? currencySymbol;
  RentDetails? rentDetails;
  List<PaymentMethod>? paymentMethods;

  Data({
    this.rentId,
    this.amount,
    this.currency,
    this.currencySymbol,
    this.rentDetails,
    this.paymentMethods,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    rentId: json["rent_id"],
    amount: json["amount"],
    currency: json["currency"],
    currencySymbol: json["currency_symbol"],
    rentDetails: json["rent_details"] == null ? null : RentDetails.fromJson(json["rent_details"]),
    paymentMethods: json["payment_methods"] == null ? [] : List<PaymentMethod>.from(json["payment_methods"]!.map((x) => PaymentMethod.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "rent_id": rentId,
    "amount": amount,
    "currency": currency,
    "currency_symbol": currencySymbol,
    "rent_details": rentDetails?.toJson(),
    "payment_methods": paymentMethods == null ? [] : List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
  };
}

class PaymentMethod {
  String? id;
  String? name;
  String? type;
  String? iconUrl;
  int? offlineMethodId;
  String? description;

  PaymentMethod({
    this.id,
    this.name,
    this.type,
    this.iconUrl,
    this.offlineMethodId,
    this.description,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    id: json["id"],
    name: json["name"],
    type: json["type"],
    iconUrl: json["icon_url"],
    offlineMethodId: json["offline_method_id"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "icon_url": iconUrl,
    "offline_method_id": offlineMethodId,
    "description": description,
  };
}

class RentDetails {
  String? forMonth;
  dynamic forYear;
  String? tenantName;
  String? apartment;

  RentDetails({
    this.forMonth,
    this.forYear,
    this.tenantName,
    this.apartment,
  });

  factory RentDetails.fromJson(Map<String, dynamic> json) => RentDetails(
    forMonth: json["for_month"],
    forYear: json["for_year"],
    tenantName: json["tenant_name"],
    apartment: json["apartment"],
  );

  Map<String, dynamic> toJson() => {
    "for_month": forMonth,
    "for_year": forYear,
    "tenant_name": tenantName,
    "apartment": apartment,
  };
}
