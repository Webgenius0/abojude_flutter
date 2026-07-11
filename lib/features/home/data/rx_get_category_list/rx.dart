import 'dart:developer';
import 'package:abojude_flutter/features/home/model/get_category_list_model.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class GetCategoryListRx extends RxResponseInt<CategoryListModel> {
  final api = GetCategoryListApi.instance;

  GetCategoryListRx({required super.empty, required super.dataFetcher});

  ValueStream<CategoryListModel> get getCategoryListData => dataFetcher.stream;

  Future<CategoryListModel> getCategoryListRx() async {
    try {
      final data = await api.getCategoryListApi();
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
