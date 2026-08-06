import 'dart:convert';

class GetAllMessageResponseModel {
  final bool? status;
  final String? message;
  final int? code;
  final List<MessageData>? data;

  GetAllMessageResponseModel({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  factory GetAllMessageResponseModel.fromRawJson(String str) =>
      GetAllMessageResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllMessageResponseModel.fromJson(Map<String, dynamic> json) {
    return GetAllMessageResponseModel(
      status: json["status"],
      message: json["message"],
      code: json["code"],
      data: json["data"] == null
          ? []
          : List<MessageData>.from(
        json["data"].map(
              (x) => MessageData.fromJson(x),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "code": code,
      "data": data == null
          ? []
          : List<dynamic>.from(
        data!.map((x) => x.toJson()),
      ),
    };
  }

  GetAllMessageResponseModel copyWith({
    bool? status,
    String? message,
    int? code,
    List<MessageData>? data,
  }) {
    return GetAllMessageResponseModel(
      status: status ?? this.status,
      message: message ?? this.message,
      code: code ?? this.code,
      data: data ?? this.data,
    );
  }
}

class MessageData {
  final int? id;
  final int? conversationId;
  final int? senderId;
  final String? senderName;
  final String? message;
  final String? attachment;
  final bool? isRead;
  final DateTime? createdAt;
  final String? timeAgo;

  MessageData({
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

  factory MessageData.fromRawJson(String str) =>
      MessageData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      id: json["id"],
      conversationId: json["conversation_id"],
      senderId: json["sender_id"],
      senderName: json["sender_name"],
      message: json["message"],
      attachment: json["attachment"],
      isRead: json["is_read"],
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"])
          : null,
      timeAgo: json["time_ago"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
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

  MessageData copyWith({
    int? id,
    int? conversationId,
    int? senderId,
    String? senderName,
    String? message,
    String? attachment,
    bool? isRead,
    DateTime? createdAt,
    String? timeAgo,
  }) {
    return MessageData(
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
  }
}