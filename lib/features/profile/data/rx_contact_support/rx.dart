import 'dart:developer';
import 'dart:io';
import 'package:abojude_flutter/features/profile/data/rx_contact_support/api.dart';
import 'package:abojude_flutter/features/profile/model/contact_support_model.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/streams.dart';

final class ContactSupportRx extends RxResponseInt<ContactSupportModel> {
  final api = ContactSupportApi.instance;

  ContactSupportRx({required super.empty, required super.dataFetcher});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream<ContactSupportModel> get contactSupportData => dataFetcher.stream;

  Future<bool> contactSupportRx({
    required String email,
    required String describeIssue,
    String? subject,
    File? attachment,
  }) async {
    isLoading.value = true;
    try {
      final data = await api.contactSupportApi(
        email: email,
        describeIssue: describeIssue,
        subject: subject,
        attachment: attachment,
      );

      if (data.message != null && data.message!.isNotEmpty) {
        ToastUtil.showShortToast(data.message!);
      } else {
        ToastUtil.showShortToast("Support request submitted successfully.");
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
