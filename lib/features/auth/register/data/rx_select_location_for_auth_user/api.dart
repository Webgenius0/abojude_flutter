import 'dart:convert';
import 'package:abojude_flutter/features/auth/register/model/select_location_for_auth_user_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class SelectLocationForAuthUserApi {
  static final SelectLocationForAuthUserApi _singleton = SelectLocationForAuthUserApi._internal();
  SelectLocationForAuthUserApi._internal();
  static SelectLocationForAuthUserApi get instance => _singleton;

  Future<SelectLocationForAuthUserModel> selectLocationForAuthUserApi({
    required String province,
    required String city,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "province": province,
        "city": city,
      };

      Response response = await postHttp(Endpoints.selectLocationForAuthUser(), data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = SelectLocationForAuthUserModel.fromRawJson(json.encode(response.data));
        return resData;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
