import 'dart:convert';
import 'package:abojude_flutter/features/auth/set_new_password/model/set_new_password_model.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '/networks/endpoints.dart';

final class SetNewPasswordApi {
  static final SetNewPasswordApi _singleton = SetNewPasswordApi._internal();
  SetNewPasswordApi._internal();
  static SetNewPasswordApi get instance => _singleton;

  Future<ChangePasswordModel> setNewPassword({
    required String email,
    required String password,
    required String passwordConfirmation,
    required String token,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'token': token,
      };

      Response response = await postHttp(Endpoints.setNewPassword(), body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = ChangePasswordModel.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
