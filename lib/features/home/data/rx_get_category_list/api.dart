import 'dart:convert';
import 'package:abojude_flutter/features/home/model/get_category_list_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class GetCategoryListApi {
  static final GetCategoryListApi _singleton = GetCategoryListApi._internal();
  GetCategoryListApi._internal();
  static GetCategoryListApi get instance => _singleton;

  Future<CategoryListModel> getCategoryListApi() async {
    try {
      Response response = await getHttp(Endpoints.getCategoryList());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = CategoryListModel.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
