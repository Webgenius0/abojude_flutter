import 'dart:developer';

import 'package:rxdart/rxdart.dart';

import 'package:abojude_flutter/features/message_screeen/model/get_all_mesage_list_model.dart';
import 'package:abojude_flutter/networks/rx_base.dart';

import 'api.dart';

final class GetAllChatListRx extends RxResponseInt<GetMessageListModel> {
  final GetAllChatListApi api = GetAllChatListApi.instance;

  GetAllChatListRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<GetMessageListModel> get getCategoryListData =>
      dataFetcher.stream;

  Future<GetMessageListModel> list() async {
    try {
      final data = await api.list();
      handleSuccessWithReturn(data);
      return data;
    } catch (error) {
      handleErrorWithReturn(error);
      rethrow;
    }
  }

  @override
  void handleErrorWithReturn(dynamic error) {
    log(error.toString());
    dataFetcher.sink.addError(error);
  }
}