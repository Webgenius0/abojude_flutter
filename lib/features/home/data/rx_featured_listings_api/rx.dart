import 'dart:developer';
import 'package:abojude_flutter/features/home/model/get_featured_listings_model.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class GetFeaturedListingsRx
    extends RxResponseInt<GetFeaturedListingsModel> {
  final api = GetFeaturedListingsApi.instance;

  GetFeaturedListingsRx({required super.empty, required super.dataFetcher});

  ValueStream<GetFeaturedListingsModel> get getFeaturedListingsData =>
      dataFetcher.stream;

  Future<GetFeaturedListingsModel> getFeaturedListingsRx({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final data = await api.getFeaturedListingsApi(
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
