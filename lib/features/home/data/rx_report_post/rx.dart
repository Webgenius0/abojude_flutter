import 'dart:developer';
import 'package:abojude_flutter/features/home/model/report_post_model.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class ReportPostRx extends RxResponseInt<ReportPostModel> {
  final api = ReportPostApi.instance;

  ReportPostRx({required super.empty, required super.dataFetcher});

  ValueStream<ReportPostModel> get reportPostData => dataFetcher.stream;

  Future<ReportPostModel> reportPostRx({
    required int postId,
    required String reason,
    String? otherNote,
  }) async {
    try {
      final data = await api.reportPostApi(
        postId: postId,
        reason: reason,
        otherNote: otherNote,
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
