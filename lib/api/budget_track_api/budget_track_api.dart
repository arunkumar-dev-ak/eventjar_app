import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/budget_track/trip_model.dart';

class BudgetTrackApi {
  static final Dio _dio = DioClient().dio;

  static Future<TripResponse> getTrips({
    required Map<String, dynamic> queryParams,
  }) async {
    try {
      final response = await _dio.get(
        '/mobile/budget-track/trip',
        queryParameters: queryParams,
      );

      LoggerService.loggerInstance.dynamic_d(
        'Status code is ${response.statusCode}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TripResponse.fromJson(response.data);
      }

      throw Exception('Failed to fetch trips');
    } catch (e) {
      rethrow;
    }
  }
}
