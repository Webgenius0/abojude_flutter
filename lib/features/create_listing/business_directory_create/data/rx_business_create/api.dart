import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/endpoints.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/widgets/business_listing_model.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/model/business_post_create_model.dart';

final class CreateBusinessApi {
  static final CreateBusinessApi _singleton = CreateBusinessApi._internal();
  CreateBusinessApi._internal();
  static CreateBusinessApi get instance => _singleton;

  Future<BusinessPostCreateModel> createBusinessApi({
    required BusinessListingModel model,
  }) async {
    try {
      Map<String, dynamic> map = {
        "category_slug": "business-directory",
        "business_name": model.businessName,
        "business_category": model.businessCategory,
        "description": model.description,
        "website": model.website,
        "province": model.province,
        "city": model.city,
        "address": model.address,
        "phone": model.phoneNumber,
        "whatsapp": model.whatsAppNumber,
        "email": model.emailAddress,
        "is_app_chat": model.enableInAppChat ? 1 : 0,
      };

      model.businessHours.forEach((day, hours) {
        final lowercaseDay = day.toLowerCase();
        map["business_hours[$lowercaseDay][is_closed]"] = hours.isOpen ? "false" : "true";
        map["business_hours[$lowercaseDay][opening_hour]"] = hours.openingTime;
        map["business_hours[$lowercaseDay][closing_time]"] = hours.closingTime;
      });

      FormData formData = FormData.fromMap(map);

      // Add coverImage (thumbnail)
      if (model.coverImage != null) {
        formData.files.add(
          MapEntry(
            "thumbnail",
            await MultipartFile.fromFile(
              model.coverImage!.path,
              filename: model.coverImage!.path.split('/').last,
            ),
          ),
        );
      }

      // Add logo
      if (model.logo != null) {
        formData.files.add(
          MapEntry(
            "logo",
            await MultipartFile.fromFile(
              model.logo!.path,
              filename: model.logo!.path.split('/').last,
            ),
          ),
        );
      }

      // Add photos[]
      if (model.galleryImages.isNotEmpty) {
        for (var file in model.galleryImages) {
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

      Response response = await postHttp(Endpoints.businessDirectoryCreate(), formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = BusinessPostCreateModel.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
