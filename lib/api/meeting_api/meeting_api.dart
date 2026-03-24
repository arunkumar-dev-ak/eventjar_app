import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact-meeting/contact_meeting.dart';

class MeetingApi {
  static final Dio _dio = DioClient().dio;

  static Future<ContactMeetingResponse> getConnectionResponse({
    required dynamic queryParams,
  }) async {
    try {
      final response = await _dio.get(
        '/contact-meetings',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ContactMeetingResponse.fromJson(response.data);
      }

      throw Exception('Failed to fetch Contact Meeting');
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> completeMeeting({required String id}) async {
    try {
      final response = await _dio.patch('/contact-meetings/$id/complete');
      LoggerService.loggerInstance.dynamic_d(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      throw Exception('Failed to Update Status');
    } catch (e) {
      rethrow;
    }
  }
}
