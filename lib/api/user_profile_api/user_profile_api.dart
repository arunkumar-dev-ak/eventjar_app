import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/model/auth/delete_request_model.dart';
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

  static Future<bool> updateUserProfile(dynamic data) async {
    try {
      final response = await _dio.put('/user/profiles/me', data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "Failed to update",
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> deleteUserProfile({required String password}) async {
    try {
      final response = await _dio.post(
        '/user/account-management/delete-request',
        data: {'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "Failed to process delete request",
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> cancelDeletionRequest({required String password}) async {
    try {
      final response = await _dio.delete(
        '/user/account-management/cancel-deletion',
        data: {'password': password},
      );

      if (response.statusCode == 200) {
        return true;
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "Failed to cancel deletion request",
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<DeleteRequestResponse> fetchDeletionAccountRequest() async {
    try {
      final response = await _dio.get(
        '/user/account-management/deletion-status',
      ); // Adjust endpoint as needed

      if (response.statusCode == 200) {
        return DeleteRequestResponse.fromJson(response.data);
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "Failed to fetch deletion request status",
      );
    } catch (e) {
      rethrow;
    }
  }
}
