import 'dart:convert';
import 'package:abojude_flutter/features/home/model/report_post_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class ReportPostApi {
  static final ReportPostApi _singleton = ReportPostApi._internal();
  ReportPostApi._internal();
  static ReportPostApi get instance => _singleton;

  Future<ReportPostModel> reportPostApi({
    required int postId,
    required String reason,
    String? otherNote,
  }) async {
    try {
      final body = {
        "post_id": postId,
        "reason": reason,
        if (otherNote != null) "other_note": otherNote,
      };

      Response response = await postHttp(
        Endpoints.postReport(),
        body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = ReportPostModel.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
