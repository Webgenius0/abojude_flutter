import 'dart:convert';
import 'package:abojude_flutter/features/home/model/get_featured_listings_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class GetFeaturedListingsApi {
  static final GetFeaturedListingsApi _singleton =
      GetFeaturedListingsApi._internal();
  GetFeaturedListingsApi._internal();
  static GetFeaturedListingsApi get instance => _singleton;

  Future<GetFeaturedListingsModel> getFeaturedListingsApi({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      Response response = await getHttp(
        Endpoints.getFeaturedListings(page: page, perPage: perPage),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data =
            GetFeaturedListingsModel.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
