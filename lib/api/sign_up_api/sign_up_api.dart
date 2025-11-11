import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';

class SignUpApi {
  static final Dio _dio = DioClient().dio;

  static Future<String> signUp(dynamic value) async {
    try {
      final response = await _dio.post('/auth/register', data: value);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return "Please use your credentials to sign in.";
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
