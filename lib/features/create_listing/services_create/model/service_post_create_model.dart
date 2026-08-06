import 'dart:convert';

class ServicePostCreateModel {
  bool? status;
  String? message;
  int? code;
  Data? data;

  ServicePostCreateModel({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  ServicePostCreateModel copyWith({
    bool? status,
    String? message,
    int? code,
    Data? data,
  }) =>
      ServicePostCreateModel(
        status: status ?? this.status,
        message: message ?? this.message,
        code: code ?? this.code,
        data: data ?? this.data,
      );

  factory ServicePostCreateModel.fromRawJson(String str) =>
      ServicePostCreateModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ServicePostCreateModel.fromJson(Map<String, dynamic> json) =>
      ServicePostCreateModel(
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
  String? userName;
  String? userSince;
  int? categoryId;
  String? categoryName;
  String? categorySlug;
  String? thumbnail;
  List<String>? photos;
  String? title;
  String? description;
  List<String>? serviceArea;
  String? province;
  String? city;
  String? address;
  String? phone;
  String? whatsapp;
  String? email;
  bool? isAppChat;
  String? status;

  Data({
    this.userId,
    this.userName,
    this.userSince,
    this.categoryId,
    this.categoryName,
    this.categorySlug,
    this.thumbnail,
    this.photos,
    this.title,
    this.description,
    this.serviceArea,
    this.province,
    this.city,
    this.address,
    this.phone,
    this.whatsapp,
    this.email,
    this.isAppChat,
    this.status,
  });

  Data copyWith({
    int? userId,
    String? userName,
    String? userSince,
    int? categoryId,
    String? categoryName,
    String? categorySlug,
    String? thumbnail,
    List<String>? photos,
    String? title,
    String? description,
    List<String>? serviceArea,
    String? province,
    String? city,
    String? address,
    String? phone,
    String? whatsapp,
    String? email,
    bool? isAppChat,
    String? status,
  }) =>
      Data(
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        userSince: userSince ?? this.userSince,
        categoryId: categoryId ?? this.categoryId,
        categoryName: categoryName ?? this.categoryName,
        categorySlug: categorySlug ?? this.categorySlug,
        thumbnail: thumbnail ?? this.thumbnail,
        photos: photos ?? this.photos,
        title: title ?? this.title,
        description: description ?? this.description,
        serviceArea: serviceArea ?? this.serviceArea,
        province: province ?? this.province,
        city: city ?? this.city,
        address: address ?? this.address,
        phone: phone ?? this.phone,
        whatsapp: whatsapp ?? this.whatsapp,
        email: email ?? this.email,
        isAppChat: isAppChat ?? this.isAppChat,
        status: status ?? this.status,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        userName: json["user_name"],
        userSince: json["user_since"],
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        categorySlug: json["category_slug"],
        thumbnail: json["thumbnail"],
        photos: json["photos"] == null
            ? []
            : List<String>.from(json["photos"]!.map((x) => x)),
        title: json["title"],
        description: json["description"],
        serviceArea: json["service_area"] == null
            ? []
            : List<String>.from(json["service_area"]!.map((x) => x)),
        province: json["province"],
        city: json["city"],
        address: json["address"],
        phone: json["phone"],
        whatsapp: json["whatsapp"],
        email: json["email"],
        isAppChat: json["is_app_chat"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "user_since": userSince,
        "category_id": categoryId,
        "category_name": categoryName,
        "category_slug": categorySlug,
        "thumbnail": thumbnail,
        "photos": photos == null ? [] : List<dynamic>.from(photos!.map((x) => x)),
        "title": title,
        "description": description,
        "service_area": serviceArea == null ? [] : List<dynamic>.from(serviceArea!.map((x) => x)),
        "province": province,
        "city": city,
        "address": address,
        "phone": phone,
        "whatsapp": whatsapp,
        "email": email,
        "is_app_chat": isAppChat,
        "status": status,
      };
}
