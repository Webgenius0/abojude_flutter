import 'dart:convert';

class GetPostDetailsModel {
  bool? status;
  String? message;
  int? code;
  PostDetailsData? data;

  GetPostDetailsModel({
    this.status,
    this.message,
    this.code,
    this.data,
  });

  factory GetPostDetailsModel.fromRawJson(String str) =>
      GetPostDetailsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPostDetailsModel.fromJson(Map<String, dynamic> json) =>
      GetPostDetailsModel(
        status: json["status"],
        message: json["message"],
        code: json["code"],
        data: json["data"] == null ? null : PostDetailsData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "code": code,
        "data": data?.toJson(),
      };
}

class PostDetailsData {
  int? id;
  int? userId;
  int? categoryId;
  String? categoryName;
  String? title;
  String? description;
  String? price;
  String? province;
  String? city;
  String? thumbnail;
  List<String>? images;
  bool? isFeatured;
  bool? isWish;
  String? timeAgo;
  String? phone;
  String? email;
  String? whatsapp;
  String? website;
  Map<String, dynamic>? specifications;
  UserDetails? user;
  List<RelatedPost>? relatedPosts;

  PostDetailsData({
    this.id,
    this.userId,
    this.categoryId,
    this.categoryName,
    this.title,
    this.description,
    this.price,
    this.province,
    this.city,
    this.thumbnail,
    this.images,
    this.isFeatured,
    this.isWish,
    this.timeAgo,
    this.phone,
    this.email,
    this.whatsapp,
    this.website,
    this.specifications,
    this.user,
    this.relatedPosts,
  });

  factory PostDetailsData.fromJson(Map<String, dynamic> json) => PostDetailsData(
        id: json["id"],
        userId: json["user_id"],
        categoryId: json["category_id"],
        categoryName: json["category_name"] ?? json["category"],
        title: json["title"],
        description: json["description"],
        price: json["price"]?.toString(),
        province: json["province"],
        city: json["city"],
        thumbnail: json["thumbnail"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x.toString())),
        isFeatured: json["is_featured"],
        isWish: json["is_wish"],
        timeAgo: json["time_ago"],
        phone: json["phone"]?.toString(),
        email: json["email"]?.toString(),
        whatsapp: json["whatsapp"]?.toString(),
        website: json["website"]?.toString(),
        specifications: json["specifications"] is Map<String, dynamic>
            ? json["specifications"]
            : null,
        user: json["user"] == null ? null : UserDetails.fromJson(json["user"]),
        relatedPosts: json["related_posts"] == null
            ? []
            : List<RelatedPost>.from(
                json["related_posts"]!.map((x) => RelatedPost.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "category_id": categoryId,
        "category_name": categoryName,
        "title": title,
        "description": description,
        "price": price,
        "province": province,
        "city": city,
        "thumbnail": thumbnail,
        "images": images,
        "is_featured": isFeatured,
        "is_wish": isWish,
        "time_ago": timeAgo,
        "phone": phone,
        "email": email,
        "whatsapp": whatsapp,
        "website": website,
        "specifications": specifications,
        "user": user?.toJson(),
        "related_posts": relatedPosts == null
            ? []
            : List<dynamic>.from(relatedPosts!.map((x) => x.toJson())),
      };
}

class UserDetails {
  int? id;
  String? name;
  String? avatar;
  String? phone;
  String? email;

  UserDetails({
    this.id,
    this.name,
    this.avatar,
    this.phone,
    this.email,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        id: json["id"],
        name: json["name"]?.toString(),
        avatar: json["avatar"]?.toString(),
        phone: json["phone"]?.toString(),
        email: json["email"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "avatar": avatar,
        "phone": phone,
        "email": email,
      };
}

class RelatedPost {
  int? id;
  String? title;
  String? categoryName;
  String? thumbnail;
  String? price;
  String? province;
  String? city;
  bool? isWish;

  RelatedPost({
    this.id,
    this.title,
    this.categoryName,
    this.thumbnail,
    this.price,
    this.province,
    this.city,
    this.isWish,
  });

  factory RelatedPost.fromJson(Map<String, dynamic> json) => RelatedPost(
        id: json["id"],
        title: json["title"],
        categoryName: json["category_name"] ?? json["category"],
        thumbnail: json["thumbnail"],
        price: json["price"]?.toString(),
        province: json["province"],
        city: json["city"],
        isWish: json["is_wish"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "category_name": categoryName,
        "thumbnail": thumbnail,
        "price": price,
        "province": province,
        "city": city,
        "is_wish": isWish,
      };
}
