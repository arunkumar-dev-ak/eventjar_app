import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/model/user_profile/user_profile.dart';

class UserProfileApi {
  static final Dio _dio = DioClient().dio;

  static Future<UserProfileResponse> getUserProfile() async {
    try {
      final response = await _dio.get('/user/profiles/me');

      if (response.statusCode == 200) {
        return UserProfileResponse.fromJson(response.data);
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

  static Future<void> deleteUserProfile() async {
    try {
      final response = await _dio.delete('/user/profiles/me');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return; // Success - no data returned
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "Failed to delete user profile",
      );
    } catch (e) {
      rethrow;
    }
  }
}
