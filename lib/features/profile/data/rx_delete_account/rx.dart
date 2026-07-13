import 'dart:developer';
import 'package:abojude_flutter/features/profile/data/rx_delete_account/api.dart';
import 'package:abojude_flutter/helpers/error_helper.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:abojude_flutter/networks/stream_cleaner.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:abojude_flutter/helpers/di.dart';
import 'package:abojude_flutter/constants/app_constants.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:flutter/foundation.dart';

final class DeleteAccountRx extends RxResponseInt<Map> {
  final api = DeleteAccountApi.instance;

  DeleteAccountRx({required super.empty, required super.dataFetcher});

  /// Exposed so the UI can listen to loading state via ValueListenableBuilder.
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> deleteAccount({required String password}) async {
    isLoading.value = true;
    try {
      Map data = await api.deleteAccount(password: password);
      if (data.containsKey('message') && data['message'] != null) {
        ToastUtil.showShortToast(data['message'].toString());
      } else {
        ToastUtil.showShortToast("Account deleted successfully.");
      }
      
      // Clean session tokens and storage upon successful deletion
      await totalDataClean();
      await appData.remove(kKeyAccessToken);
      DioSingleton.instance.create();

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
