import 'dart:developer';
import 'package:abojude_flutter/features/profile/data/update_notification_setting/api.dart';
import 'package:abojude_flutter/features/profile/model/update_notification_setting_model.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

final class UpdateNotificationSettingRx extends RxResponseInt<UpdateNotificationSettingsModel> {
  final api = UpdateNotificationSettingApi.instance;

  UpdateNotificationSettingRx({required super.empty, required super.dataFetcher});

  /// Exposed so the UI can listen to loading state via ValueListenableBuilder.
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream<UpdateNotificationSettingsModel> get updateNotificationSettingData => dataFetcher.stream;

  Future<bool> updateNotificationSetting({
    required bool allNotification,
    required bool newMessage,
    required bool marketing,
    required bool emailNotification,
  }) async {
    isLoading.value = true;
    try {
      final data = await api.updateNotificationSettingApi(
        allNotification: allNotification,
        newMessage: newMessage,
        marketing: marketing,
        emailNotification: emailNotification,
      );

      if (data.message != null && data.message!.isNotEmpty) {
        ToastUtil.showShortToast(data.message!);
      } else {
        ToastUtil.showShortToast("Notification settings updated successfully.");
      }

      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      handleErrorWithReturn(error);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  handleErrorWithReturn(dynamic error) {
    if (error is DioException) {
      final responseData = error.response?.data;
      if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('errors')) {
          final errorMap = responseData['errors'];
          if (errorMap is Map && errorMap.isNotEmpty) {
            final firstErrorList = errorMap.values.first;
            if (firstErrorList is List && firstErrorList.isNotEmpty) {
              ToastUtil.showShortToast(firstErrorList.first.toString());
              log(error.toString());
              dataFetcher.sink.addError(error);
              return;
            }
          }
        }

        final message = responseData['message'];
        if (message != null && message.toString().isNotEmpty) {
          ToastUtil.showShortToast(message.toString());
          log(error.toString());
          dataFetcher.sink.addError(error);
          return;
        }
      }
    }
    log(error.toString());
    dataFetcher.sink.addError(error);
  }
}
