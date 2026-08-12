import 'dart:developer';
import 'package:abojude_flutter/features/home/model/recent_post_list_model.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:abojude_flutter/features/home/data/rx_expoler_api/api.dart';
import 'api.dart';

final class GetRecentPostListRx extends RxResponseInt<RecentPostListModel> {
  final api = GetRecentPostListApi.instance;

  GetRecentPostListRx({required super.empty, required super.dataFetcher});

  ValueStream<RecentPostListModel> get getRecentPostListData =>
      dataFetcher.stream;

  Future<RecentPostListModel> getRecentPostListRx() async {
    try {
      final data = await api.getRecentPostListApi();
      handleSuccessWithReturn(data);
      return data;
    } catch (error) {
      handleErrorWithReturn(error);
      rethrow;
    }
  }

  Future<RecentPostListModel> filterRecentPostListRx({
    List<String>? categorySlugs,
    String? province,
    String? city,
    int? minPrice,
    int? maxPrice,
    String? sortBy,
  }) async {
    try {
      final exploreData = await GetExploreApi.instance.getExploreApi(
        categorySlugs: categorySlugs,
        province: province,
        city: city,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sortBy: sortBy,
        page: 1,
        perPage: 20,
      );
      final rawJson = exploreData.toRawJson();
      final recentModel = RecentPostListModel.fromRawJson(rawJson);
      handleSuccessWithReturn(recentModel);
      return recentModel;
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
