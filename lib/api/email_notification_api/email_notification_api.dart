import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/model/notification/oauth_model.dart';
import 'package:eventjar/model/notification/oauth_status_model.dart';

class EmailNotificationApi {
  static final Dio _dio = DioClient().dio;

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

  static Future<OAuthStatusResponse> getGoogleStatus() async {
    try {
      final response = await _dio.get('/user/settings/email/google/status');

      if (response.statusCode == 200) {
        return OAuthStatusResponse.fromJson(response.data);
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "Failed to fetch Google OAuth status",
      );
    } catch (err) {
      rethrow;
    }
  }

  static Future<OAuthStatusResponse> getMicrosoftStatus() async {
    try {
      final response = await _dio.get('/user/settings/email/microsoft/status');

      if (response.statusCode == 200) {
        return OAuthStatusResponse.fromJson(response.data);
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "Failed to fetch Microsoft OAuth status",
      );
    } catch (err) {
      rethrow;
    }
  }

  static Future<bool> testEmailConfig(Map<String, dynamic> body) async {
    try {
      final response = await _dio.post("/user/settings/email/test", data: body);

      if (response.statusCode == 200) {
        return true;
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "Email test failed",
      );
    } catch (err) {
      rethrow;
    }
  }

  static Future<bool> saveEmailConfig(Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(
        "/user/settings/email/configure",
        data: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "Saving email config failed",
      );
    } catch (err) {
      rethrow;
    }
  }
}
