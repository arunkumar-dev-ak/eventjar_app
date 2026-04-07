import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/model/set_2fa/set_2fa_model.dart';

class Set2faApi {
  static final Dio _dio = DioClient().dio;

  static Future<Generate2FAResponse> generate2FASecret() async {
    try {
      final response = await _dio.get('/auth/2fa/generate');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Generate2FAResponse.fromJson(response.data);
      }

      throw Exception('Failed to generate 2FA secret');
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> enable2FA(String token) async {
    try {
      final response = await _dio.post(
        '/auth/2fa/enable',
        data: {'token': token},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      throw Exception('Failed to enable 2FA');
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> disable2Fa(String password) async {
    try {
      final response = await _dio.post(
        '/auth/2fa/disable',
        data: {'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      throw Exception('Failed to disable 2FA');
    } catch (e) {
      rethrow;
    }
  }
}
