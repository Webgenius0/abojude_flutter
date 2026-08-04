import 'dart:convert';

import 'package:abojude_flutter/features/profile/model/wishes_save_model.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/endpoints.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';

final class SaveWishesApi {
  SaveWishesApi._();

  static final SaveWishesApi instance = SaveWishesApi._();

  Future<GetWhiesSavetModel> save({
    required int postId,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "post_id": postId,
      };

      final Response response = await postHttp(
        Endpoints.saveWishe(),
        body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final model = GetWhiesSavetModel.fromRawJson(
          jsonEncode(response.data),
        );

        ToastUtil.showShortToast(
          model.message ?? "Wishlist updated successfully.",
        );

        return model;
      }

      throw DataSource.DEFAULT.getFailure();
    } on DioException {
      rethrow;
    } catch (_) {
      throw DataSource.DEFAULT.getFailure();
    }
  }
}