import 'dart:convert';

class TermsAndConditionModel {
    bool? status;
    String? message;
    int? code;
    Data? data;

    TermsAndConditionModel({
        this.status,
        this.message,
        this.code,
        this.data,
    });

    TermsAndConditionModel copyWith({
        bool? status,
        String? message,
        int? code,
        Data? data,
    }) => 
        TermsAndConditionModel(
            status: status ?? this.status,
            message: message ?? this.message,
            code: code ?? this.code,
            data: data ?? this.data,
        );

    factory TermsAndConditionModel.fromRawJson(String str) => TermsAndConditionModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TermsAndConditionModel.fromJson(Map<String, dynamic> json) => TermsAndConditionModel(
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
    String? title;
    String? slug;
    String? content;

    Data({
        this.id,
        this.title,
        this.slug,
        this.content,
    });

    Data copyWith({
        int? id,
        String? title,
        String? slug,
        String? content,
    }) => 
        Data(
            id: id ?? this.id,
            title: title ?? this.title,
            slug: slug ?? this.slug,
            content: content ?? this.content,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
        content: json["content"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slug": slug,
        "content": content,
    };
}
