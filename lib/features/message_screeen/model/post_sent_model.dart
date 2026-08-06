import 'dart:convert';

class PostSentMessageModel {
  bool? status;
  String? message;
  int? code;
  Data? data;

  PostSentMessageModel({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  PostSentMessageModel copyWith({
    bool? status,
    String? message,
    int? code,
    Data? data,
  }) =>
      PostSentMessageModel(
        status: status ?? this.status,
        message: message ?? this.message,
        code: code ?? this.code,
        data: data ?? this.data,
      );

  factory PostSentMessageModel.fromRawJson(String str) => PostSentMessageModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostSentMessageModel.fromJson(Map<String, dynamic> json) => PostSentMessageModel(
    status: json["status"],
    message: json["message"],
    code: json["code"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "code": code,
    "data": data?.toJson(),
  };
}

class Data {
  int? id;
  int? conversationId;
  int? senderId;
  String? senderName;
  String? message;
  String? attachment;
  bool? isRead;
  DateTime? createdAt;
  String? timeAgo;

  Data({
    this.id,
    this.conversationId,
    this.senderId,
    this.senderName,
    this.message,
    this.attachment,
    this.isRead,
    this.createdAt,
    this.timeAgo,
  });

  Data copyWith({
    int? id,
    int? conversationId,
    int? senderId,
    String? senderName,
    String? message,
    String? attachment,
    bool? isRead,
    DateTime? createdAt,
    String? timeAgo,
  }) =>
      Data(
        id: id ?? this.id,
        conversationId: conversationId ?? this.conversationId,
        senderId: senderId ?? this.senderId,
        senderName: senderName ?? this.senderName,
        message: message ?? this.message,
        attachment: attachment ?? this.attachment,
        isRead: isRead ?? this.isRead,
        createdAt: createdAt ?? this.createdAt,
        timeAgo: timeAgo ?? this.timeAgo,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    conversationId: json["conversation_id"],
    senderId: json["sender_id"],
    senderName: json["sender_name"],
    message: json["message"],
    attachment: json["attachment"],
    isRead: json["is_read"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    timeAgo: json["time_ago"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "conversation_id": conversationId,
    "sender_id": senderId,
    "sender_name": senderName,
    "message": message,
    "attachment": attachment,
    "is_read": isRead,
    "created_at": createdAt?.toIso8601String(),
    "time_ago": timeAgo,
  };
}
