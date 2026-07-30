import 'dart:convert';
import 'dart:io';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/model/buy_and_sell_category_post_create_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class CreateBuyAndSellCategoryApi {
  static final CreateBuyAndSellCategoryApi _singleton =
      CreateBuyAndSellCategoryApi._internal();
  CreateBuyAndSellCategoryApi._internal();
  static CreateBuyAndSellCategoryApi get instance => _singleton;

  Future<BuyAndSellCategoryPostCreateModel> createBuyAndSellCategoryApi({
    required String categorySlug,
    String? title,
    String? description,
    String? price,
    List<String>? condition,
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
      Map<String, dynamic> map = {
        "category_slug": categorySlug,
      };

      if (title != null && title.isNotEmpty) {
        map["title"] = title;
      }
      if (description != null && description.isNotEmpty) {
        map["description"] = description;
      }
      if (price != null && price.isNotEmpty) {
        final cleanPrice = price.replaceAll('\$', '').trim();
        map["price"] = num.tryParse(cleanPrice) ?? cleanPrice;
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

      // Add condition[]
      if (condition != null && condition.isNotEmpty) {
        map["condition[]"] = condition;
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

      Response response = await postHttp(
        Endpoints.createBuyAndSellCategory(),
        formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data =
            BuyAndSellCategoryPostCreateModel.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
