import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/model/set_2fa/set_2fa_model.dart';

class Set2faApi {
  static final Dio _dio = DioClient().dio;

  static Future<Generate2FAResponse> generate2FASecret() async {
    try {
      final response = await _dio.get('/auth/2fa/generate');

      if (response.statusCode == 200) {
        return Generate2FAResponse.fromJson(response.data);
      }

      throw Exception('Failed to generate 2FA secret');
    } catch (e) {
      rethrow;
    }
  }
}
