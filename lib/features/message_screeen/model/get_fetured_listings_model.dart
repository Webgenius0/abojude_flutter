import 'dart:convert';

class GetFeturedListinsModel {
  bool? status;
  String? message;
  int? code;
  List<Datum>? data;
  Pagination? pagination;

  GetFeturedListinsModel({
    this.status,
    this.message,
    this.code,
    this.data,
    this.pagination,
  });

  GetFeturedListinsModel copyWith({
    bool? status,
    String? message,
    int? code,
    List<Datum>? data,
    Pagination? pagination,
  }) =>
      GetFeturedListinsModel(
        status: status ?? this.status,
        message: message ?? this.message,
        code: code ?? this.code,
        data: data ?? this.data,
        pagination: pagination ?? this.pagination,
      );

  factory GetFeturedListinsModel.fromRawJson(String str) => GetFeturedListinsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetFeturedListinsModel.fromJson(Map<String, dynamic> json) => GetFeturedListinsModel(
    status: json["status"],
    message: json["message"],
    code: json["code"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "code": code,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
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

class Pagination {
  int? total;
  int? currentPage;
  int? perPage;
  int? lastPage;
  int? from;
  int? to;

  Pagination({
    this.total,
    this.currentPage,
    this.perPage,
    this.lastPage,
    this.from,
    this.to,
  });

  Pagination copyWith({
    int? total,
    int? currentPage,
    int? perPage,
    int? lastPage,
    int? from,
    int? to,
  }) =>
      Pagination(
        total: total ?? this.total,
        currentPage: currentPage ?? this.currentPage,
        perPage: perPage ?? this.perPage,
        lastPage: lastPage ?? this.lastPage,
        from: from ?? this.from,
        to: to ?? this.to,
      );

  factory Pagination.fromRawJson(String str) => Pagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: json["total"],
    currentPage: json["current_page"],
    perPage: json["per_page"],
    lastPage: json["last_page"],
    from: json["from"],
    to: json["to"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "current_page": currentPage,
    "per_page": perPage,
    "last_page": lastPage,
    "from": from,
    "to": to,
  };
}
