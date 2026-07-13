import 'dart:convert';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '/networks/endpoints.dart';

final class DeleteAccountApi {
  static final DeleteAccountApi _singleton = DeleteAccountApi._internal();
  DeleteAccountApi._internal();
  static DeleteAccountApi get instance => _singleton;

  Future<Map> deleteAccount({required String password}) async {
    try {
      final Map<String, dynamic> body = {
        'password': password,
      };
      Response response = await postHttp(Endpoints.deleteAccount(), body);

      if (response.statusCode == 200) {
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
