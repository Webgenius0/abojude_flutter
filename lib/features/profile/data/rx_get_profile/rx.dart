import 'dart:developer';
import 'package:abojude_flutter/features/profile/data/rx_get_profile/api.dart';
import 'package:abojude_flutter/features/profile/model/get_profile_model.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

final class GetProfileRx extends RxResponseInt<GetProfileModel> {
  final api = GetProfileApi.instance;

  GetProfileRx({required super.empty, required super.dataFetcher});

  /// Exposed so the UI can listen to loading state via ValueListenableBuilder.
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream<GetProfileModel> get getProfileData => dataFetcher.stream;

  Future<GetProfileModel> getProfile() async {
    isLoading.value = true;
    try {
      final data = await api.getProfileApi();

      if (data.message != null && data.message!.isNotEmpty) {
        ToastUtil.showShortToast(data.message!);
      } else {
        ToastUtil.showShortToast("User profile retrieved successfully.");
      }

      handleSuccessWithReturn(data);
      return data;
    } catch (error) {
      handleErrorWithReturn(error);
      rethrow;
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
