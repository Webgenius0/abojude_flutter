import 'dart:convert';

class LoginModel {
    bool? status;
    String? message;
    int? code;
    String? tokenType;
    String? token;
    Data? data;

    LoginModel({
        this.status,
        this.message,
        this.code,
        this.tokenType,
        this.token,
        this.data,
    });

    LoginModel copyWith({
        bool? status,
        String? message,
        int? code,
        String? tokenType,
        String? token,
        Data? data,
    }) => 
        LoginModel(
            status: status ?? this.status,
            message: message ?? this.message,
            code: code ?? this.code,
            tokenType: tokenType ?? this.tokenType,
            token: token ?? this.token,
            data: data ?? this.data,
        );

    factory LoginModel.fromRawJson(String str) => LoginModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
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
    int? id;
    int? uuid;
    String? name;
    String? email;
    dynamic province;
    dynamic city;
    dynamic address;
    dynamic latitude;
    dynamic longitude;
    String? status;
    String? role;
    dynamic guestToken;
    dynamic guestExpiresAt;
    bool? newMessage;
    bool? marketing;
    bool? emailNotification;

    Data({
        this.id,
        this.uuid,
        this.name,
        this.email,
        this.province,
        this.city,
        this.address,
        this.latitude,
        this.longitude,
        this.status,
        this.role,
        this.guestToken,
        this.guestExpiresAt,
        this.newMessage,
        this.marketing,
        this.emailNotification,
    });

    Data copyWith({
        int? id,
        int? uuid,
        String? name,
        String? email,
        dynamic province,
        dynamic city,
        dynamic address,
        dynamic latitude,
        dynamic longitude,
        String? status,
        String? role,
        dynamic guestToken,
        dynamic guestExpiresAt,
        bool? newMessage,
        bool? marketing,
        bool? emailNotification,
    }) => 
        Data(
            id: id ?? this.id,
            uuid: uuid ?? this.uuid,
            name: name ?? this.name,
            email: email ?? this.email,
            province: province ?? this.province,
            city: city ?? this.city,
            address: address ?? this.address,
            latitude: latitude ?? this.latitude,
            longitude: longitude ?? this.longitude,
            status: status ?? this.status,
            role: role ?? this.role,
            guestToken: guestToken ?? this.guestToken,
            guestExpiresAt: guestExpiresAt ?? this.guestExpiresAt,
            newMessage: newMessage ?? this.newMessage,
            marketing: marketing ?? this.marketing,
            emailNotification: emailNotification ?? this.emailNotification,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        uuid: json["uuid"],
        name: json["name"],
        email: json["email"],
        province: json["province"],
        city: json["city"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        status: json["status"],
        role: json["role"],
        guestToken: json["guest_token"],
        guestExpiresAt: json["guest_expires_at"],
        newMessage: json["new_message"],
        marketing: json["marketing"],
        emailNotification: json["email_notification"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "name": name,
        "email": email,
        "province": province,
        "city": city,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "status": status,
        "role": role,
        "guest_token": guestToken,
        "guest_expires_at": guestExpiresAt,
        "new_message": newMessage,
        "marketing": marketing,
        "email_notification": emailNotification,
    };
}
