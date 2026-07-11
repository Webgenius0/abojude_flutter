import 'dart:convert';
import 'package:abojude_flutter/features/auth/register/model/resend_otp_model.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class ResendOtpApi {
  static final ResendOtpApi _singleton = ResendOtpApi._internal();
  ResendOtpApi._internal();
  static ResendOtpApi get instance => _singleton;

  Future<ResendOtpModel> resendOtpApi({
    required String email,
    required String type,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "email": email,
        "type": type,
      };

      Response response = await postHttp(Endpoints.resendOtp(), data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = ResendOtpModel.fromRawJson(json.encode(response.data));
        ToastUtil.showShortToast(response.data['message'] ?? 'Verification code has been resent to your email address.');
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
