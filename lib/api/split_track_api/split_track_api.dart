import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/model/budget_track/split_track_friend_model.dart';

import '../../logger_service.dart';

class SplitTrackApi {
  static final Dio _dio = DioClient().dio;

  static Future<void> createTrip({required Map<String, dynamic> body}) async {
    try {
      final response = await _dio.post('/mobile/split-track/trips', data: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      }

      throw Exception('Failed to create trip');
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> deleteTrip({required String tripId}) async {
    try {
      final response = await _dio.delete('/mobile/split-track/trips/$tripId');

      if (response.statusCode == 204 || response.statusCode == 200) {
        return;
      }

      throw Exception('Failed to delete trip');
    } catch (e) {
      rethrow;
    }
  }

  static Future<SplitTrackFriendResponse> getFriends({
    required Map<String, dynamic> queryParams,
  }) async {
    try {
      final response = await _dio.get(
        '/mobile/split-track/friends',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SplitTrackFriendResponse.fromJson(response.data);
      }

      throw Exception('Failed to fetch friends');
    } catch (e) {
      rethrow;
    }
  }
}
