import 'dart:convert';
import 'package:abojude_flutter/features/profile/model/update_notification_setting_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class UpdateNotificationSettingApi {
  static final UpdateNotificationSettingApi _singleton = UpdateNotificationSettingApi._internal();
  UpdateNotificationSettingApi._internal();
  static UpdateNotificationSettingApi get instance => _singleton;

  Future<UpdateNotificationSettingsModel> updateNotificationSettingApi({
    required bool allNotification,
    required bool newMessage,
    required bool marketing,
    required bool emailNotification,
  }) async {
    try {
      final Map<String, dynamic> payload = {
        "_method": "PUT",
        "all_notification": allNotification,
        "new_message": newMessage,
        "marketing": marketing,
        "email_notification": emailNotification,
      };

      Response response = await postHttp(Endpoints.updateNotificationSetting(), payload);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = UpdateNotificationSettingsModel.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
