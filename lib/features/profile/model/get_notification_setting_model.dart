import 'dart:convert';

class GetNotificationModel {
    bool? status;
    String? message;
    int? code;
    Data? data;

    GetNotificationModel({
        this.status,
        this.message,
        this.code,
        this.data,
    });

    GetNotificationModel copyWith({
        bool? status,
        String? message,
        int? code,
        Data? data,
    }) => 
        GetNotificationModel(
            status: status ?? this.status,
            message: message ?? this.message,
            code: code ?? this.code,
            data: data ?? this.data,
        );

    factory GetNotificationModel.fromRawJson(String str) => GetNotificationModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetNotificationModel.fromJson(Map<String, dynamic> json) => GetNotificationModel(
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
    bool? allNotification;
    bool? newMessage;
    bool? marketing;
    bool? emailNotification;

    Data({
        this.allNotification,
        this.newMessage,
        this.marketing,
        this.emailNotification,
    });

    Data copyWith({
        bool? allNotification,
        bool? newMessage,
        bool? marketing,
        bool? emailNotification,
    }) => 
        Data(
            allNotification: allNotification ?? this.allNotification,
            newMessage: newMessage ?? this.newMessage,
            marketing: marketing ?? this.marketing,
            emailNotification: emailNotification ?? this.emailNotification,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        allNotification: json["all_notification"],
        newMessage: json["new_message"],
        marketing: json["marketing"],
        emailNotification: json["email_notification"],
    );

    Map<String, dynamic> toJson() => {
        "all_notification": allNotification,
        "new_message": newMessage,
        "marketing": marketing,
        "email_notification": emailNotification,
    };
}
