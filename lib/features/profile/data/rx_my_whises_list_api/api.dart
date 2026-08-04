
import 'package:abojude_flutter/features/profile/model/get_wishes_list_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/endpoints.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';

final class GetWishesListApi {
  GetWishesListApi._();

  static final GetWishesListApi instance = GetWishesListApi._();

  Future<GetWishListModel> getWishesList() async {
    try {
      final Response response = await getHttp(Endpoints.wishesList());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return GetWishListModel.fromJson(response.data);
      }

      throw DataSource.DEFAULT.getFailure();
    } on DioException {
      rethrow;
    } catch (_) {
      throw DataSource.DEFAULT.getFailure();
    }
  }
}