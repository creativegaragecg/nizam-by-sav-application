// To parse this JSON data, do
//
//     final webSosModel = webSosModelFromJson(jsonString);

import 'dart:convert';

WebSosModel webSosModelFromJson(String str) => WebSosModel.fromJson(json.decode(str));

String webSosModelToJson(WebSosModel data) => json.encode(data.toJson());

class WebSosModel {
  bool? success;
  String? message;
  int? totalDevices;
  List<Datum>? data;

  WebSosModel({
    this.success,
    this.message,
    this.totalDevices,
    this.data,
  });

  factory WebSosModel.fromJson(Map<String, dynamic> json) => WebSosModel(
    success: json["success"],
    message: json["message"],
    totalDevices: json["total_devices"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "total_devices": totalDevices,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? sosId;
  int? societyId;
  DateTime? createdAt;
  List<NotificationElement>? notifications;

  Datum({
    this.sosId,
    this.societyId,
    this.createdAt,
    this.notifications,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    sosId: json["sos_id"],
    societyId: json["society_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    notifications: json["notifications"] == null ? [] : List<NotificationElement>.from(json["notifications"]!.map((x) => NotificationElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sos_id": sosId,
    "society_id": societyId,
    "created_at": createdAt?.toIso8601String(),
    "notifications": notifications == null ? [] : List<dynamic>.from(notifications!.map((x) => x.toJson())),
  };
}

class NotificationElement {
  String? to;
  NotificationNotification? notification;
  Data? data;
  Android? android;

  NotificationElement({
    this.to,
    this.notification,
    this.data,
    this.android,
  });

  factory NotificationElement.fromJson(Map<String, dynamic> json) => NotificationElement(
    to: json["to"],
    notification: json["notification"] == null ? null : NotificationNotification.fromJson(json["notification"]),
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    android: json["android"] == null ? null : Android.fromJson(json["android"]),
  );

  Map<String, dynamic> toJson() => {
    "to": to,
    "notification": notification?.toJson(),
    "data": data?.toJson(),
    "android": android?.toJson(),
  };
}

class Android {
  String? priority;
  AndroidNotification? notification;

  Android({
    this.priority,
    this.notification,
  });

  factory Android.fromJson(Map<String, dynamic> json) => Android(
    priority: json["priority"],
    notification: json["notification"] == null ? null : AndroidNotification.fromJson(json["notification"]),
  );

  Map<String, dynamic> toJson() => {
    "priority": priority,
    "notification": notification?.toJson(),
  };
}

class AndroidNotification {
  String? channelId;
  String? sound;

  AndroidNotification({
    this.channelId,
    this.sound,
  });

  factory AndroidNotification.fromJson(Map<String, dynamic> json) => AndroidNotification(
    channelId: json["channel_id"],
    sound: json["sound"],
  );

  Map<String, dynamic> toJson() => {
    "channel_id": channelId,
    "sound": sound,
  };
}

class Data {
  String? type;
  String? sosId;
  String? reason;
  String? societyName;
  String? triggeredBy;
  String? status;

  Data({
    this.type,
    this.sosId,
    this.reason,
    this.societyName,
    this.triggeredBy,
    this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    type: json["type"],
    sosId: json["sos_id"],
    reason: json["reason"],
    societyName: json["society_name"],
    triggeredBy: json["triggered_by"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "sos_id": sosId,
    "reason": reason,
    "society_name": societyName,
    "triggered_by": triggeredBy,
    "status": status,
  };
}

class NotificationNotification {
  String? title;
  String? body;

  NotificationNotification({
    this.title,
    this.body,
  });

  factory NotificationNotification.fromJson(Map<String, dynamic> json) => NotificationNotification(
    title: json["title"],
    body: json["body"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "body": body,
  };
}
