// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'package:abojude_flutter/constants/app_constants.dart';
import 'package:abojude_flutter/features/auth/guest_user/model/guest_user_model.dart';
import 'package:abojude_flutter/helpers/di.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class GuestUserRx extends RxResponseInt<GuestUserModel> {
  final api = GuestUserApi.instance;

  GuestUserRx({required super.empty, required super.dataFetcher});

  /// Exposed so the UI can listen to loading state via ValueListenableBuilder if needed.
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> guestUserRx() async {
    isLoading.value = true;
    try {
      final data = await api.guestUserApi();

      if (data.token != null && data.token!.isNotEmpty) {
        appData.write(kKeyAccessToken, data.token);
        appData.write(kKeyIsLoggedIn, true);
        DioSingleton.instance.update(data.token!);
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
