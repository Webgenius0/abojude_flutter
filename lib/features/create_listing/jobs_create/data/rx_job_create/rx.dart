import 'dart:developer';
import 'dart:io';
import 'package:abojude_flutter/features/create_listing/jobs_create/model/job_post_create_model.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class CreateJobRx extends RxResponseInt<JobPostCreateModel> {
  final api = CreateJobApi.instance;

  CreateJobRx({required super.empty, required super.dataFetcher});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream<JobPostCreateModel> get createJobData => dataFetcher.stream;

  Future<JobPostCreateModel> createJob({
    required String categorySlug,
    String? title,
    String? companyName,
    String? description,
    List<String>? jobType,
    String? province,
    String? city,
    String? address,
    String? phone,
    String? whatsapp,
    String? email,
    int? isAppChat,
    File? thumbnail,
  }) async {
    isLoading.value = true;
    try {
      final data = await api.createJobApi(
        categorySlug: categorySlug,
        title: title,
        companyName: companyName,
        description: description,
        jobType: jobType,
        province: province,
        city: city,
        address: address,
        phone: phone,
        whatsapp: whatsapp,
        email: email,
        isAppChat: isAppChat,
        thumbnail: thumbnail,
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
