import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/model/network-meeting/network_meeting.dart';

class NetworkMeetingApi {
  static final Dio _dio = DioClient().dio;

  static Future<NetworkMeetingResponse> getNetworkMeetings({
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.get(
        '/network-meetings/list',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkMeetingResponse.fromJson(response.data);
      }

      throw Exception('Failed to fetch Network Meetings');
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> confirmMeeting({required String id}) async {
    try {
      final response = await _dio.patch('/network-meetings/$id/confirm');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      throw Exception('Failed to confirm meeting');
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> completeMeeting({required String id}) async {
    try {
      final response = await _dio.patch('/network-meetings/$id/complete');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      throw Exception('Failed to complete meeting');
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> rescheduleMeeting({
    required String id,
    required Map<String, dynamic> dto,
  }) async {
    try {
      final response = await _dio.patch(
        '/network-meetings/$id/reschedule',
        data: dto,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      throw Exception('Failed to reschedule meeting');
    } catch (e) {
      rethrow;
    }
  }
}
