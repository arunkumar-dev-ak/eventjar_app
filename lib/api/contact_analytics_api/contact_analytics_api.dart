import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact/contact_analytics_model.dart';

class ContactAnalyticsApi {
  static final Dio _dio = DioClient().dio;

  static Future<ContactAnalytics> getAnalytics(String endPoint) async {
    try {
      final response = await _dio.get(endPoint);

      if (response.statusCode == 200) {
        return ContactAnalytics.fromJson(response.data);
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
}
