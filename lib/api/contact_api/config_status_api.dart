import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact/config_model.dart';

class ConfigStatusApi {
  static final Dio _dio = DioClient().dio;

  static Future<ConfigStatusResponse> getConfigStatus() async {
    try {
      final response = await _dio.get('/user/settings/config-status');

      if (response.statusCode == 200) {
        return ConfigStatusResponse.fromJson(response.data);
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
