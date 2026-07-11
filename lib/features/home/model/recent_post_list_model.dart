import 'dart:convert';

class RecentPostListModel {
    bool? status;
    String? message;
    int? code;
    List<Datum>? data;

    RecentPostListModel({
        this.status,
        this.message,
        this.code,
        this.data,
    });

    RecentPostListModel copyWith({
        bool? status,
        String? message,
        int? code,
        List<Datum>? data,
    }) => 
        RecentPostListModel(
            status: status ?? this.status,
            message: message ?? this.message,
            code: code ?? this.code,
            data: data ?? this.data,
        );

    factory RecentPostListModel.fromRawJson(String str) => RecentPostListModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory RecentPostListModel.fromJson(Map<String, dynamic> json) => RecentPostListModel(
        status: json["status"],
        message: json["message"],
        code: json["code"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "code": code,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    int? categoryId;
    String? categoryName;
    String? title;
    String? thumbnail;
    String? price;
    String? province;
    String? city;
    bool? isFeatured;
    bool? isWish;
    String? timeAgo;
    dynamic distance;
    dynamic latitude;
    dynamic longitude;

    Datum({
        this.id,
        this.categoryId,
        this.categoryName,
        this.title,
        this.thumbnail,
        this.price,
        this.province,
        this.city,
        this.isFeatured,
        this.isWish,
        this.timeAgo,
        this.distance,
        this.latitude,
        this.longitude,
    });

    Datum copyWith({
        int? id,
        int? categoryId,
        String? categoryName,
        String? title,
        String? thumbnail,
        String? price,
        String? province,
        String? city,
        bool? isFeatured,
        bool? isWish,
        String? timeAgo,
        dynamic distance,
        dynamic latitude,
        dynamic longitude,
    }) => 
        Datum(
            id: id ?? this.id,
            categoryId: categoryId ?? this.categoryId,
            categoryName: categoryName ?? this.categoryName,
            title: title ?? this.title,
            thumbnail: thumbnail ?? this.thumbnail,
            price: price ?? this.price,
            province: province ?? this.province,
            city: city ?? this.city,
            isFeatured: isFeatured ?? this.isFeatured,
            isWish: isWish ?? this.isWish,
            timeAgo: timeAgo ?? this.timeAgo,
            distance: distance ?? this.distance,
            latitude: latitude ?? this.latitude,
            longitude: longitude ?? this.longitude,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        title: json["title"],
        thumbnail: json["thumbnail"],
        price: json["price"],
        province: json["province"],
        city: json["city"],
        isFeatured: json["is_featured"],
        isWish: json["is_wish"],
        timeAgo: json["time_ago"],
        distance: json["distance"],
        latitude: json["latitude"],
        longitude: json["longitude"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "category_name": categoryName,
        "title": title,
        "thumbnail": thumbnail,
        "price": price,
        "province": province,
        "city": city,
        "is_featured": isFeatured,
        "is_wish": isWish,
        "time_ago": timeAgo,
        "distance": distance,
        "latitude": latitude,
        "longitude": longitude,
    };
}
