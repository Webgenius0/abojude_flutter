import 'dart:developer';
import 'package:abojude_flutter/features/home/model/get_explore_model.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class GetExploreRx extends RxResponseInt<GetExploreModel> {
  final api = GetExploreApi.instance;

  GetExploreRx({required super.empty, required super.dataFetcher});

  ValueStream<GetExploreModel> get getExploreData => dataFetcher.stream;

  Future<GetExploreModel> getExploreRx({
    List<String>? categorySlugs,
    String? province,
    String? city,
    int? minPrice,
    int? maxPrice,
    String? sortBy,
    String? search,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final data = await api.getExploreApi(
        categorySlugs: categorySlugs,
        province: province,
        city: city,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sortBy: sortBy,
        search: search,
        page: page,
        perPage: perPage,
      );
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
