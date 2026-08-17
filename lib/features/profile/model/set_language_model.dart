import 'dart:convert';

class SetLanguageModel {
  bool? status;
  String? message;
  int? code;

  SetLanguageModel({
    this.status,
    this.message,
    this.code,
  });

  SetLanguageModel copyWith({
    bool? status,
    String? message,
    int? code,
  }) =>
      SetLanguageModel(
        status: status ?? this.status,
        message: message ?? this.message,
        code: code ?? this.code,
      );

  factory SetLanguageModel.fromRawJson(String str) => SetLanguageModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SetLanguageModel.fromJson(Map<String, dynamic> json) => SetLanguageModel(
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
