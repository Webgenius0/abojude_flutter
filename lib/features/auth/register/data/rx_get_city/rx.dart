import 'dart:developer';
import 'package:abojude_flutter/features/auth/register/model/get_city_model.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/streams.dart';
import 'api.dart';

final class GetCityRx extends RxResponseInt<GetCityModel> {
  final api = GetCityApi.instance;

  GetCityRx({required super.empty, required super.dataFetcher});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream<GetCityModel> get getCityData => dataFetcher.stream;

  Future<bool> getCityRx(String province) async {
    isLoading.value = true;
    try {
      final data = await api.getCityApi(province);
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
