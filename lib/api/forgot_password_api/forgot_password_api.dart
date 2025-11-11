import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';

class ForgotPasswordApi {
  static final Dio _dio = DioClient().dio;

  static Future<String> forgotPassword(dynamic value) async {
    try {
      final response = await _dio.post(
        '/auth/request-password-reset',
        data: value,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return "If an account associated with that email address exists, password reset instructions have been sent to your email.";
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
}
