// To parse this JSON data, do
//
//     final ticketDetails = ticketDetailsFromJson(jsonString);

import 'dart:convert';

TicketDetails ticketDetailsFromJson(String str) => TicketDetails.fromJson(json.decode(str));

String ticketDetailsToJson(TicketDetails data) => json.encode(data.toJson());

class TicketDetails {
  bool? success;
  String? message;
  Data? data;

  TicketDetails({
    this.success,
    this.message,
    this.data,
  });

  factory TicketDetails.fromJson(Map<String, dynamic> json) => TicketDetails(
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
  String? partyType;
  Ticket? ticket;

  Data({
    this.partyType,
    this.ticket,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    partyType: json["party_type"],
    ticket: json["ticket"] == null ? null : Ticket.fromJson(json["ticket"]),
  );

  Map<String, dynamic> toJson() => {
    "party_type": partyType,
    "ticket": ticket?.toJson(),
  };
}

class Ticket {
  int? id;
  int? societyId;
  int? ticketNumber;
  int? partyId;
  String? partyType;
  int? typeId;
  String? status;
  int? agentId;
  String? subject;
  List<Reply>? reply;
  dynamic resolvedTime;
  DateTime? createdAt;
  DateTime? updatedAt;
  TicketType? ticketType;
  Agent? agent;

  Ticket({
    this.id,
    this.societyId,
    this.ticketNumber,
    this.partyId,
    this.partyType,
    this.typeId,
    this.status,
    this.agentId,
    this.subject,
    this.reply,
    this.resolvedTime,
    this.createdAt,
    this.updatedAt,
    this.ticketType,
    this.agent,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
    id: json["id"],
    societyId: json["society_id"],
    ticketNumber: json["ticket_number"],
    partyId: json["party_id"],
    partyType: json["party_type"],
    typeId: json["type_id"],
    status: json["status"],
    agentId: json["agent_id"],
    subject: json["subject"],
    reply: json["reply"] == null ? [] : List<Reply>.from(json["reply"]!.map((x) => Reply.fromJson(x))),
    resolvedTime: json["resolved_time"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    ticketType: json["ticket_type"] == null ? null : TicketType.fromJson(json["ticket_type"]),
    agent: json["agent"] == null ? null : Agent.fromJson(json["agent"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "society_id": societyId,
    "ticket_number": ticketNumber,
    "party_id": partyId,
    "party_type": partyType,
    "type_id": typeId,
    "status": status,
    "agent_id": agentId,
    "subject": subject,
    "reply": reply == null ? [] : List<dynamic>.from(reply!.map((x) => x.toJson())),
    "resolved_time": resolvedTime,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "ticket_type": ticketType?.toJson(),
    "agent": agent?.toJson(),
  };
}

class Agent {
  int? id;
  String? name;
  int? societyId;
  String? email;
  String? phoneNumber;
  int? roleId;
  int? owner;
  int? tenant;
  String? status;
  dynamic emailVerifiedAt;
  dynamic twoFactorConfirmedAt;
  int? emailNotifications;
  int? pushNotifications;
  int? smsNotifications;
  int? weeklyDigest;
  dynamic currentTeamId;
  String? profilePhotoPath;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? locale;
  dynamic stripeId;
  dynamic pmType;
  dynamic pmLastFour;
  dynamic trialEndsAt;
  int? countryPhonecode;
  String? profilePhotoUrl;

  Agent({
    this.id,
    this.name,
    this.societyId,
    this.email,
    this.phoneNumber,
    this.roleId,
    this.owner,
    this.tenant,
    this.status,
    this.emailVerifiedAt,
    this.twoFactorConfirmedAt,
    this.emailNotifications,
    this.pushNotifications,
    this.smsNotifications,
    this.weeklyDigest,
    this.currentTeamId,
    this.profilePhotoPath,
    this.createdAt,
    this.updatedAt,
    this.locale,
    this.stripeId,
    this.pmType,
    this.pmLastFour,
    this.trialEndsAt,
    this.countryPhonecode,
    this.profilePhotoUrl,
  });

  factory Agent.fromJson(Map<String, dynamic> json) => Agent(
    id: json["id"],
    name: json["name"],
    societyId: json["society_id"],
    email: json["email"],
    phoneNumber: json["phone_number"],
    roleId: json["role_id"],
    owner: json["owner"],
    tenant: json["tenant"],
    status: json["status"],
    emailVerifiedAt: json["email_verified_at"],
    twoFactorConfirmedAt: json["two_factor_confirmed_at"],
    emailNotifications: json["email_notifications"],
    pushNotifications: json["push_notifications"],
    smsNotifications: json["sms_notifications"],
    weeklyDigest: json["weekly_digest"],
    currentTeamId: json["current_team_id"],
    profilePhotoPath: json["profile_photo_path"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    locale: json["locale"],
    stripeId: json["stripe_id"],
    pmType: json["pm_type"],
    pmLastFour: json["pm_last_four"],
    trialEndsAt: json["trial_ends_at"],
    countryPhonecode: json["country_phonecode"],
    profilePhotoUrl: json["profile_photo_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "society_id": societyId,
    "email": email,
    "phone_number": phoneNumber,
    "role_id": roleId,
    "owner": owner,
    "tenant": tenant,
    "status": status,
    "email_verified_at": emailVerifiedAt,
    "two_factor_confirmed_at": twoFactorConfirmedAt,
    "email_notifications": emailNotifications,
    "push_notifications": pushNotifications,
    "sms_notifications": smsNotifications,
    "weekly_digest": weeklyDigest,
    "current_team_id": currentTeamId,
    "profile_photo_path": profilePhotoPath,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "locale": locale,
    "stripe_id": stripeId,
    "pm_type": pmType,
    "pm_last_four": pmLastFour,
    "trial_ends_at": trialEndsAt,
    "country_phonecode": countryPhonecode,
    "profile_photo_url": profilePhotoUrl,
  };
}

class Reply {
  int? id;
  int? ticketId;
  int? userId;
  dynamic parentId;
  String? message;
  DateTime? createdAt;
  DateTime? updatedAt;
  Agent? user;
  List<dynamic>? files;

  Reply({
    this.id,
    this.ticketId,
    this.userId,
    this.parentId,
    this.message,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.files,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
    id: json["id"],
    ticketId: json["ticket_id"],
    userId: json["user_id"],
    parentId: json["parent_id"],
    message: json["message"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    user: json["user"] == null ? null : Agent.fromJson(json["user"]),
    files: json["files"] == null ? [] : List<dynamic>.from(json["files"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ticket_id": ticketId,
    "user_id": userId,
    "parent_id": parentId,
    "message": message,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "user": user?.toJson(),
    "files": files == null ? [] : List<dynamic>.from(files!.map((x) => x)),
  };
}

class TicketType {
  int? id;
  int? societyId;
  String? typeName;
  String? resolvedTime;
  DateTime? createdAt;
  DateTime? updatedAt;

  TicketType({
    this.id,
    this.societyId,
    this.typeName,
    this.resolvedTime,
    this.createdAt,
    this.updatedAt,
  });

  factory TicketType.fromJson(Map<String, dynamic> json) => TicketType(
    id: json["id"],
    societyId: json["society_id"],
    typeName: json["type_name"],
    resolvedTime: json["resolved_time"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "society_id": societyId,
    "type_name": typeName,
    "resolved_time": resolvedTime,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
