// To parse this JSON data, do
//
//     final noticeBoardModel = noticeBoardModelFromJson(jsonString);

import 'dart:convert';

NoticeBoardModel noticeBoardModelFromJson(String str) => NoticeBoardModel.fromJson(json.decode(str));

String noticeBoardModelToJson(NoticeBoardModel data) => json.encode(data.toJson());

class NoticeBoardModel {
  bool? success;
  String? message;
  Data? data;

  NoticeBoardModel({
    this.success,
    this.message,
    this.data,
  });

  factory NoticeBoardModel.fromJson(Map<String, dynamic> json) => NoticeBoardModel(
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
  List<Notice>? notices;

  Data({
    this.notices,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    notices: json["notices"] == null ? [] : List<Notice>.from(json["notices"]!.map((x) => Notice.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "notices": notices == null ? [] : List<dynamic>.from(notices!.map((x) => x.toJson())),
  };
}

class Notice {
  int? id;
  String? title;
  String? description;
  DateTime? createdAt;
  String? imageUrl;

  Notice({
    this.id,
    this.title,
    this.description,
    this.createdAt,
    this.imageUrl,
  });

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "created_at": createdAt?.toIso8601String(),
    "image_url": imageUrl,
  };
}
