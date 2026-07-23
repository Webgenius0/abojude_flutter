import 'dart:convert';

class BlockUserListModel {
    bool? status;
    String? message;
    int? code;
    List<Datum>? data;

    BlockUserListModel({
        this.status,
        this.message,
        this.code,
        this.data,
    });

    BlockUserListModel copyWith({
        bool? status,
        String? message,
        int? code,
        List<Datum>? data,
    }) => 
        BlockUserListModel(
            status: status ?? this.status,
            message: message ?? this.message,
            code: code ?? this.code,
            data: data ?? this.data,
        );

    factory BlockUserListModel.fromRawJson(String str) => BlockUserListModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory BlockUserListModel.fromJson(Map<String, dynamic> json) => BlockUserListModel(
        status: json["status"],
        message: json["message"],
        code: json["code"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "code": code,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    String? name;
    dynamic avatar;
    String? timeAgo;

    Datum({
        this.id,
        this.name,
        this.avatar,
        this.timeAgo,
    });

    Datum copyWith({
        int? id,
        String? name,
        dynamic avatar,
        String? timeAgo,
    }) => 
        Datum(
            id: id ?? this.id,
            name: name ?? this.name,
            avatar: avatar ?? this.avatar,
            timeAgo: timeAgo ?? this.timeAgo,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        avatar: json["avatar"],
        timeAgo: json["time_ago"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "avatar": avatar,
        "time_ago": timeAgo,
    };
}
