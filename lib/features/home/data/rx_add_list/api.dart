import 'dart:convert';
import 'package:abojude_flutter/features/home/model/add_list_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class AdsListApi {
  static final AdsListApi _singleton = AdsListApi._internal();
  AdsListApi._internal();
  static AdsListApi get instance => _singleton;

  Future<AddListModel> getAdsListApi() async {
    try {
      Response response = await getHttp(
        Endpoints.adsList(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data =
            AddListModel.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
