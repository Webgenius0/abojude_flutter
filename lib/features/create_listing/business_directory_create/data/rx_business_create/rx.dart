// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/widgets/business_listing_model.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/model/business_post_create_model.dart';
import 'api.dart';

final class CreateBusinessRx extends RxResponseInt<BusinessPostCreateModel> {
  final api = CreateBusinessApi.instance;

  CreateBusinessRx({required super.empty, required super.dataFetcher});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream<BusinessPostCreateModel> get createBusinessData => dataFetcher.stream;

  Future<BusinessPostCreateModel> createBusiness({
    required BusinessListingModel model,
  }) async {
    isLoading.value = true;
    try {
      final data = await api.createBusinessApi(model: model);
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
