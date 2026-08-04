
import 'dart:convert';

class GetMessageListModel {
  final bool? status;
  final String? message;
  final int? code;
  final List<Datum> data;

  GetMessageListModel({
    this.status,
    this.message,
    this.code,
    this.data = const [],
  });

  GetMessageListModel copyWith({
    bool? status,
    String? message,
    int? code,
    List<Datum>? data,
  }) {
    return GetMessageListModel(
      status: status ?? this.status,
      message: message ?? this.message,
      code: code ?? this.code,
      data: data ?? this.data,
    );
  }

  factory GetMessageListModel.fromRawJson(String str) =>
      GetMessageListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetMessageListModel.fromJson(Map<String, dynamic> json) {
    return GetMessageListModel(
      status: json["status"] as bool?,
      message: json["message"]?.toString(),
      code: json["code"] as int?,
      data: (json["data"] as List?)
          ?.map((e) => Datum.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "code": code,
    "data": data.map((e) => e.toJson()).toList(),
  };
}

class Datum {
  final int? id;
  final OtherUser? otherUser;
  final Post? post;
  final LastMessage? lastMessage;
  final int? unreadCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Datum({
    this.id,
    this.otherUser,
    this.post,
    this.lastMessage,
    this.unreadCount,
    this.createdAt,
    this.updatedAt,
  });

  Datum copyWith({
    int? id,
    OtherUser? otherUser,
    Post? post,
    LastMessage? lastMessage,
    int? unreadCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Datum(
      id: id ?? this.id,
      otherUser: otherUser ?? this.otherUser,
      post: post ?? this.post,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Datum.fromRawJson(String str) =>
      Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json["id"] as int?,
      otherUser: json["other_user"] == null
          ? null
          : OtherUser.fromJson(json["other_user"]),
      post: json["post"] == null
          ? null
          : Post.fromJson(json["post"]),
      lastMessage: json["last_message"] == null
          ? null
          : LastMessage.fromJson(json["last_message"]),
      unreadCount: json["unread_count"] as int?,
      createdAt: DateTime.tryParse(json["created_at"]?.toString() ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"]?.toString() ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "other_user": otherUser?.toJson(),
    "post": post?.toJson(),
    "last_message": lastMessage?.toJson(),
    "unread_count": unreadCount,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class OtherUser {
  final int? id;
  final String? name;
  final String? avatar;
  final bool? isOnline;

  OtherUser({
    this.id,
    this.name,
    this.avatar,
    this.isOnline,
  });

  OtherUser copyWith({
    int? id,
    String? name,
    String? avatar,
    bool? isOnline,
  }) {
    return OtherUser(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  factory OtherUser.fromRawJson(String str) =>
      OtherUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OtherUser.fromJson(Map<String, dynamic> json) {
    return OtherUser(
      id: json["id"] as int?,
      name: json["name"]?.toString(),
      avatar: json["avatar"]?.toString(),
      isOnline: json["is_online"] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "avatar": avatar,
    "is_online": isOnline,
  };
}

class Post {
  final int? id;
  final String? title;
  final String? price;
  final String? thumbnail;

  Post({
    this.id,
    this.title,
    this.price,
    this.thumbnail,
  });

  Post copyWith({
    int? id,
    String? title,
    String? price,
    String? thumbnail,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }

  factory Post.fromRawJson(String str) =>
      Post.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["id"] as int?,
      title: json["title"]?.toString(),
      price: json["price"]?.toString(),
      thumbnail: json["thumbnail"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "price": price,
    "thumbnail": thumbnail,
  };
}

class LastMessage {
  final int? id;
  final String? message;
  final int? senderId;
  final DateTime? createdAt;
  final String? timeAgo;

  LastMessage({
    this.id,
    this.message,
    this.senderId,
    this.createdAt,
    this.timeAgo,
  });

  LastMessage copyWith({
    int? id,
    String? message,
    int? senderId,
    DateTime? createdAt,
    String? timeAgo,
  }) {
    return LastMessage(
      id: id ?? this.id,
      message: message ?? this.message,
      senderId: senderId ?? this.senderId,
      createdAt: createdAt ?? this.createdAt,
      timeAgo: timeAgo ?? this.timeAgo,
    );
  }

  factory LastMessage.fromRawJson(String str) =>
      LastMessage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      id: json["id"] as int?,
      message: json["message"]?.toString(),
      senderId: json["sender_id"] as int?,
      createdAt: DateTime.tryParse(json["created_at"]?.toString() ?? ""),
      timeAgo: json["time_ago"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "message": message,
    "sender_id": senderId,
    "created_at": createdAt?.toIso8601String(),
    "time_ago": timeAgo,
  };
}