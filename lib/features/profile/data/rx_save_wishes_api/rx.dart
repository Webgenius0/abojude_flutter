// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:abojude_flutter/features/profile/model/wishes_save_model.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import 'api.dart';

final class SaveWishesRx extends RxResponseInt<GetWhiesSavetModel> {
  final SaveWishesApi api = SaveWishesApi.instance;

  SaveWishesRx({
    required super.empty,
    required super.dataFetcher,
  });

  /// Loading state for the UI
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  /// Stream exposed to the UI
  ValueStream<GetWhiesSavetModel> get getFileData => dataFetcher.stream;

  Future<bool> save({
    required int postId,
  }) async {
    isLoading.value = true;

    try {
      final data = await api.save(
        postId: postId,
      );

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

      // Dio message fallback
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
      name: 'SaveWishesRx',
    );

    dataFetcher.sink.addError(error);
  }

  void dispose() {
    isLoading.dispose();
  }
}