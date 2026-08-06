import 'dart:developer';
 import 'package:abojude_flutter/features/message_screeen/model/get_all_message_resposn_model.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import 'api.dart';

final class GetAllMessageRx
    extends RxResponseInt<GetAllMessageResponseModel> {
  final GetAllMessageApi api = GetAllMessageApi.instance;

  GetAllMessageRx({
    required super.empty,
    required super.dataFetcher,
  });

  /// Loading state
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  /// Stream exposed to UI
  ValueStream<GetAllMessageResponseModel> get messages =>
      dataFetcher.stream;

  Future<GetAllMessageResponseModel> getMessages({
    required int conversationId,
  }) async {
    isLoading.value = true;

    try {
      final data = await api.getMessages(
        conversationId: conversationId,
      );

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
        final errors = responseData['errors'];

        if (errors is Map && errors.isNotEmpty) {
          final firstError = errors.values.first;

          if (firstError is List && firstError.isNotEmpty) {
            ToastUtil.showShortToast(firstError.first.toString());
            _addError(error);
            return;
          }
        }

        final message = responseData['message'];

        if (message != null && message.toString().trim().isNotEmpty) {
          ToastUtil.showShortToast(message.toString());
          _addError(error);
          return;
        }
      }

      if (error.message?.isNotEmpty ?? false) {
        ToastUtil.showShortToast(error.message!);
      }
    } else {
      ToastUtil.showShortToast(
        "Something went wrong. Please try again.",
      );
    }

    _addError(error);
  }

  void _addError(dynamic error) {
    log(
      error.toString(),
      name: 'GetAllMessageRx',
    );

    dataFetcher.sink.addError(error);
  }

  @override
  void dispose() {
    isLoading.dispose();
    super.dispose();
  }
}