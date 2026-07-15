import 'dart:convert';

class GetProvinceModel {
  bool? status;
  String? message;
  int? code;
  List<String>? data;

  GetProvinceModel({this.status, this.message, this.code, this.data});

  GetProvinceModel copyWith({
    bool? status,
    String? message,
    int? code,
    List<String>? data,
  }) => GetProvinceModel(
    status: status ?? this.status,
    message: message ?? this.message,
    code: code ?? this.code,
    data: data ?? this.data,
  );

  factory GetProvinceModel.fromRawJson(String str) =>
      GetProvinceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetProvinceModel.fromJson(Map<String, dynamic> json) =>
      GetProvinceModel(
        status: json["status"],
        message: json["message"],
        code: json["code"],
        data: json["data"] == null
            ? []
            : List<String>.from(json["data"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "code": code,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
  };
}
