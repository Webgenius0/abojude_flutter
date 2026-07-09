import 'dart:convert';

class ForgetPasswordModel {
    bool? status;
    String? message;
    int? code;
    Data? data;

    ForgetPasswordModel({
        this.status,
        this.message,
        this.code,
        this.data,
    });

    ForgetPasswordModel copyWith({
        bool? status,
        String? message,
        int? code,
        Data? data,
    }) => 
        ForgetPasswordModel(
            status: status ?? this.status,
            message: message ?? this.message,
            code: code ?? this.code,
            data: data ?? this.data,
        );

    factory ForgetPasswordModel.fromRawJson(String str) => ForgetPasswordModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ForgetPasswordModel.fromJson(Map<String, dynamic> json) => ForgetPasswordModel(
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
    String? email;
    bool? sent;

    Data({
        this.email,
        this.sent,
    });

    Data copyWith({
        String? email,
        bool? sent,
    }) => 
        Data(
            email: email ?? this.email,
            sent: sent ?? this.sent,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        email: json["email"],
        sent: json["sent"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "sent": sent,
    };
}
