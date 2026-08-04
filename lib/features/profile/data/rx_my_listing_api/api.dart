
 import 'package:abojude_flutter/features/profile/model/my_listing_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/endpoints.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';

final class GetMyListApi {
  GetMyListApi._();

  static final GetMyListApi instance = GetMyListApi._();

  Future<GetMyListingModel> myList({int page = 1, int perPage = 10}) async {
    try {
      final Response response = await getHttp(Endpoints.getMyList(page: page, perPage: perPage));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return GetMyListingModel.fromJson(response.data);
      }

      throw DataSource.DEFAULT.getFailure();
    } on DioException {
      rethrow;
    } catch (_) {
      throw DataSource.DEFAULT.getFailure();
    }
  }
}