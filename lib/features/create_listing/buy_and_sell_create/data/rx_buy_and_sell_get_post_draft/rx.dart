import 'dart:developer';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/model/buy_and_sell_get_post_draft_model.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class BuyAndSellGetPostDraftRx extends RxResponseInt<BuyAndSellGetPostDraftModel> {
  final api = BuyAndSellGetPostDraftApi.instance;

  BuyAndSellGetPostDraftRx({required super.empty, required super.dataFetcher});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream<BuyAndSellGetPostDraftModel> get getPostDraftData => dataFetcher.stream;

  Future<BuyAndSellGetPostDraftModel> getPostDraft({String categorySlug = "buy-sell"}) async {
    isLoading.value = true;
    try {
      final data = await api.getPostDraft(categorySlug: categorySlug);
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
