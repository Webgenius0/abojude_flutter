import 'dart:developer';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/model/buy_and_sell_post_create_model.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class CreateListingAfterDraftRx
    extends RxResponseInt<BuyAndSellPostCreateModel> {
  final api = CreateListingAfterDraftApi.instance;

  CreateListingAfterDraftRx({required super.empty, required super.dataFetcher});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream<BuyAndSellPostCreateModel> get getPostCreateData =>
      dataFetcher.stream;

  Future<BuyAndSellPostCreateModel> createPost(
    // { required String categorySlug,}
  ) async {
    isLoading.value = true;
    try {
      final data = await api.createPost(
        // categorySlug: categorySlug
        
        );
      handleSuccessWithReturn(data);
      return data;
    } catch (error) {
      handleErrorWithReturn(error);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  handleErrorWithReturn(dynamic error) {
    log(error.toString());
    dataFetcher.sink.addError(error);
  }
}
