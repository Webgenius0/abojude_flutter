import 'dart:convert';

class ReportPostModel {
    bool? status;
    String? message;
    int? code;
    Data? data;

    ReportPostModel({
        this.status,
        this.message,
        this.code,
        this.data,
    });

    ReportPostModel copyWith({
        bool? status,
        String? message,
        int? code,
        Data? data,
    }) => 
        ReportPostModel(
            status: status ?? this.status,
            message: message ?? this.message,
            code: code ?? this.code,
            data: data ?? this.data,
        );

    factory ReportPostModel.fromRawJson(String str) => ReportPostModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ReportPostModel.fromJson(Map<String, dynamic> json) => ReportPostModel(
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
    int? postId;
    String? reportType;
    String? reason;
    String? otherNote;
    DateTime? updatedAt;
    DateTime? createdAt;
    int? id;

    Data({
        this.userId,
        this.postId,
        this.reportType,
        this.reason,
        this.otherNote,
        this.updatedAt,
        this.createdAt,
        this.id,
    });

    Data copyWith({
        int? userId,
        int? postId,
        String? reportType,
        String? reason,
        String? otherNote,
        DateTime? updatedAt,
        DateTime? createdAt,
        int? id,
    }) => 
        Data(
            userId: userId ?? this.userId,
            postId: postId ?? this.postId,
            reportType: reportType ?? this.reportType,
            reason: reason ?? this.reason,
            otherNote: otherNote ?? this.otherNote,
            updatedAt: updatedAt ?? this.updatedAt,
            createdAt: createdAt ?? this.createdAt,
            id: id ?? this.id,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        postId: json["post_id"],
        reportType: json["report_type"],
        reason: json["reason"],
        otherNote: json["other_note"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "post_id": postId,
        "report_type": reportType,
        "reason": reason,
        "other_note": otherNote,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
    };
}
