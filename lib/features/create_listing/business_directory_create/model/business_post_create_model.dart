import 'dart:convert';

class BusinessPostCreateModel {
  bool? status;
  String? message;
  int? code;
  Data? data;

  BusinessPostCreateModel({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  BusinessPostCreateModel copyWith({
    bool? status,
    String? message,
    int? code,
    Data? data,
  }) =>
      BusinessPostCreateModel(
        status: status ?? this.status,
        message: message ?? this.message,
        code: code ?? this.code,
        data: data ?? this.data,
      );

  factory BusinessPostCreateModel.fromRawJson(String str) =>
      BusinessPostCreateModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BusinessPostCreateModel.fromJson(Map<String, dynamic> json) =>
      BusinessPostCreateModel(
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
  String? businessName;
  String? businessCategory;
  String? description;
  String? website;
  String? province;
  String? city;
  String? address;
  String? phone;
  String? whatsapp;
  String? email;
  bool? isAppChat;
  String? logo;
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
    this.businessName,
    this.businessCategory,
    this.description,
    this.website,
    this.province,
    this.city,
    this.address,
    this.phone,
    this.whatsapp,
    this.email,
    this.isAppChat,
    this.logo,
    this.status,
  });

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
        businessName: json["business_name"],
        businessCategory: json["business_category"],
        description: json["description"],
        website: json["website"],
        province: json["province"],
        city: json["city"],
        address: json["address"],
        phone: json["phone"],
        whatsapp: json["whatsapp"],
        email: json["email"],
        isAppChat: json["is_app_chat"],
        logo: json["logo"],
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
        "business_name": businessName,
        "business_category": businessCategory,
        "description": description,
        "website": website,
        "province": province,
        "city": city,
        "address": address,
        "phone": phone,
        "whatsapp": whatsapp,
        "email": email,
        "is_app_chat": isAppChat,
        "logo": logo,
        "status": status,
      };
}
