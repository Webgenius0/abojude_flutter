import 'dart:convert';

class GetCityModel {
    bool? status;
    String? message;
    int? code;
    List<String>? data;

    GetCityModel({
        this.status,
        this.message,
        this.code,
        this.data,
    });

    GetCityModel copyWith({
        bool? status,
        String? message,
        int? code,
        List<String>? data,
    }) => 
        GetCityModel(
            status: status ?? this.status,
            message: message ?? this.message,
            code: code ?? this.code,
            data: data ?? this.data,
        );

    factory GetCityModel.fromRawJson(String str) => GetCityModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetCityModel.fromJson(Map<String, dynamic> json) => GetCityModel(
        status: json["status"],
        message: json["message"],
        code: json["code"],
        data: json["data"] == null ? [] : List<String>.from(json["data"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "code": code,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
    };
}
