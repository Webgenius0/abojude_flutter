import 'dart:developer';
import 'package:abojude_flutter/features/auth/login/data/rx_logout/api.dart';
import 'package:abojude_flutter/helpers/error_helper.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:abojude_flutter/networks/stream_cleaner.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:abojude_flutter/helpers/di.dart';
import 'package:abojude_flutter/constants/app_constants.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';

final class LogoutRx extends RxResponseInt<Map> {
  final api = LogOutApi.instance;

  LogoutRx({required super.empty, required super.dataFetcher});

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> logOut() async {
    try {
      Map data = await api.logOut();
      if (data.containsKey('message') && data['message'] != null) {
        ToastUtil.showShortToast(data['message'].toString());
      } else {
        ToastUtil.showShortToast("Successfully logged out.");
      }
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      handleErrorWithReturn(error);
      return false;
    } finally {
      await totalDataClean();
      await appData.remove(kKeyAccessToken);
      DioSingleton.instance.create();
    }
  }

  @override
  handleErrorWithReturn(dynamic error) {
    if (error is DioException) {
      final response = error.response;
      if (response != null) {
        ToastUtil.showShortToast(
          ErrorMessageHelper.extractMessage(response.data),
        );
      } else {
        ToastUtil.showShortToast("Network error. Please try again.");
      }
    } else {
      ToastUtil.showShortToast("An unexpected error occurred.");
    }
    log(error.toString());
    dataFetcher.sink.addError(error);
    return false;
  }
}
