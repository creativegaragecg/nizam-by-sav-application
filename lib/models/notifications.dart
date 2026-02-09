// To parse this JSON data, do
//
//     final notificationsModel = notificationsModelFromJson(jsonString);

import 'dart:convert';

NotificationsModel notificationsModelFromJson(String str) => NotificationsModel.fromJson(json.decode(str));

String notificationsModelToJson(NotificationsModel data) => json.encode(data.toJson());

class NotificationsModel {
  bool? success;
  NotificationsModelData? data;

  NotificationsModel({
    this.success,
    this.data,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) => NotificationsModel(
    success: json["success"],
    data: json["data"] == null ? null : NotificationsModelData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
  };
}

class NotificationsModelData {
  List<ReadNotification>? unreadNotifications;
  List<ReadNotification>? readNotifications;

  NotificationsModelData({
    this.unreadNotifications,
    this.readNotifications,
  });

  factory NotificationsModelData.fromJson(Map<String, dynamic> json) => NotificationsModelData(
    unreadNotifications: json["unread_notifications"] == null ? [] : List<ReadNotification>.from(json["unread_notifications"]!.map((x) => ReadNotification.fromJson(x))),
    readNotifications: json["read_notifications"] == null ? [] : List<ReadNotification>.from(json["read_notifications"]!.map((x) => ReadNotification.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "unread_notifications": unreadNotifications == null ? [] : List<dynamic>.from(unreadNotifications!.map((x) => x.toJson())),
    "read_notifications": readNotifications == null ? [] : List<dynamic>.from(readNotifications!.map((x) => x.toJson())),
  };
}

class ReadNotification {
  String? id;
  int? societyId;
  String? type;
  String? notifiableType;
  int? notifiableId;
  ReadNotificationData? data;
  DateTime? readAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  ReadNotification({
    this.id,
    this.societyId,
    this.type,
    this.notifiableType,
    this.notifiableId,
    this.data,
    this.readAt,
    this.createdAt,
    this.updatedAt,
  });

  factory ReadNotification.fromJson(Map<String, dynamic> json) => ReadNotification(
    id: json["id"],
    societyId: json["society_id"],
    type: json["type"],
    notifiableType: json["notifiable_type"],
    notifiableId: json["notifiable_id"],
    data: json["data"] == null ? null : ReadNotificationData.fromJson(json["data"]),
    readAt: json["read_at"] == null ? null : DateTime.parse(json["read_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "society_id": societyId,
    "type": type,
    "notifiable_type": notifiableType,
    "notifiable_id": notifiableId,
    "data": data?.toJson(),
    "read_at": readAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class ReadNotificationData {
  int? societyId;
  String? message;
  String? url;
  DateTime? createdAt;
  String? userName;
  String? tenantName;

  ReadNotificationData({
    this.societyId,
    this.message,
    this.url,
    this.createdAt,
    this.userName,
    this.tenantName,
  });

  factory ReadNotificationData.fromJson(Map<String, dynamic> json) => ReadNotificationData(
    societyId: json["society_id"],
    message: json["message"],
    url: json["url"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    userName: json["user_name"],
    tenantName: json["tenant_name"],
  );

  Map<String, dynamic> toJson() => {
    "society_id": societyId,
    "message": message,
    "url": url,
    "created_at": createdAt?.toIso8601String(),
    "user_name": userName,
    "tenant_name": tenantName,
  };
}
