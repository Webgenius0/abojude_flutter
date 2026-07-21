import 'dart:convert';
import 'dart:io';
import 'package:abojude_flutter/features/profile/model/edit_profile_model.dart';
import 'package:abojude_flutter/networks/dio/dio.dart';
import 'package:abojude_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class EditProfileApi {
  static final EditProfileApi _singleton = EditProfileApi._internal();
  EditProfileApi._internal();
  static EditProfileApi get instance => _singleton;

  Future<EditProfileModel> editProfileApi({
    String? name,
    String? province,
    String? city,
    File? avatar,
  }) async {
    try {
      Map<String, dynamic> map = {
        "_method": "PUT",
      };

      if (name != null && name.isNotEmpty) {
        map["name"] = name;
      }
      if (province != null && province.isNotEmpty) {
        map["province"] = province;
      }
      if (city != null && city.isNotEmpty) {
        map["city"] = city;
      }

      FormData formData = FormData.fromMap(map);

      if (avatar != null) {
        formData.files.add(
          MapEntry(
            "avatar",
            await MultipartFile.fromFile(
              avatar.path,
              filename: avatar.path.split('/').last,
            ),
          ),
        );
      }

      Response response = await postHttp(Endpoints.updateProfile(), formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = EditProfileModel.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
