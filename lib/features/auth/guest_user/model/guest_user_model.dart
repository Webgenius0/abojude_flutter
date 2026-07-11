import 'dart:convert';

class GuestUserModel {
    bool? status;
    String? message;
    int? code;
    String? tokenType;
    String? token;
    Data? data;

    GuestUserModel({
        this.status,
        this.message,
        this.code,
        this.tokenType,
        this.token,
        this.data,
    });

    GuestUserModel copyWith({
        bool? status,
        String? message,
        int? code,
        String? tokenType,
        String? token,
        Data? data,
    }) => 
        GuestUserModel(
            status: status ?? this.status,
            message: message ?? this.message,
            code: code ?? this.code,
            tokenType: tokenType ?? this.tokenType,
            token: token ?? this.token,
            data: data ?? this.data,
        );

    factory GuestUserModel.fromRawJson(String str) => GuestUserModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GuestUserModel.fromJson(Map<String, dynamic> json) => GuestUserModel(
        status: json["status"],
        message: json["message"],
        code: json["code"],
        tokenType: json["token_type"],
        token: json["token"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "code": code,
        "token_type": tokenType,
        "token": token,
        "data": data?.toJson(),
    };
}

class Data {
    int? uuid;
    int? guestExpiresAt;
    String? role;

    Data({
        this.uuid,
        this.guestExpiresAt,
        this.role,
    });

    Data copyWith({
        int? uuid,
        int? guestExpiresAt,
        String? role,
    }) => 
        Data(
            uuid: uuid ?? this.uuid,
            guestExpiresAt: guestExpiresAt ?? this.guestExpiresAt,
            role: role ?? this.role,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        uuid: json["uuid"],
        guestExpiresAt: json["guest_expires_at"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "guest_expires_at": guestExpiresAt,
        "role": role,
    };
}
