import 'dart:convert';
import 'package:abojude_flutter/features/auth/register/model/register_verify_otp_model.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class RegisterVerifyOtpApi {
  static final RegisterVerifyOtpApi _singleton = RegisterVerifyOtpApi._internal();
  RegisterVerifyOtpApi._internal();
  static RegisterVerifyOtpApi get instance => _singleton;

  Future<RegisterVerifyOtpModel> registerVerifyOtpApi({
    required String email,
    required String otp,
    String type = "signup",
  }) async {
    try {
      final Map<String, dynamic> data = {
        "email": email,
        "otp": otp,
        "type": type,
      };

      Response response = await postHttp(Endpoints.verifyEmail(), data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = RegisterVerifyOtpModel.fromRawJson(json.encode(response.data));
        ToastUtil.showShortToast(response.data['message']);
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
