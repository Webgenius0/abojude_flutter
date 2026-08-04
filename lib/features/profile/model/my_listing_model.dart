import 'dart:convert';

class GetMyListingModel {
  bool? status;
  String? message;
  int? code;
  Data? data;
  Pagination? pagination;

  GetMyListingModel({
    this.status,
    this.message,
    this.code,
    this.data,
    this.pagination,
  });

  GetMyListingModel copyWith({
    bool? status,
    String? message,
    int? code,
    Data? data,
    Pagination? pagination,
  }) =>
      GetMyListingModel(
        status: status ?? this.status,
        message: message ?? this.message,
        code: code ?? this.code,
        data: data ?? this.data,
        pagination: pagination ?? this.pagination,
      );

  factory GetMyListingModel.fromRawJson(String str) => GetMyListingModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetMyListingModel.fromJson(Map<String, dynamic> json) => GetMyListingModel(
    status: json["status"],
    message: json["message"],
    code: json["code"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "code": code,
    "data": data?.toJson(),
    "pagination": pagination?.toJson(),
  };
}

class Data {
  int? totalPost;
  int? totalView;
  int? totalWish;
  int? totalMessage;
  List<Post>? posts;

  Data({
    this.totalPost,
    this.totalView,
    this.totalWish,
    this.totalMessage,
    this.posts,
  });

  Data copyWith({
    int? totalPost,
    int? totalView,
    int? totalWish,
    int? totalMessage,
    List<Post>? posts,
  }) =>
      Data(
        totalPost: totalPost ?? this.totalPost,
        totalView: totalView ?? this.totalView,
        totalWish: totalWish ?? this.totalWish,
        totalMessage: totalMessage ?? this.totalMessage,
        posts: posts ?? this.posts,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalPost: json["total_post"],
    totalView: json["total_view"],
    totalWish: json["total_wish"],
    totalMessage: json["total_message"],
    posts: json["posts"] == null ? [] : List<Post>.from(json["posts"]!.map((x) => Post.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_post": totalPost,
    "total_view": totalView,
    "total_wish": totalWish,
    "total_message": totalMessage,
    "posts": posts == null ? [] : List<dynamic>.from(posts!.map((x) => x.toJson())),
  };
}

class Post {
  int? id;
  String? thumbnail;
  String? status;
  String? timeAgo;
  String? submitDate;
  int? totalView;
  int? totalWish;
  int? totalMessage;
  String? title;

  Post({
    this.id,
    this.thumbnail,
    this.status,
    this.timeAgo,
    this.submitDate,
    this.totalView,
    this.totalWish,
    this.totalMessage,
    this.title,
  });

  Post copyWith({
    int? id,
    String? thumbnail,
    String? status,
    String? timeAgo,
    String? submitDate,
    int? totalView,
    int? totalWish,
    int? totalMessage,
    String? title,
  }) =>
      Post(
        id: id ?? this.id,
        thumbnail: thumbnail ?? this.thumbnail,
        status: status ?? this.status,
        timeAgo: timeAgo ?? this.timeAgo,
        submitDate: submitDate ?? this.submitDate,
        totalView: totalView ?? this.totalView,
        totalWish: totalWish ?? this.totalWish,
        totalMessage: totalMessage ?? this.totalMessage,
        title: title ?? this.title,
      );

  factory Post.fromRawJson(String str) => Post.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json["id"],
    thumbnail: json["thumbnail"],
    status: json["status"],
    timeAgo: json["time_ago"],
    submitDate: json["submit_date"],
    totalView: json["total_view"],
    totalWish: json["total_wish"],
    totalMessage: json["total_message"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "thumbnail": thumbnail,
    "status": status,
    "time_ago": timeAgo,
    "submit_date": submitDate,
    "total_view": totalView,
    "total_wish": totalWish,
    "total_message": totalMessage,
    "title": title,
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
