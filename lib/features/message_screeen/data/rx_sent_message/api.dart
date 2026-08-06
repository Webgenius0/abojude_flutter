import 'dart:convert';
import 'dart:io';
import 'package:abojude_flutter/features/message_screeen/model/post_sent_model.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class PostSentMessageApi {
  static final PostSentMessageApi _singleton = PostSentMessageApi._internal();
  PostSentMessageApi._internal();
  static PostSentMessageApi get instance => _singleton;

  Future<PostSentMessageModel> sent({
    int? receiverId,
    required String message,
    required int postId,
    File? attachment,
  }) async {
    try {
      final Map<String, dynamic> map = {
        if (receiverId != null) "receiver_id": receiverId,
        "post_id": postId,
        "message": message,
      };

      if (attachment != null && attachment.path.isNotEmpty && await attachment.exists()) {
        map["attachment"] = await MultipartFile.fromFile(
          attachment.path,
          filename: attachment.path.split('/').last,
        );
      }

      final formData = FormData.fromMap(map);

      Response response = await postHttp(
        Endpoints.sentMessage(),
        formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = PostSentMessageModel.fromRawJson(
          jsonEncode(response.data),
        );

        ToastUtil.showShortToast(
          response.data['message'] ?? '',
        );

        return data;
      }

      throw DataSource.DEFAULT.getFailure();
    } catch (e) {
      rethrow;
    }
  }
}
