import 'dart:convert';

class AddListModel {
    bool? status;
    String? message;
    int? code;
    List<Datum>? data;

    AddListModel({
        this.status,
        this.message,
        this.code,
        this.data,
    });

    AddListModel copyWith({
        bool? status,
        String? message,
        int? code,
        List<Datum>? data,
    }) => 
        AddListModel(
            status: status ?? this.status,
            message: message ?? this.message,
            code: code ?? this.code,
            data: data ?? this.data,
        );

    factory AddListModel.fromRawJson(String str) => AddListModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AddListModel.fromJson(Map<String, dynamic> json) => AddListModel(
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
    String? title;
    String? media;
    String? mediaType;
    String? backLink;

    Datum({
        this.id,
        this.title,
        this.media,
        this.mediaType,
        this.backLink,
    });

    Datum copyWith({
        int? id,
        String? title,
        String? media,
        String? mediaType,
        String? backLink,
    }) => 
        Datum(
            id: id ?? this.id,
            title: title ?? this.title,
            media: media ?? this.media,
            mediaType: mediaType ?? this.mediaType,
            backLink: backLink ?? this.backLink,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        media: json["media"],
        mediaType: json["media_type"],
        backLink: json["back_link"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "media": media,
        "media_type": mediaType,
        "back_link": backLink,
    };
}
