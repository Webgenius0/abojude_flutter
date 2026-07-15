import 'dart:convert';

class SelectLocationForGuestUserModel {
  bool? status;
  String? message;
  int? code;
  Data? data;

  SelectLocationForGuestUserModel({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  SelectLocationForGuestUserModel copyWith({
    bool? status,
    String? message,
    int? code,
    Data? data,
  }) => SelectLocationForGuestUserModel(
    status: status ?? this.status,
    message: message ?? this.message,
    code: code ?? this.code,
    data: data ?? this.data,
  );

  factory SelectLocationForGuestUserModel.fromRawJson(String str) =>
      SelectLocationForGuestUserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SelectLocationForGuestUserModel.fromJson(Map<String, dynamic> json) =>
      SelectLocationForGuestUserModel(
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
  int? userId;
  String? province;
  String? city;
  dynamic latitude;
  dynamic longitude;
  String? role;
  String? guestToken;
  int? guestExpiresAt;

  Data({
    this.userId,
    this.province,
    this.city,
    this.latitude,
    this.longitude,
    this.role,
    this.guestToken,
    this.guestExpiresAt,
  });

  Data copyWith({
    int? userId,
    String? province,
    String? city,
    dynamic latitude,
    dynamic longitude,
    String? role,
    String? guestToken,
    int? guestExpiresAt,
  }) => Data(
    userId: userId ?? this.userId,
    province: province ?? this.province,
    city: city ?? this.city,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    role: role ?? this.role,
    guestToken: guestToken ?? this.guestToken,
    guestExpiresAt: guestExpiresAt ?? this.guestExpiresAt,
  );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"],
    province: json["province"],
    city: json["city"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    role: json["role"],
    guestToken: json["guest_token"],
    guestExpiresAt: json["guest_expires_at"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "province": province,
    "city": city,
    "latitude": latitude,
    "longitude": longitude,
    "role": role,
    "guest_token": guestToken,
    "guest_expires_at": guestExpiresAt,
  };
}
