import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/auth/login_model.dart';

class SignUpApi {
  static final Dio _dio = DioClient().dio;

  static Future<LoginResponse> signUp(dynamic value) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        options: Options(
          headers: {
            'X-Client-Type': 'mobile',
            'Content-Type': 'application/json',
          },
        ),
        data: value,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginResponse.fromJson(response.data);
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "Something went wrong",
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> googleSignIn(String idToken) async {
    try {
      final response = await _dio.post(
        '/auth/mobile/google',
        options: Options(
          headers: {
            'X-Client-Type': 'mobile',
            'Content-Type': 'application/json',
          },
        ),
        data: {"idToken": idToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.loggerInstance.d("Success Response: ${response.data}");
        // return LoginResponse.fromJson(response.data);
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "Something went wrong",
      );
    } catch (e) {
      LoggerService.loggerInstance.e("Error Response: $e");
      rethrow;
    }
  }
}
