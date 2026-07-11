import 'dart:convert';
import 'package:abojude_flutter/features/auth/guest_user/model/guest_user_model.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class GuestUserApi {
  static final GuestUserApi _singleton = GuestUserApi._internal();
  GuestUserApi._internal();
  static GuestUserApi get instance => _singleton;

  Future<GuestUserModel> guestUserApi() async {
    try {
      Response response = await postHttp(Endpoints.guestUser());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = GuestUserModel.fromRawJson(json.encode(response.data));
        ToastUtil.showShortToast(response.data['message'] ?? 'Guest session created successfully!');
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
