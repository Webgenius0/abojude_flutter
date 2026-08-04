import 'dart:convert';

class BuyAndSellPostCreateModel {
    bool? status;
    String? message;
    int? code;
    Data? data;

    BuyAndSellPostCreateModel({
        this.status,
        this.message,
        this.code,
        this.data,
    });

    BuyAndSellPostCreateModel copyWith({
        bool? status,
        String? message,
        int? code,
        Data? data,
    }) => 
        BuyAndSellPostCreateModel(
            status: status ?? this.status,
            message: message ?? this.message,
            code: code ?? this.code,
            data: data ?? this.data,
        );

    factory BuyAndSellPostCreateModel.fromRawJson(String str) => BuyAndSellPostCreateModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory BuyAndSellPostCreateModel.fromJson(Map<String, dynamic> json) => BuyAndSellPostCreateModel(
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
    String? price;
    List<String>? condition;
    String? province;
    String? city;
    String? address;
    String? phone;
    String? whatsapp;
    String? email;
    bool? isAppChat;
    String? status;
    DateTime? createdAt;
    String? timeAgo;
    dynamic latitude;
    dynamic longitude;
    dynamic distance;

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
        this.price,
        this.condition,
        this.province,
        this.city,
        this.address,
        this.phone,
        this.whatsapp,
        this.email,
        this.isAppChat,
        this.status,
        this.createdAt,
        this.timeAgo,
        this.latitude,
        this.longitude,
        this.distance,
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
        String? price,
        List<String>? condition,
        String? province,
        String? city,
        String? address,
        String? phone,
        String? whatsapp,
        String? email,
        bool? isAppChat,
        String? status,
        DateTime? createdAt,
        String? timeAgo,
        dynamic latitude,
        dynamic longitude,
        dynamic distance,
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
            price: price ?? this.price,
            condition: condition ?? this.condition,
            province: province ?? this.province,
            city: city ?? this.city,
            address: address ?? this.address,
            phone: phone ?? this.phone,
            whatsapp: whatsapp ?? this.whatsapp,
            email: email ?? this.email,
            isAppChat: isAppChat ?? this.isAppChat,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            timeAgo: timeAgo ?? this.timeAgo,
            latitude: latitude ?? this.latitude,
            longitude: longitude ?? this.longitude,
            distance: distance ?? this.distance,
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
        photos: json["photos"] == null ? [] : List<String>.from(json["photos"]!.map((x) => x)),
        title: json["title"],
        description: json["description"],
        price: json["price"],
        condition: json["condition"] == null ? [] : List<String>.from(json["condition"]!.map((x) => x)),
        province: json["province"],
        city: json["city"],
        address: json["address"],
        phone: json["phone"],
        whatsapp: json["whatsapp"],
        email: json["email"],
        isAppChat: json["is_app_chat"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        timeAgo: json["time_ago"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        distance: json["distance"],
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
        "price": price,
        "condition": condition == null ? [] : List<dynamic>.from(condition!.map((x) => x)),
        "province": province,
        "city": city,
        "address": address,
        "phone": phone,
        "whatsapp": whatsapp,
        "email": email,
        "is_app_chat": isAppChat,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "time_ago": timeAgo,
        "latitude": latitude,
        "longitude": longitude,
        "distance": distance,
    };
}
