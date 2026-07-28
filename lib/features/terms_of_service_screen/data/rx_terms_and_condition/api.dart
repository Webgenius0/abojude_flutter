import 'dart:convert';
import 'package:abojude_flutter/features/terms_of_service_screen/model/terms_and_condition_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class TermsAndConditionApi {
  static final TermsAndConditionApi _singleton = TermsAndConditionApi._internal();
  TermsAndConditionApi._internal();
  static TermsAndConditionApi get instance => _singleton;

  Future<TermsAndConditionModel> getTermsAndConditionApi(String slug) async {
    try {
      Response response = await getHttp(Endpoints.termsAndService(slug));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = TermsAndConditionModel.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
