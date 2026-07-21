import 'dart:developer';
import 'dart:io';
import 'package:abojude_flutter/features/profile/data/rx_edit_profile/api.dart';
import 'package:abojude_flutter/features/profile/model/edit_profile_model.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/streams.dart';

final class EditProfileRx extends RxResponseInt<EditProfileModel> {
  final api = EditProfileApi.instance;

  EditProfileRx({required super.empty, required super.dataFetcher});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream<EditProfileModel> get editProfileData => dataFetcher.stream;

  Future<bool> editProfileRx({
    String? name,
    String? province,
    String? city,
    File? avatar,
  }) async {
    isLoading.value = true;
    try {
      final data = await api.editProfileApi(
        name: name,
        province: province,
        city: city,
        avatar: avatar,
      );

      if (data.message != null && data.message!.isNotEmpty) {
        ToastUtil.showShortToast(data.message!);
      } else {
        ToastUtil.showShortToast("User profile updated successfully.");
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
