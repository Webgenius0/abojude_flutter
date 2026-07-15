import 'dart:convert';
import 'package:abojude_flutter/features/auth/register/model/get_province_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class GetProvinceApi {
  static final GetProvinceApi _singleton = GetProvinceApi._internal();
  GetProvinceApi._internal();
  static GetProvinceApi get instance => _singleton;

  Future<GetProvinceModel> getProvinceApi() async {
    try {
      Response response = await getHttp(Endpoints.getProvinceList());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = GetProvinceModel.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
