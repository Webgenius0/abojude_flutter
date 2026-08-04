import 'dart:convert';

class GetPostDetailsModel {
  final bool? status;
  final String? message;
  final int? code;
  final Data? data;

  GetPostDetailsModel({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  GetPostDetailsModel copyWith({
    bool? status,
    String? message,
    int? code,
    Data? data,
  }) =>
      GetPostDetailsModel(
        status: status ?? this.status,
        message: message ?? this.message,
        code: code ?? this.code,
        data: data ?? this.data,
      );

  factory GetPostDetailsModel.fromRawJson(String str) =>
      GetPostDetailsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPostDetailsModel.fromJson(Map<String, dynamic> json) =>
      GetPostDetailsModel(
        status: json["status"] as bool?,
        message: json["message"] as String?,
        code: json["code"] as int?,
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
  final int? userId;
  final String? userName;
  final String? userSince;
  final int? categoryId;
  final String? categoryName;
  final String? categorySlug;
  final String? thumbnail;
  final String? businessName;
  final String? businessCategory;
  final String? description;
  final String? website;
  final List<String>? photos;
  final String? province;
  final String? city;
  final String? address;
  final String? phone;
  final String? whatsapp;
  final String? email;
  final bool? isAppChat;
  final String? logo;
  final String? status;
  final DateTime? createdAt;
  final String? timeAgo;
  final double? latitude;
  final double? longitude;
  final double? distance;
  final BusinessHours? businessHours;

  Data({
    this.userId,
    this.userName,
    this.userSince,
    this.categoryId,
    this.categoryName,
    this.categorySlug,
    this.thumbnail,
    this.businessName,
    this.businessCategory,
    this.description,
    this.website,
    this.photos,
    this.province,
    this.city,
    this.address,
    this.phone,
    this.whatsapp,
    this.email,
    this.isAppChat,
    this.logo,
    this.status,
    this.createdAt,
    this.timeAgo,
    this.latitude,
    this.longitude,
    this.distance,
    this.businessHours,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"] as int?,
    userName: json["user_name"] as String?,
    userSince: json["user_since"] as String?,
    categoryId: json["category_id"] as int?,
    categoryName: json["category_name"] as String?,
    categorySlug: json["category_slug"] as String?,
    thumbnail: json["thumbnail"] as String?,
    businessName: json["business_name"] as String?,
    businessCategory: json["business_category"] as String?,
    description: json["description"] as String?,
    website: json["website"] as String?,
    photos: json["photos"] == null
        ? []
        : List<String>.from(json["photos"].map((x) => x.toString())),
    province: json["province"] as String?,
    city: json["city"] as String?,
    address: json["address"] as String?,
    phone: json["phone"] as String?,
    whatsapp: json["whatsapp"] as String?,
    email: json["email"] as String?,
    isAppChat: json["is_app_chat"] as bool?,
    logo: json["logo"] as String?,
    status: json["status"] as String?,
    createdAt: json["created_at"] == null
        ? null
        : DateTime.tryParse(json["created_at"]),
    timeAgo: json["time_ago"] as String?,
    latitude: double.tryParse(json["latitude"]?.toString() ?? ''),
    longitude: double.tryParse(json["longitude"]?.toString() ?? ''),
    distance: double.tryParse(json["distance"]?.toString() ?? ''),
    businessHours: json["business_hours"] == null
        ? null
        : BusinessHours.fromJson(json["business_hours"]),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "user_name": userName,
    "user_since": userSince,
    "category_id": categoryId,
    "category_name": categoryName,
    "category_slug": categorySlug,
    "thumbnail": thumbnail,
    "business_name": businessName,
    "business_category": businessCategory,
    "description": description,
    "website": website,
    "photos": photos == null ? [] : List<dynamic>.from(photos!.map((x) => x)),
    "province": province,
    "city": city,
    "address": address,
    "phone": phone,
    "whatsapp": whatsapp,
    "email": email,
    "is_app_chat": isAppChat,
    "logo": logo,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "time_ago": timeAgo,
    "latitude": latitude,
    "longitude": longitude,
    "distance": distance,
    "business_hours": businessHours?.toJson(),
  };
}

class BusinessHours {
  final Day? sunday;
  final Day? monday;
  final Day? tuesday;
  final Day? wednesday;
  final Day? thursday;
  final Day? friday;
  final Day? saturday;

  BusinessHours({
    this.sunday,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
  });

  factory BusinessHours.fromJson(Map<String, dynamic> json) => BusinessHours(
    sunday: json["sunday"] == null ? null : Day.fromJson(json["sunday"]),
    monday: json["monday"] == null ? null : Day.fromJson(json["monday"]),
    tuesday: json["tuesday"] == null ? null : Day.fromJson(json["tuesday"]),
    wednesday: json["wednesday"] == null ? null : Day.fromJson(json["wednesday"]),
    thursday: json["thursday"] == null ? null : Day.fromJson(json["thursday"]),
    friday: json["friday"] == null ? null : Day.fromJson(json["friday"]),
    saturday: json["saturday"] == null ? null : Day.fromJson(json["saturday"]),
  );

  Map<String, dynamic> toJson() => {
    "sunday": sunday?.toJson(),
    "monday": monday?.toJson(),
    "tuesday": tuesday?.toJson(),
    "wednesday": wednesday?.toJson(),
    "thursday": thursday?.toJson(),
    "friday": friday?.toJson(),
    "saturday": saturday?.toJson(),
  };
}

class Day {
  final String? isClosed;
  final String? openingHour;
  final String? closingTime;

  Day({
    this.isClosed,
    this.openingHour,
    this.closingTime,
  });

  factory Day.fromJson(Map<String, dynamic> json) => Day(
    isClosed: json["is_closed"]?.toString(),
    openingHour: json["opening_hour"] as String?,
    closingTime: json["closing_time"] as String?,
  );

  Map<String, dynamic> toJson() => {
    "is_closed": isClosed,
    "opening_hour": openingHour,
    "closing_time": closingTime,
  };
}