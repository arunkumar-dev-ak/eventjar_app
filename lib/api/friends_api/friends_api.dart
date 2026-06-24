import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/model/budget_track/split_track_friend_model.dart';

class FriendsApi {
  static final Dio _dio = DioClient().dio;

  static Future<SplitTrackFriendResponse> getFriends({
    required Map<String, dynamic> queryParams,
  }) async {
    try {
      final response = await _dio.get(
        '/mobile/budget-track/friends/list',
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

  static Future<void> acceptFriends({required String id}) async {
    try {
      final response = await _dio.post(
        '/mobile/split-track/friends/$id/accept',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      }

      throw Exception('Failed to Accept friend');
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> rejectFriends({required String id}) async {
    try {
      final response = await _dio.post(
        '/mobile/split-track/friends/$id/reject',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      }

      throw Exception('Failed to Reject friend');
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> resendInvitation({
    required String id,
    required List<String> channels,
  }) async {
    try {
      final response = await _dio.post(
        '/split-track/friends/$id/resend-invitation',
        data: {'channels': channels},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      }

      throw Exception('Failed to resend invitation');
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> deleteFriends({required String id}) async {
    try {
      final response = await _dio.delete('/mobile/split-track/friends/$id');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return;
      }

      throw Exception('Failed to Delete friend');
    } catch (e) {
      rethrow;
    }
  }
}
