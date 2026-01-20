import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';

class ContactApi {
  static final Dio _dio = DioClient().dio;

  static Future<MobileContactResponse> getEventList(String endPoint) async {
    try {
      final response = await _dio.get(endPoint);

      if (response.statusCode == 200) {
        return MobileContactResponse.fromJson(response.data);
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

  static Future<void> deleteContact(String id) async {
    try {
      final response = await _dio.delete('/contacts/$id');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        AppSnackbar.success(
          title: "Deletion Successful",
          message: "Contact Deleted successfully!",
        );
      }

      return;
    } catch (e) {
      rethrow;
    }
  }
}
