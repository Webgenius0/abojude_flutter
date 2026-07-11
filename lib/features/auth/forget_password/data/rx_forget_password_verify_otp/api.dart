import 'dart:convert';
import 'package:abojude_flutter/features/auth/forget_password/model/forget_password_verify_otp_model.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class ForgetPasswordVerifyOtpApi {
  static final ForgetPasswordVerifyOtpApi _singleton = ForgetPasswordVerifyOtpApi._internal();
  ForgetPasswordVerifyOtpApi._internal();
  static ForgetPasswordVerifyOtpApi get instance => _singleton;

  Future<ForgetPasswordVerifyOtpModel> forgetPasswordVerifyOtpApi({
    required String email,
    required String otp,
    String type = "forgot-password",
  }) async {
    try {
      final Map<String, dynamic> data = {
        "email": email,
        "otp": otp,
        "type": type,
      };

      Response response = await postHttp(Endpoints.forgetPasswordVerifyOtp(), data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = ForgetPasswordVerifyOtpModel.fromRawJson(json.encode(response.data));
        ToastUtil.showShortToast(response.data['message'] ?? 'OTP verified successfully!');
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
