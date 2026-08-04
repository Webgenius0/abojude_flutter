import 'dart:convert';
import 'dart:io';
import 'package:abojude_flutter/features/create_listing/jobs_create/model/job_post_create_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import 'package:abojude_flutter/networks/endpoints.dart';

final class CreateJobApi {
  static final CreateJobApi _singleton = CreateJobApi._internal();
  CreateJobApi._internal();
  static CreateJobApi get instance => _singleton;

  Future<JobPostCreateModel> createJobApi({
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
    try {
      Map<String, dynamic> map = {"category_slug": categorySlug};

      if (title != null && title.isNotEmpty) {
        map["title"] = title;
      }
      if (companyName != null && companyName.isNotEmpty) {
        map["company_name"] = companyName;
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
      if (jobType != null && jobType.isNotEmpty) {
        map["job_type[]"] = jobType;
      }

      FormData formData = FormData.fromMap(map);

      // Add thumbnail
      if (thumbnail != null) {
        formData.files.add(
          MapEntry(
            "thumbnail",
            await MultipartFile.fromFile(
              thumbnail.path,
              filename: thumbnail.path.split('/').last,
            ),
          ),
        );
      }

      Response response = await postHttp(Endpoints.jobCreate(), formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = JobPostCreateModel.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
