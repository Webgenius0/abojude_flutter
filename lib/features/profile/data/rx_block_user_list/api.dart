import 'dart:convert';
import 'package:abojude_flutter/features/profile/model/block_user_list_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class BlockUserListApi {
  static final BlockUserListApi _singleton = BlockUserListApi._internal();
  BlockUserListApi._internal();
  static BlockUserListApi get instance => _singleton;

  Future<BlockUserListModel> getBlockUserListApi() async {
    try {
      Response response = await getHttp(Endpoints.blockUserList());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = BlockUserListModel.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
