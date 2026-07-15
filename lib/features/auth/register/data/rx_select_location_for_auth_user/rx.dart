import 'dart:developer';
import 'package:abojude_flutter/features/auth/register/model/select_location_for_auth_user_model.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/streams.dart';
import 'api.dart';

final class SelectLocationForAuthUserRx extends RxResponseInt<SelectLocationForAuthUserModel> {
  final api = SelectLocationForAuthUserApi.instance;

  SelectLocationForAuthUserRx({required super.empty, required super.dataFetcher});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream<SelectLocationForAuthUserModel> get getSelectLocationData => dataFetcher.stream;

  Future<bool> selectLocationForAuthUserRx({
    required String province,
    required String city,
  }) async {
    isLoading.value = true;
    try {
      final data = await api.selectLocationForAuthUserApi(
        province: province,
        city: city,
      );
      handleSuccessWithReturn(data);
      if (data.message != null && data.message!.isNotEmpty) {
        ToastUtil.showShortToast(data.message!);
      } else {
        ToastUtil.showShortToast("Location updated successfully.");
      }
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
