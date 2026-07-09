import 'dart:convert';
import 'package:abojude_flutter/features/auth/login/model/login_model.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class LoginApi {
  static final LoginApi _singleton = LoginApi._internal();
  LoginApi._internal();
  static LoginApi get instance => _singleton;

  Future<LoginModel> loginApi({
    required String email,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "email": email,
        "password": password,
      };

      Response response = await postHttp(Endpoints.login(), data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = LoginModel.fromRawJson(json.encode(response.data));
        ToastUtil.showShortToast(response.data['message'] ?? 'Login successful!');
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
