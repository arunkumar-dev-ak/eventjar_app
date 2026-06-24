import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/model/budget_track/join_trip_model.dart';

class JoinTripApi {
  static final Dio _dio = DioClient().dio;

  static Future<JoinTripResponse> joinTrip({
    required String joinToken,
  }) async {
    try {
      final response = await _dio.get(
        '/split-track/trips/join/$joinToken',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return JoinTripResponse.fromJson(response.data);
      }

      throw Exception('Failed to join trip');
    } catch (e) {
      rethrow;
    }
  }
}
