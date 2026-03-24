import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/connection/connection_model.dart';

class ConnectionApi {
  static final Dio _dio = DioClient().dio;

  static Future<ConnectionResponse> getConnectionResponse({
    required dynamic queryParams,
  }) async {
    try {
      final response = await _dio.get(
        '/networking/connections',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ConnectionResponse.fromJson(response.data);
      }

      throw Exception('Failed to fetch connections');
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> respondToMeetingRequest({
    required String eventId,
    required String requestId,
    required String status,
  }) async {
    try {
      final response = await _dio.patch(
        '/networking/events/$eventId/meeting-requests/$requestId/respond',
        data: {'status': status},
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> cancelMeetingRequest({required String requestId}) async {
    try {
      final response = await _dio.delete(
        '/networking/meeting-requests/$requestId',
      );

      LoggerService.loggerInstance.dynamic_d(response.statusCode);

      return response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204;
    } catch (e) {
      rethrow;
    }
  }
}
