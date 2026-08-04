import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:abojude_flutter/features/message_screeen/model/get_all_mesage_list_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/endpoints.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';

final class GetAllChatListApi {
  GetAllChatListApi._();

  static final GetAllChatListApi instance = GetAllChatListApi._();

  Future<GetMessageListModel> list() async {
    try {
      final Response response = await getHttp(
        Endpoints.chatList(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return GetMessageListModel.fromRawJson(
          jsonEncode(response.data),
        );
      }

      throw DataSource.DEFAULT.getFailure();
    } catch (_) {
      rethrow;
    }
  }
}