import 'dart:convert';
import 'package:abojude_flutter/features/auth/register/model/select_location_for_guest_user_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class SelectLocationForGuestApi {
  static final SelectLocationForGuestApi _singleton = SelectLocationForGuestApi._internal();
  SelectLocationForGuestApi._internal();
  static SelectLocationForGuestApi get instance => _singleton;

  Future<SelectLocationForGuestUserModel> selectLocationForGuestApi({
    required String guestToken,
    required String province,
    required String city,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "guest_token": guestToken,
        "province": province,
        "city": city,
      };

      Response response = await postHttp(Endpoints.selectLocationForAuthUser(), data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = SelectLocationForGuestUserModel.fromRawJson(json.encode(response.data));
        return resData;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
