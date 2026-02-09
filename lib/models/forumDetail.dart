// To parse this JSON data, do
//
//     final forumDetailModel = forumDetailModelFromJson(jsonString);

import 'dart:convert';

ForumDetailModel forumDetailModelFromJson(String str) => ForumDetailModel.fromJson(json.decode(str));

String forumDetailModelToJson(ForumDetailModel data) => json.encode(data.toJson());

class ForumDetailModel {
  bool? success;
  String? message;
  Data? data;

  ForumDetailModel({
    this.success,
    this.message,
    this.data,
  });

  factory ForumDetailModel.fromJson(Map<String, dynamic> json) => ForumDetailModel(
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
  int? id;
  String? title;
  dynamic description;
  String? discussionType;
  String? userSelectionType;
  DateTime? date;
  CreatedBy? createdBy;
  Category? category;
  List<FileElement>? files;
  List<dynamic>? users;
  int? likesCount;
  bool? likedByMe;
  List<Reply>? replies;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
    this.id,
    this.title,
    this.description,
    this.discussionType,
    this.userSelectionType,
    this.date,
    this.createdBy,
    this.category,
    this.files,
    this.users,
    this.likesCount,
    this.likedByMe,
    this.replies,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    discussionType: json["discussion_type"],
    userSelectionType: json["user_selection_type"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    createdBy: json["created_by"] == null ? null : CreatedBy.fromJson(json["created_by"]),
    category: json["category"] == null ? null : Category.fromJson(json["category"]),
    files: json["files"] == null ? [] : List<FileElement>.from(json["files"]!.map((x) => FileElement.fromJson(x))),
    users: json["users"] == null ? [] : List<dynamic>.from(json["users"]!.map((x) => x)),
    likesCount: json["likes_count"],
    likedByMe: json["liked_by_me"],
    replies: json["replies"] == null ? [] : List<Reply>.from(json["replies"]!.map((x) => Reply.fromJson(x))),
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
    "files": files == null ? [] : List<dynamic>.from(files!.map((x) => x.toJson())),
    "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x)),
    "likes_count": likesCount,
    "liked_by_me": likedByMe,
    "replies": replies == null ? [] : List<dynamic>.from(replies!.map((x) => x.toJson())),
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
    icon: json["icon"],
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

class FileElement {
  int? id;
  String? file;

  FileElement({
    this.id,
    this.file,
  });

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
    id: json["id"],
    file: json["file"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "file": file,
  };
}

class Reply {
  int? id;
  String? reply;
  CreatedBy? user;
  List<Reply>? childReply;
  DateTime? createdAt;

  Reply({
    this.id,
    this.reply,
    this.user,
    this.childReply,
    this.createdAt,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
    id: json["id"],
    reply: json["reply"],
    user: json["user"] == null ? null : CreatedBy.fromJson(json["user"]),
    childReply: json["child_reply"] == null ? [] : List<Reply>.from(json["child_reply"]!.map((x) => Reply.fromJson(x))),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reply": reply,
    "user": user?.toJson(),
    "child_reply": childReply == null ? [] : List<dynamic>.from(childReply!.map((x) => x.toJson())),
    "created_at": createdAt?.toIso8601String(),
  };
}
