import 'package:dio/dio.dart';
import 'package:eventjar_app/api/dio_client.dart';
import 'package:eventjar_app/model/auth/login_model.dart';

class SignInApi {
  static final Dio _dio = DioClient().dio;

  static Future<LoginResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
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
}
