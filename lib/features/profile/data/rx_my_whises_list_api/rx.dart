import 'dart:developer';

import 'package:abojude_flutter/features/profile/model/get_wishes_list_model.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import 'api.dart';

final class GetWishesListRx extends RxResponseInt<GetWishListModel> {
  final GetWishesListApi api = GetWishesListApi.instance;

  GetWishesListRx({
    required super.empty,
    required super.dataFetcher,
  });

  /// Loading state for the UI
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  /// Stream exposed to the UI
  ValueStream<GetWishListModel> get getProfileData => dataFetcher.stream;

  Future<GetWishListModel> getWishesList() async {
    isLoading.value = true;

    try {
      final data = await api.getWishesList();

      // Optional success message from backend
      if (data.message?.isNotEmpty ?? false) {
        ToastUtil.showShortToast(data.message!);
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
  void handleErrorWithReturn(dynamic error) {
    if (error is DioException) {
      final responseData = error.response?.data;

      if (responseData is Map<String, dynamic>) {
        // Laravel validation errors
        final errors = responseData['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final firstError = errors.values.first;

          if (firstError is List && firstError.isNotEmpty) {
            ToastUtil.showShortToast(firstError.first.toString());
            _addError(error);
            return;
          }
        }

        // General API message
        final message = responseData['message'];
        if (message != null && message.toString().trim().isNotEmpty) {
          ToastUtil.showShortToast(message.toString());
          _addError(error);
          return;
        }
      }

      // Dio exception message fallback
      if (error.message?.isNotEmpty ?? false) {
        ToastUtil.showShortToast(error.message!);
      }
    } else {
      ToastUtil.showShortToast("Something went wrong. Please try again.");
    }

    _addError(error);
  }

  void _addError(dynamic error) {
    log(
      error.toString(),
      name: 'GetWishesListRx',
    );

    dataFetcher.sink.addError(error);
  }

  void dispose() {
    isLoading.dispose();
  }
}