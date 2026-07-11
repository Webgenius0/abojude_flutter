import 'dart:convert';

class ResendOtpModel {
    bool? status;
    String? message;
    int? code;
    Data? data;

    ResendOtpModel({
        this.status,
        this.message,
        this.code,
        this.data,
    });

    ResendOtpModel copyWith({
        bool? status,
        String? message,
        int? code,
        Data? data,
    }) => 
        ResendOtpModel(
            status: status ?? this.status,
            message: message ?? this.message,
            code: code ?? this.code,
            data: data ?? this.data,
        );

    factory ResendOtpModel.fromRawJson(String str) => ResendOtpModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ResendOtpModel.fromJson(Map<String, dynamic> json) => ResendOtpModel(
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
    String? type;
    bool? sent;

    Data({
        this.email,
        this.type,
        this.sent,
    });

    Data copyWith({
        String? email,
        String? type,
        bool? sent,
    }) => 
        Data(
            email: email ?? this.email,
            type: type ?? this.type,
            sent: sent ?? this.sent,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        email: json["email"],
        type: json["type"],
        sent: json["sent"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "type": type,
        "sent": sent,
    };
}
