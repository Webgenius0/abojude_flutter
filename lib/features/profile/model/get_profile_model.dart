import 'dart:convert';

class GetProfileModel {
    bool? status;
    String? message;
    int? code;
    Data? data;

    GetProfileModel({
        this.status,
        this.message,
        this.code,
        this.data,
    });

    GetProfileModel copyWith({
        bool? status,
        String? message,
        int? code,
        Data? data,
    }) => 
        GetProfileModel(
            status: status ?? this.status,
            message: message ?? this.message,
            code: code ?? this.code,
            data: data ?? this.data,
        );

    factory GetProfileModel.fromRawJson(String str) => GetProfileModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetProfileModel.fromJson(Map<String, dynamic> json) => GetProfileModel(
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
    int? uuid;
    String? name;
    String? email;
    String? province;
    String? city;
    dynamic address;
    String? avatar;
    String? role;

    Data({
        this.id,
        this.uuid,
        this.name,
        this.email,
        this.province,
        this.city,
        this.address,
        this.avatar,
        this.role,
    });

    Data copyWith({
        int? id,
        int? uuid,
        String? name,
        String? email,
        String? province,
        String? city,
        dynamic address,
        String? avatar,
        String? role,
    }) => 
        Data(
            id: id ?? this.id,
            uuid: uuid ?? this.uuid,
            name: name ?? this.name,
            email: email ?? this.email,
            province: province ?? this.province,
            city: city ?? this.city,
            address: address ?? this.address,
            avatar: avatar ?? this.avatar,
            role: role ?? this.role,
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
        avatar: json["avatar"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "name": name,
        "email": email,
        "province": province,
        "city": city,
        "address": address,
        "avatar": avatar,
        "role": role,
    };
}
