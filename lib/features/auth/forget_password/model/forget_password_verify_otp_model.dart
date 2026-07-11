import 'dart:convert';

class ForgetPasswordVerifyOtpModel {
    bool? status;
    String? message;
    int? code;
    Data? data;

    ForgetPasswordVerifyOtpModel({
        this.status,
        this.message,
        this.code,
        this.data,
    });

    ForgetPasswordVerifyOtpModel copyWith({
        bool? status,
        String? message,
        int? code,
        Data? data,
    }) => 
        ForgetPasswordVerifyOtpModel(
            status: status ?? this.status,
            message: message ?? this.message,
            code: code ?? this.code,
            data: data ?? this.data,
        );

    factory ForgetPasswordVerifyOtpModel.fromRawJson(String str) => ForgetPasswordVerifyOtpModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ForgetPasswordVerifyOtpModel.fromJson(Map<String, dynamic> json) => ForgetPasswordVerifyOtpModel(
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
    bool? verified;

    Data({
        this.email,
        this.verified,
    });

    Data copyWith({
        String? email,
        bool? verified,
    }) => 
        Data(
            email: email ?? this.email,
            verified: verified ?? this.verified,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        email: json["email"],
        verified: json["verified"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "verified": verified,
    };
}
