import 'dart:convert';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class BlockUserApi {
  static final BlockUserApi _singleton = BlockUserApi._internal();
  BlockUserApi._internal();
  static BlockUserApi get instance => _singleton;

  Future<Map> blockUserApi({required int id}) async {
    try {
      final Map<String, dynamic> body = {'user_id': id};
      Response response = await postHttp(Endpoints.blockUser(), body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
