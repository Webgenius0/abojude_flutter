import 'dart:convert';
import 'dart:io';
import 'package:abojude_flutter/features/create_listing/services_create/model/service_post_create_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import 'package:abojude_flutter/networks/endpoints.dart';

final class CreateServiceApi {
  static final CreateServiceApi _singleton = CreateServiceApi._internal();
  CreateServiceApi._internal();
  static CreateServiceApi get instance => _singleton;

  Future<ServicePostCreateModel> createServiceApi({
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
    try {
      Map<String, dynamic> map = {"category_id": categoryId};

      if (title != null && title.isNotEmpty) {
        map["title"] = title;
      }
      if (description != null && description.isNotEmpty) {
        map["description"] = description;
      }
      if (province != null && province.isNotEmpty) {
        map["province"] = province;
      }
      if (city != null && city.isNotEmpty) {
        map["city"] = city;
      }
      if (address != null && address.isNotEmpty) {
        map["address"] = address;
      }
      if (phone != null && phone.isNotEmpty) {
        map["phone"] = phone;
      }
      if (whatsapp != null && whatsapp.isNotEmpty) {
        map["whatsapp"] = whatsapp;
      }
      if (email != null && email.isNotEmpty) {
        map["email"] = email;
      }
      if (isAppChat != null) {
        map["is_app_chat"] = isAppChat;
      }
      if (serviceArea != null && serviceArea.isNotEmpty) {
        map["service_area[]"] = serviceArea;
      }

      FormData formData = FormData.fromMap(map);

      // Add photos[]
      if (photos != null && photos.isNotEmpty) {
        for (var file in photos) {
          formData.files.add(
            MapEntry(
              "photos[]",
              await MultipartFile.fromFile(
                file.path,
                filename: file.path.split('/').last,
              ),
            ),
          );
        }
      }

      Response response = await postHttp(Endpoints.serviceCreate(), formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = ServicePostCreateModel.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
