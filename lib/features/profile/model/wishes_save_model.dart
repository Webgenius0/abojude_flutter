import 'dart:convert';

class GetWhiesSavetModel {
  bool? status;
  String? message;
  int? code;

  GetWhiesSavetModel({
    this.status,
    this.message,
    this.code,
  });

  GetWhiesSavetModel copyWith({
    bool? status,
    String? message,
    int? code,
  }) =>
      GetWhiesSavetModel(
        status: status ?? this.status,
        message: message ?? this.message,
        code: code ?? this.code,
      );

  factory GetWhiesSavetModel.fromRawJson(String str) => GetWhiesSavetModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetWhiesSavetModel.fromJson(Map<String, dynamic> json) => GetWhiesSavetModel(
    status: json["status"],
    message: json["message"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "code": code,
  };
}
