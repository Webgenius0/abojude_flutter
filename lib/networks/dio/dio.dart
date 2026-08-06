import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '/helpers/di.dart';
import '../../constants/app_constants.dart';
import '../endpoints.dart';
import 'log.dart';
import 'package:abojude_flutter/networks/stream_cleaner.dart';
import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:abojude_flutter/helpers/toast.dart';

final class DioSingleton {
  static final DioSingleton _singleton = DioSingleton._internal();
  static CancelToken cancelToken = CancelToken();
  static bool _isHandling401 = false;

  DioSingleton._internal();

  static DioSingleton get instance => _singleton;

  late Dio dio;

  Dio _createDio(BaseOptions options) {
    final dio = Dio(options);
    dio.interceptors.addAll([
      Logger(),
      InterceptorsWrapper(
        onError: (DioException e, handler) async {
          final responseData = e.response?.data;
          final bool is401 = e.response?.statusCode == 401 ||
              (responseData is Map &&
                  (responseData['code'] == 401 ||
                      responseData['message'] == "Token is Expired"));

          if (is401) {
            if (!_isHandling401) {
              _isHandling401 = true;

              // Clean dynamic/static data and remove access token
              await totalDataClean();
              await appData.remove(kKeyAccessToken);
              DioSingleton.instance.create();

              ToastUtil.showShortToast("Session expired. Please log in again.");

              // Redirect to welcome screen safely on the next frame
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (NavigationService.navigatorKey.currentState != null) {
                  NavigationService.navigateToUntilReplacement(
                      Routes.welcomeScreen);
                }
                _isHandling401 = false;
              });
            }
          }
          return handler.next(e);
        },
      ),
    ]);
    return dio;
  }

  void create() {
    BaseOptions options = BaseOptions(
      baseUrl: url,
      connectTimeout: const Duration(milliseconds: 100000),
      receiveTimeout: const Duration(milliseconds: 100000),
      headers: {
        NetworkConstants.ACCEPT: NetworkConstants.ACCEPT_TYPE,
        NetworkConstants.ACCEPT_LANGUAGE: appData.read(kKeyCountryCode) ?? "pt",
        NetworkConstants.APP_KEY: NetworkConstants.APP_KEY_VALUE,
      },
    );
    dio = _createDio(options);
  }

  void update(String auth) {
    if (kDebugMode) {
      print("Dio update");
    }
    BaseOptions options = BaseOptions(
      baseUrl: url,
      responseType: ResponseType.json,
      headers: {
        NetworkConstants.ACCEPT: NetworkConstants.ACCEPT_TYPE,
        NetworkConstants.ACCEPT_LANGUAGE: appData.read(kKeyLanguage) ?? "pt",
        NetworkConstants.APP_KEY: NetworkConstants.APP_KEY_VALUE,
        NetworkConstants.AUTHORIZATION: "Bearer $auth",
      },
      connectTimeout: const Duration(milliseconds: 100000),
      receiveTimeout: const Duration(milliseconds: 100000),
    );
    dio = _createDio(options);
  }

  void updateLanguage(String countryCode) {
    if (kDebugMode) {
      print("Dio update $countryCode");
    }
    BaseOptions options = BaseOptions(
      baseUrl: url,
      responseType: ResponseType.json,
      headers: {
        NetworkConstants.ACCEPT: NetworkConstants.ACCEPT_TYPE,
        NetworkConstants.ACCEPT_LANGUAGE: countryCode,
        NetworkConstants.APP_KEY: NetworkConstants.APP_KEY_VALUE,
        NetworkConstants.AUTHORIZATION:
            "Bearer ${appData.read(kKeyAccessToken)}",
      },
      connectTimeout: const Duration(milliseconds: 100000),
      receiveTimeout: const Duration(milliseconds: 100000),
    );
    dio = _createDio(options);
  }
}

Future<Response> postHttp(String path, [dynamic data]) => DioSingleton
    .instance
    .dio
    .post(path, data: data, cancelToken: DioSingleton.cancelToken);

Future<Response> putHttp(String path, [dynamic data]) => DioSingleton
    .instance
    .dio
    .put(path, data: data, cancelToken: DioSingleton.cancelToken);

Future<Response> getHttp(String path, [dynamic data]) =>
    DioSingleton.instance.dio.get(path, cancelToken: DioSingleton.cancelToken);

Future<Response> deleteHttp(String path, [dynamic data]) => DioSingleton
    .instance
    .dio
    .delete(path, data: data, cancelToken: DioSingleton.cancelToken);
