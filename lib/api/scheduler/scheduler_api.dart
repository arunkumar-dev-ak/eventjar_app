import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';

class SchedulerApi {
  static final Dio _dio = DioClient().dio;

  static Future<bool> createMeeting(Map<String, dynamic> dto) async {
    try {
      final response = await _dio.post('/contact-meetings', data: dto);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> rescheduleMeeting({
    required Map<String, dynamic> dto,
    required String id,
  }) async {
    try {
      final response = await _dio.patch(
        '/contact-meetings/$id/reschedule',
        data: dto,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }
}
