import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/whatsapp_integration/whatsapp_integration_model.dart';

class WhatsAppIntegrationApi {
  static final Dio _dio = DioClient().dio;

  static Future<WhatsAppIntegrationModel> getWhatsAppConfig() async {
    try {
      final response = await _dio.get('/user/settings/whatsapp');

      if (response.statusCode == 200) {
        return WhatsAppIntegrationModel.fromJson(response.data);
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "Something went wrong",
      );
    } catch (err) {
      LoggerService.loggerInstance.dynamic_d(err);
      rethrow;
    }
  }

  static Future<bool> saveWhatsAppToken(String apiToken) async {
    try {
      final response = await _dio.post(
        '/user/settings/whatsapp/configure',
        data: {'apiToken': apiToken, 'isActive': false},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "Failed to save WhatsApp configuration",
      );
    } catch (err) {
      LoggerService.loggerInstance.dynamic_d(err);
      rethrow;
    }
  }

  static Future<void> deleteWhatsAppConfig() async {
    try {
      final response = await _dio.delete('/user/settings/whatsapp');

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: "Failed to delete WhatsApp configuration",
        );
      }
    } catch (err) {
      LoggerService.loggerInstance.dynamic_d(err);
      rethrow;
    }
  }
}
