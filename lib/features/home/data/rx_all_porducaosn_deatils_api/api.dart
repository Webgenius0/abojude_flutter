import 'dart:convert';
import 'package:abojude_flutter/features/home/model/get_post_details_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class GetPostDetailsApi {
  static final GetPostDetailsApi _singleton = GetPostDetailsApi._internal();
  GetPostDetailsApi._internal();
  static GetPostDetailsApi get instance => _singleton;

  Future<GetPostDetailsModel> getPostDetailsApi(int postId) async {
    try {
      Response response = await getHttp(
        Endpoints.postDetails(postId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data =
            GetPostDetailsModel.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
