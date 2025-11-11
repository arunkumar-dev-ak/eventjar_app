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
}
