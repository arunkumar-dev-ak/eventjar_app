import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact/contact_tag_model.dart'
    show TagModel, TagsResponseModel;

class AddContactApi {
  static final Dio _dio = DioClient().dio;

  static Future<void> registerTicket({dynamic data}) async {
    try {
      final response = await _dio.post('/contacts', data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackbar.success(
          title: "Contact Added",
          message: response.data['message'] ?? "Contact added successfully!",
        );
        return;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<TagModel>> getTagList() async {
    try {
      final response = await _dio.get('/mobile/contacts/tags');

      if (response.statusCode == 200) {
        return TagsResponseModel.fromJson(response.data).tags;
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "Something went wrong",
      );
    } catch (e) {
      LoggerService.loggerInstance.e(e);
      rethrow;
    }
  }

  static Future<void> updateContact({
    dynamic data,
    required String id,
    bool isFromQualify = false,
  }) async {
    try {
      final response = await _dio.put('/contacts/$id', data: data);

      LoggerService.loggerInstance.dynamic_d(response.statusCode);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          !isFromQualify) {
        AppSnackbar.success(
          title: "Contact Updated",
          message: "Contact Updated successfully!",
        );
        return;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> qualifyAndSplitContact({
    required String contactId,
    required Map<String, dynamic> qualificationData,
  }) async {
    try {
      await _dio.post(
        '/contacts/$contactId/qualify-and-split',
        data: qualificationData,
      );
      return;
    } catch (e) {
      rethrow;
    }
  }
}
