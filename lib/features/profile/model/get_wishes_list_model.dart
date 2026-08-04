import 'dart:convert';

class GetWishListModel {
  bool? status;
  String? message;
  int? code;
  List<Datum>? data;

  GetWishListModel({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  GetWishListModel copyWith({
    bool? status,
    String? message,
    int? code,
    List<Datum>? data,
  }) =>
      GetWishListModel(
        status: status ?? this.status,
        message: message ?? this.message,
        code: code ?? this.code,
        data: data ?? this.data,
      );

  factory GetWishListModel.fromRawJson(String str) =>
      GetWishListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetWishListModel.fromJson(Map<String, dynamic> json) =>
      GetWishListModel(
        status: json["status"] as bool?,
        message: json["message"] as String?,
        code: json["code"] as int?,
        data: json["data"] is List
            ? List<Datum>.from(
            (json["data"] as List).map((x) => Datum.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "code": code,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
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
  double? distance;
  double? latitude;
  double? longitude;

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
    double? distance,
    double? latitude,
    double? longitude,
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
    id: json["id"] as int?,
    categoryId: json["category_id"] as int?,
    categoryName: json["category_name"] as String?,
    title: json["title"] as String?,
    thumbnail: json["thumbnail"] as String?,
    // Safe conversion in case API sends price as String or double/int
    price: json["price"]?.toString(),
    province: json["province"] as String?,
    city: json["city"] as String?,
    isFeatured: json["is_featured"] as bool?,
    isWish: json["is_wish"] as bool?,
    timeAgo: json["time_ago"] as String?,
    // Safe conversion for coordinates & numeric distances
    distance: (json["distance"] as num?)?.toDouble(),
    latitude: (json["latitude"] as num?)?.toDouble(),
    longitude: (json["longitude"] as num?)?.toDouble(),
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