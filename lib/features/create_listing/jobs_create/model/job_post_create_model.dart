import 'dart:convert';

class JobPostCreateModel {
  bool? status;
  String? message;
  int? code;
  Data? data;

  JobPostCreateModel({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  JobPostCreateModel copyWith({
    bool? status,
    String? message,
    int? code,
    Data? data,
  }) =>
      JobPostCreateModel(
        status: status ?? this.status,
        message: message ?? this.message,
        code: code ?? this.code,
        data: data ?? this.data,
      );

  factory JobPostCreateModel.fromRawJson(String str) =>
      JobPostCreateModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory JobPostCreateModel.fromJson(Map<String, dynamic> json) =>
      JobPostCreateModel(
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
  String? title;
  String? companyName;
  String? description;
  List<String>? jobType;
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
    this.title,
    this.companyName,
    this.description,
    this.jobType,
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
    String? title,
    String? companyName,
    String? description,
    List<String>? jobType,
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
        title: title ?? this.title,
        companyName: companyName ?? this.companyName,
        description: description ?? this.description,
        jobType: jobType ?? this.jobType,
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
        title: json["title"],
        companyName: json["company_name"],
        description: json["description"],
        jobType: json["job_type"] == null
            ? []
            : (json["job_type"] is List
                ? List<String>.from(json["job_type"]!.map((x) => x.toString()))
                : [json["job_type"].toString()]),
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
        "title": title,
        "company_name": companyName,
        "description": description,
        "job_type": jobType == null ? [] : List<dynamic>.from(jobType!.map((x) => x)),
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
