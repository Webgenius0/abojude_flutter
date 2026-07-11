import 'dart:convert';
import 'package:abojude_flutter/features/home/model/recent_post_list_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class GetRecentPostListApi {
  static final GetRecentPostListApi _singleton = GetRecentPostListApi._internal();
  GetRecentPostListApi._internal();
  static GetRecentPostListApi get instance => _singleton;

  Future<RecentPostListModel> getRecentPostListApi() async {
    try {
      Response response = await getHttp(Endpoints.getRecentPostList());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = RecentPostListModel.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
