import 'dart:developer';
import 'package:abojude_flutter/features/home/model/get_post_details_model.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class GetPostDetailsRx extends RxResponseInt<GetPostDetailsModel> {
  final api = GetPostDetailsApi.instance;

  GetPostDetailsRx({required super.empty, required super.dataFetcher});

  ValueStream<GetPostDetailsModel> get getPostDetailsData => dataFetcher.stream;

  Future<GetPostDetailsModel> getPostDetailsRx(int postId) async {
    try {
      final data = await api.getPostDetailsApi(postId);
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
