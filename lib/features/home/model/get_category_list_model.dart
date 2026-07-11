import 'dart:convert';

class CategoryListModel {
    bool? status;
    String? message;
    int? code;
    List<Datum>? data;

    CategoryListModel({
        this.status,
        this.message,
        this.code,
        this.data,
    });

    CategoryListModel copyWith({
        bool? status,
        String? message,
        int? code,
        List<Datum>? data,
    }) => 
        CategoryListModel(
            status: status ?? this.status,
            message: message ?? this.message,
            code: code ?? this.code,
            data: data ?? this.data,
        );

    factory CategoryListModel.fromRawJson(String str) => CategoryListModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CategoryListModel.fromJson(Map<String, dynamic> json) => CategoryListModel(
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
    String? slug;
    String? shotDesc;
    String? icon;

    Datum({
        this.id,
        this.name,
        this.slug,
        this.shotDesc,
        this.icon,
    });

    Datum copyWith({
        int? id,
        String? name,
        String? slug,
        String? shotDesc,
        String? icon,
    }) => 
        Datum(
            id: id ?? this.id,
            name: name ?? this.name,
            slug: slug ?? this.slug,
            shotDesc: shotDesc ?? this.shotDesc,
            icon: icon ?? this.icon,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        shotDesc: json["shot_desc"],
        icon: json["icon"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "shot_desc": shotDesc,
        "icon": icon,
    };
}
