import 'dart:developer';
import 'dart:io';
import 'package:abojude_flutter/features/create_listing/services_create/model/service_post_create_model.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class CreateServiceRx extends RxResponseInt<ServicePostCreateModel> {
  final api = CreateServiceApi.instance;

  CreateServiceRx({required super.empty, required super.dataFetcher});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream<ServicePostCreateModel> get createServiceData => dataFetcher.stream;

  Future<ServicePostCreateModel> createService({
    required int categoryId,
    String? title,
    String? description,
    List<String>? serviceArea,
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
      final data = await api.createServiceApi(
        categoryId: categoryId,
        title: title,
        description: description,
        serviceArea: serviceArea,
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
