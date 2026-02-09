// To parse this JSON data, do
//
//     final forumsModel = forumsModelFromJson(jsonString);

import 'dart:convert';

ForumsModel forumsModelFromJson(String str) => ForumsModel.fromJson(json.decode(str));

String forumsModelToJson(ForumsModel data) => json.encode(data.toJson());

class ForumsModel {
  bool? success;
  String? message;
  List<Datum>? data;

  ForumsModel({
    this.success,
    this.message,
    this.data,
  });

  factory ForumsModel.fromJson(Map<String, dynamic> json) => ForumsModel(
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
  String? title;
  String? description;
  String? discussionType;
  String? userSelectionType;
  DateTime? date;
  CreatedBy? createdBy;
  Category? category;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.title,
    this.description,
    this.discussionType,
    this.userSelectionType,
    this.date,
    this.createdBy,
    this.category,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    discussionType: json["discussion_type"],
    userSelectionType: json["user_selection_type"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    createdBy: json["created_by"] == null ? null : CreatedBy.fromJson(json["created_by"]),
    category: json["category"] == null ? null : Category.fromJson(json["category"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "discussion_type": discussionType,
    "user_selection_type": userSelectionType,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "created_by": createdBy?.toJson(),
    "category": category?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Category {
  int? id;
  String? name;
  String? icon;
  String? image;

  Category({
    this.id,
    this.name,
    this.icon,
    this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    icon:json["icon"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": icon,
    "image": image,
  };
}



class CreatedBy {
  int? id;
  String? name;
  String? profileImage;

  CreatedBy({
    this.id,
    this.name,
    this.profileImage,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
    id: json["id"],
    name: json["name"],
    profileImage: json["profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "profile_image": profileImage,
  };
}



