import 'dart:developer';
import 'package:abojude_flutter/features/auth/set_new_password/data/rx_set_new_password/api.dart';
import 'package:abojude_flutter/features/auth/set_new_password/model/set_new_password_model.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

final class SetNewPasswordRx extends RxResponseInt<ChangePasswordModel> {
  final api = SetNewPasswordApi.instance;

  SetNewPasswordRx({required super.empty, required super.dataFetcher});

  /// Exposed so the UI can listen to loading state via ValueListenableBuilder.
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> setNewPassword({
    required String email,
    required String password,
    required String passwordConfirmation,
    required String token,
  }) async {
    isLoading.value = true;
    try {
      final data = await api.setNewPassword(
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        token: token,
      );

      if (data.message != null && data.message!.isNotEmpty) {
        ToastUtil.showShortToast(data.message!);
      } else {
        ToastUtil.showShortToast("Password reset successfully.");
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
              return false;
            }
          }
        }

        final message = responseData['message'];
        if (message != null && message.toString().isNotEmpty) {
          ToastUtil.showShortToast(message.toString());
          log(error.toString());
          dataFetcher.sink.addError(error);
          return false;
        }
      }
    }
    log(error.toString());
    dataFetcher.sink.addError(error);
    return false;
  }
}
