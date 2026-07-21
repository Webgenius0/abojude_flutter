import 'dart:convert';
import 'dart:io';
import 'package:abojude_flutter/features/profile/model/contact_support_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class ContactSupportApi {
  static final ContactSupportApi _singleton = ContactSupportApi._internal();
  ContactSupportApi._internal();
  static ContactSupportApi get instance => _singleton;

  Future<ContactSupportModel> contactSupportApi({
    required String email,
    required String describeIssue,
    String? subject,
    File? attachment,
  }) async {
    try {
      Map<String, dynamic> map = {
        "email": email,
        "describe_issue": describeIssue,
      };

      if (subject != null && subject.trim().isNotEmpty) {
        map["subject"] = subject.trim();
      }

      FormData formData = FormData.fromMap(map);

      if (attachment != null) {
        formData.files.add(
          MapEntry(
            "attachment",
            await MultipartFile.fromFile(
              attachment.path,
              filename: attachment.path.split('/').last,
            ),
          ),
        );
      }

      Response response = await postHttp(Endpoints.contactSupport(), formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = ContactSupportModel.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
