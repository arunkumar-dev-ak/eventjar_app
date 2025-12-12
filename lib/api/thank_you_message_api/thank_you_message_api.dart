import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';

class ThankYouMessageApi {
  static final Dio _dio = DioClient().dio;

  static Future<bool> sendThankYouMessage({
    dynamic data,
    required String id,
  }) async {
    try {
      final response = await _dio.put('/contacts/$id', data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      return false;
    } catch (e) {
      rethrow;
    }
  }
}
