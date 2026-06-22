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
  String? priority;
  NotificationNotification? notification;
  Android? android;
  Data? data;

  NotificationElement({
    this.to,
    this.priority,
    this.notification,
    this.android,
    this.data,
  });

  factory NotificationElement.fromJson(Map<String, dynamic> json) => NotificationElement(
    to: json["to"],
    priority: json["priority"],
    notification: json["notification"] == null ? null : NotificationNotification.fromJson(json["notification"]),
    android: json["android"] == null ? null : Android.fromJson(json["android"]),
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "to": to,
    "priority": priority,
    "notification": notification?.toJson(),
    "android": android?.toJson(),
    "data": data?.toJson(),
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
  bool? fullScreenIntent;

  AndroidNotification({
    this.channelId,
    this.fullScreenIntent,
  });

  factory AndroidNotification.fromJson(Map<String, dynamic> json) => AndroidNotification(
    channelId:json["channel_id"],
    fullScreenIntent: json["full_screen_intent"],
  );

  Map<String, dynamic> toJson() => {
    "channel_id": channelId,
    "full_screen_intent": fullScreenIntent,
  };
}







class Data {
  String? type;
  String? sosId;
  String? societyName;
  String? status;
  String? clickAction;

  Data({
    this.type,
    this.sosId,
    this.societyName,
    this.status,
    this.clickAction,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    type: json["type"],
    sosId: json["sos_id"],
    societyName: json["society_name"],
    status: json["status"],
    clickAction: json["click_action"],
  );

  Map<String, dynamic> toJson() => {
    "type":type,
    "sos_id": sosId,
    "society_name": societyName,
    "status": status,
    "click_action": clickAction,
  };
}








class NotificationNotification {
  String? title;
  String? body;
  String? androidChannelId;
  String? sound;

  NotificationNotification({
    this.title,
    this.body,
    this.androidChannelId,
    this.sound,
  });

  factory NotificationNotification.fromJson(Map<String, dynamic> json) => NotificationNotification(
    title: json["title"],
    body: json["body"],
    androidChannelId: json["android_channel_id"],
    sound: json["sound"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "body": body,
    "android_channel_id": androidChannelId,
    "sound": sound,
  };
}
