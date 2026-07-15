import 'dart:convert';
import 'package:abojude_flutter/features/auth/register/model/get_city_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class GetCityApi {
  static final GetCityApi _singleton = GetCityApi._internal();
  GetCityApi._internal();
  static GetCityApi get instance => _singleton;

  Future<GetCityModel> getCityApi(String province) async {
    try {
      Response response = await getHttp(Endpoints.getCitiesList(province));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = GetCityModel.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
