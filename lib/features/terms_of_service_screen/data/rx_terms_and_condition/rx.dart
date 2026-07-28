import 'dart:developer';
import 'package:abojude_flutter/features/terms_of_service_screen/data/rx_terms_and_condition/api.dart';
import 'package:abojude_flutter/features/terms_of_service_screen/model/terms_and_condition_model.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

final class TermsAndConditionRx extends RxResponseInt<TermsAndConditionModel> {
  final api = TermsAndConditionApi.instance;

  TermsAndConditionRx({required super.empty, required super.dataFetcher});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream<TermsAndConditionModel> get getTermsAndConditionData => dataFetcher.stream;

  Future<TermsAndConditionModel> getTermsAndCondition(String slug) async {
    isLoading.value = true;
    try {
      final data = await api.getTermsAndConditionApi(slug);
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
