import 'dart:convert';

class RegisterModel {
    bool? status;
    String? message;
    int? code;

    RegisterModel({
        this.status,
        this.message,
        this.code,
    });

    RegisterModel copyWith({
        bool? status,
        String? message,
        int? code,
    }) => 
        RegisterModel(
            status: status ?? this.status,
            message: message ?? this.message,
            code: code ?? this.code,
        );

    factory RegisterModel.fromRawJson(String str) => RegisterModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        status: json["status"],
        message: json["message"],
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "code": code,
    };
}
