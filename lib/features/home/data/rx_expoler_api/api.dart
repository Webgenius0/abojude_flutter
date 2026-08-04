import 'dart:convert';
import 'package:abojude_flutter/features/home/model/get_explore_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class GetExploreApi {
  static final GetExploreApi _singleton = GetExploreApi._internal();
  GetExploreApi._internal();
  static GetExploreApi get instance => _singleton;

  Future<GetExploreModel> getExploreApi({
    List<String>? categorySlugs,
    String? province,
    String? city,
    int? minPrice,
    int? maxPrice,
    String? sortBy,
    String? search,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      Response response = await getHttp(
        Endpoints.exploreList(
          categorySlugs: categorySlugs,
          province: province,
          city: city,
          minPrice: minPrice,
          maxPrice: maxPrice,
          sortBy: sortBy,
          search: search,
          page: page,
          perPage: perPage,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data =
            GetExploreModel.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
