import 'dart:convert';

class ContactSupportModel {
    bool? status;
    String? message;
    int? code;
    Data? data;

    ContactSupportModel({
        this.status,
        this.message,
        this.code,
        this.data,
    });

    ContactSupportModel copyWith({
        bool? status,
        String? message,
        int? code,
        Data? data,
    }) => 
        ContactSupportModel(
            status: status ?? this.status,
            message: message ?? this.message,
            code: code ?? this.code,
            data: data ?? this.data,
        );

    factory ContactSupportModel.fromRawJson(String str) => ContactSupportModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ContactSupportModel.fromJson(Map<String, dynamic> json) => ContactSupportModel(
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
    String? email;
    String? subject;
    String? describeIssue;
    dynamic attachment;
    DateTime? updatedAt;
    DateTime? createdAt;
    int? id;

    Data({
        this.email,
        this.subject,
        this.describeIssue,
        this.attachment,
        this.updatedAt,
        this.createdAt,
        this.id,
    });

    Data copyWith({
        String? email,
        String? subject,
        String? describeIssue,
        dynamic attachment,
        DateTime? updatedAt,
        DateTime? createdAt,
        int? id,
    }) => 
        Data(
            email: email ?? this.email,
            subject: subject ?? this.subject,
            describeIssue: describeIssue ?? this.describeIssue,
            attachment: attachment ?? this.attachment,
            updatedAt: updatedAt ?? this.updatedAt,
            createdAt: createdAt ?? this.createdAt,
            id: id ?? this.id,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        email: json["email"],
        subject: json["subject"],
        describeIssue: json["describe_issue"],
        attachment: json["attachment"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "subject": subject,
        "describe_issue": describeIssue,
        "attachment": attachment,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
    };
}
