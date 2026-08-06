import 'package:abojude_flutter/features/message_screeen/model/get_all_message_resposn_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/endpoints.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';

final class GetAllMessageApi {
  GetAllMessageApi._();

  static final GetAllMessageApi instance = GetAllMessageApi._();

  Future<GetAllMessageResponseModel> getMessages({
    required int conversationId,
  }) async {
    try {
      final Response response = await getHttp(
        Endpoints.getConversationMessages(conversationId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return GetAllMessageResponseModel.fromJson(response.data);
      }

      throw DataSource.DEFAULT.getFailure();
    } on DioException {
      rethrow;
    } catch (_) {
      throw DataSource.DEFAULT.getFailure();
    }
  }
}