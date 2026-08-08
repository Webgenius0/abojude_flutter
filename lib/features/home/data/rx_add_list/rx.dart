import 'dart:developer';
import 'package:abojude_flutter/features/home/model/add_list_model.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class AdsListRx extends RxResponseInt<AddListModel> {
  final api = AdsListApi.instance;

  AdsListRx({required super.empty, required super.dataFetcher});

  ValueStream<AddListModel> get getAdsListData => dataFetcher.stream;

  Future<AddListModel> getAdsListRx() async {
    try {
      final data = await api.getAdsListApi();
      handleSuccessWithReturn(data);
      return data;
    } catch (error) {
      handleErrorWithReturn(error);
      rethrow;
    }
  }

  @override
  handleErrorWithReturn(dynamic error) {
    log(error.toString());
    dataFetcher.sink.addError(error);
  }
}
