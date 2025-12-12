import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';

class ScheduleMeetingApi {
  static final Dio _dio = DioClient().dio;

  static const String _basePath = '/network-meetings';

  static Future<bool> createMeeting({required Map<String, dynamic> dto}) async {
    try {
      final payload = {
        ...dto,
        'scheduledAt': dto['scheduledAt'] is DateTime
            ? (dto['scheduledAt'] as DateTime).toIso8601String()
            : dto['scheduledAt'],
      };

      final response = await _dio.post(_basePath, data: payload);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      return false;
    } catch (e) {
      rethrow;
    }
  }
}
