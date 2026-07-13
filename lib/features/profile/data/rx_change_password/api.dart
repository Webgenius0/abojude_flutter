import 'dart:convert';
import 'package:abojude_flutter/features/profile/model/change_password_model.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '/networks/endpoints.dart';

final class ChangePasswordApi {
  static final ChangePasswordApi _singleton = ChangePasswordApi._internal();
  ChangePasswordApi._internal();
  static ChangePasswordApi get instance => _singleton;

  Future<ChangePasswordModel> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'current_password': currentPassword,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      };
      
      Response response = await postHttp(Endpoints.changePassword(), body);

      if (response.statusCode == 200) {
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
