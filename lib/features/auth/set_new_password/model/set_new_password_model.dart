import 'dart:convert';

class ChangePasswordModel {
    bool? status;
    String? message;
    int? code;

    ChangePasswordModel({
        this.status,
        this.message,
        this.code,
    });

    ChangePasswordModel copyWith({
        bool? status,
        String? message,
        int? code,
    }) => 
        ChangePasswordModel(
            status: status ?? this.status,
            message: message ?? this.message,
            code: code ?? this.code,
        );

    factory ChangePasswordModel.fromRawJson(String str) => ChangePasswordModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ChangePasswordModel.fromJson(Map<String, dynamic> json) => ChangePasswordModel(
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
