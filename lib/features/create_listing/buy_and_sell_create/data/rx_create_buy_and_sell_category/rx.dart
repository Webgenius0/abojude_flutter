import 'dart:developer';
import 'dart:io';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/model/buy_and_sell_category_post_create_model.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class CreateBuyAndSellCategoryRx
    extends RxResponseInt<BuyAndSellCategoryPostCreateModel> {
  final api = CreateBuyAndSellCategoryApi.instance;

  CreateBuyAndSellCategoryRx({required super.empty, required super.dataFetcher});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream<BuyAndSellCategoryPostCreateModel> get createCategoryData =>
      dataFetcher.stream;

  Future<BuyAndSellCategoryPostCreateModel> createBuyAndSellCategory({
    required String categorySlug,
    String? title,
    String? description,
    String? price,
    List<String>? condition,
    String? province,
    String? city,
    String? address,
    String? phone,
    String? whatsapp,
    String? email,
    int? isAppChat,
    List<File>? photos,
  }) async {
    isLoading.value = true;
    try {
      final data = await api.createBuyAndSellCategoryApi(
        categorySlug: categorySlug,
        title: title,
        description: description,
        price: price,
        condition: condition,
        province: province,
        city: city,
        address: address,
        phone: phone,
        whatsapp: whatsapp,
        email: email,
        isAppChat: isAppChat,
        photos: photos,
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
