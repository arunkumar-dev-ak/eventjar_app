import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/notification/email_providers.dart';
import 'package:eventjar/model/notification/notification_model.dart';
import 'package:eventjar/model/notification/oauth_model.dart';

class NotificationApi {
  static final Dio _dio = DioClient().dio;

  static Future<EmailProvidersResponse> getEmailProviders() async {
    try {
      final response = await _dio.get('/user/settings/email/providers');

      if (response.statusCode == 200) {
        return EmailProvidersResponse.fromJson(response.data);
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "Something went wrong",
      );
    } catch (err) {
      rethrow;
    }
  }

  static Future<NotificationSettingsEmailResponse> getEmailConfig() async {
    try {
      final response = await _dio.get('/user/settings/email');

      if (response.statusCode == 200) {
        return NotificationSettingsEmailResponse.fromJson(response.data);
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

  static Future<OAuthAuthUrlResponse> connectGoogle() async {
    try {
      final response = await _dio.get('/user/settings/email/google/connect');

      if (response.statusCode == 200) {
        return OAuthAuthUrlResponse.fromJson(response.data);
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "Something went wrong",
      );
    } catch (err) {
      rethrow;
    }
  }

  static Future<OAuthAuthUrlResponse> connectMicrosoft() async {
    try {
      final response = await _dio.get('/user/settings/email/microsoft/connect');

      if (response.statusCode == 200) {
        return OAuthAuthUrlResponse.fromJson(response.data);
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "Something went wrong",
      );
    } catch (err) {
      rethrow;
    }
  }

  static Future<NotificationSettingsEmailResponse> deleteEmailConfig() async {
    try {
      final response = await _dio.delete('/user/settings/email');

      if (response.statusCode == 200) {
        return NotificationSettingsEmailResponse.fromJson(response.data);
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
}
