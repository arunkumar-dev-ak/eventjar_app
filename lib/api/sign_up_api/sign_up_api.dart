import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
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
}
