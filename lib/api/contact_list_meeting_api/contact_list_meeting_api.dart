import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact-list-meeting/network_meeting.dart';

class ContactListMeetingApi {
  static final Dio _dio = DioClient().dio;

  static Future<NetworkMeetingsListResponse> getNetworkMeeting(
    String endpoint,
  ) async {
    try {
      final response = await _dio.get(endpoint);

      if (response.statusCode == 200) {
        return NetworkMeetingsListResponse.fromJson(response.data);
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

  static Future<bool> completeMeeting({required String id}) async {
    try {
      final response = await _dio.patch('/network-meetings/$id/complete');

      LoggerService.loggerInstance.dynamic_d(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      throw Exception('Failed to Update Status');
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

      throw Exception('Failed to Update Status');
    } catch (e) {
      rethrow;
    }
  }
}
