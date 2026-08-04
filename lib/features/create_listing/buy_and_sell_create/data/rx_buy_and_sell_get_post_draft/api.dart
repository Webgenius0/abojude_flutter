import 'dart:convert';
import 'dart:developer';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/model/buy_and_sell_get_post_draft_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class BuyAndSellGetPostDraftApi {
  static final BuyAndSellGetPostDraftApi _singleton = BuyAndSellGetPostDraftApi._internal();
  BuyAndSellGetPostDraftApi._internal();
  static BuyAndSellGetPostDraftApi get instance => _singleton;

  Future<BuyAndSellGetPostDraftModel> getPostDraft({String categorySlug = "buy-sell"}) async {
    try {
      Response response = await getHttp("${Endpoints.buyAndSellGetPostDraft()}?category_slug=$categorySlug");
      log("GET POST DRAFT RESPONSE: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = BuyAndSellGetPostDraftModel.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
