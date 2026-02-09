// To parse this JSON data, do
//
//     final forumsCategoriesModel = forumsCategoriesModelFromJson(jsonString);

import 'dart:convert';

ForumsCategoriesModel forumsCategoriesModelFromJson(String str) => ForumsCategoriesModel.fromJson(json.decode(str));

String forumsCategoriesModelToJson(ForumsCategoriesModel data) => json.encode(data.toJson());

class ForumsCategoriesModel {
  bool? success;
  String? message;
  List<Datum>? data;

  ForumsCategoriesModel({
    this.success,
    this.message,
    this.data,
  });

  factory ForumsCategoriesModel.fromJson(Map<String, dynamic> json) => ForumsCategoriesModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  int? societyId;
  String? name;
  String? icon;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.societyId,
    this.name,
    this.icon,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    societyId: json["society_id"],
    name: json["name"],
    icon: json["icon"],
    image: json["image"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "society_id": societyId,
    "name": name,
    "icon": icon,
    "image": image,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
