import 'dart:convert';
import 'package:abojude_flutter/features/auth/forget_password/model/forget_password_model.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class ForgetPasswordApi {
  static final ForgetPasswordApi _singleton = ForgetPasswordApi._internal();
  ForgetPasswordApi._internal();
  static ForgetPasswordApi get instance => _singleton;

  Future<ForgetPasswordModel> forgetPasswordApi({
    required String email,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "email": email,
      };

      Response response = await postHttp(Endpoints.forgetPassword(), data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = ForgetPasswordModel.fromRawJson(json.encode(response.data));
        ToastUtil.showShortToast(response.data['message'] ?? 'Code sent successfully!');
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
