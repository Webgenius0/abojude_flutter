import 'dart:convert';
import 'package:abojude_flutter/features/profile/model/get_notification_setting_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class GetNotificationSettingApi {
  static final GetNotificationSettingApi _singleton = GetNotificationSettingApi._internal();
  GetNotificationSettingApi._internal();
  static GetNotificationSettingApi get instance => _singleton;

  Future<GetNotificationModel> getNotificationSettingApi() async {
    try {
      Response response = await getHttp(Endpoints.getNotificationSetting());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = GetNotificationModel.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<GetNotificationModel> updateNotificationSettingApi({
    required bool allNotification,
    required bool newMessage,
    required bool marketing,
    required bool emailNotification,
  }) async {
    try {
      final payload = {
        "all_notification": allNotification ? 1 : 0,
        "new_message": newMessage ? 1 : 0,
        "marketing": marketing ? 1 : 0,
        "email_notification": emailNotification ? 1 : 0,
      };

      Response response = await postHttp(Endpoints.getNotificationSetting(), payload);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = GetNotificationModel.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
