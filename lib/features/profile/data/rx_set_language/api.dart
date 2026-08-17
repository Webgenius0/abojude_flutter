import 'dart:convert';
import 'package:abojude_flutter/features/profile/model/set_language_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class SetLanguageApi {
  static final SetLanguageApi _singleton = SetLanguageApi._internal();
  SetLanguageApi._internal();
  static SetLanguageApi get instance => _singleton;

  Future<SetLanguageModel> setLanguageApi({
    required String locale,
  }) async {
    try {
      Map<String, dynamic> body = {
        "locale": locale,
      };

      Response response = await postHttp(Endpoints.setLanguage(), body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = SetLanguageModel.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
