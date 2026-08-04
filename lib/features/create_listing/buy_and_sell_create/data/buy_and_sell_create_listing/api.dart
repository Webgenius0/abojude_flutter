import 'dart:convert';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/model/buy_and_sell_post_create_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class BuyAndSellPostCreateApi {
  static final BuyAndSellPostCreateApi _singleton =
      BuyAndSellPostCreateApi._internal();
  BuyAndSellPostCreateApi._internal();
  static BuyAndSellPostCreateApi get instance => _singleton;

  Future<BuyAndSellPostCreateModel> createPost({
    required String categorySlug,
  }) async {
    try {
      Response response = await postHttp(Endpoints.postCreateDraft(), {
        "category_slug": categorySlug,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = BuyAndSellPostCreateModel.fromRawJson(
          json.encode(response.data),
        );
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
