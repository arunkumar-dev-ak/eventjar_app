import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:eventjar/api/dio_client.dart';
import 'package:http_parser/http_parser.dart';
import 'package:eventjar/logger_service.dart';
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
        error: "something_went_wrong".tr,
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

  static String _detectMimeType(File file) {
    final bytes = file.openSync()..setPositionSync(0);
    final header = bytes.readSync(12);
    bytes.closeSync();

    if (header.length >= 3 &&
        header[0] == 0xFF && header[1] == 0xD8 && header[2] == 0xFF) {
      return 'image/jpeg';
    }
    if (header.length >= 8 &&
        header[0] == 0x89 && header[1] == 0x50 && header[2] == 0x4E &&
        header[3] == 0x47 && header[4] == 0x0D && header[5] == 0x0A &&
        header[6] == 0x1A && header[7] == 0x0A) {
      return 'image/png';
    }
    if (header.length >= 12 &&
        header[0] == 0x52 && header[1] == 0x49 && header[2] == 0x46 &&
        header[3] == 0x46 && header[8] == 0x57 && header[9] == 0x45 &&
        header[10] == 0x42 && header[11] == 0x50) {
      return 'image/webp';
    }
    return 'application/octet-stream';
  }

  static String _mimeToExt(String mime) {
    switch (mime) {
      case 'image/jpeg': return 'jpg';
      case 'image/png': return 'png';
      case 'image/webp': return 'webp';
      default: return 'bin';
    }
  }

  static Future<String> uploadFile(File file) async {
    final mimeType = _detectMimeType(file);
    final ext = _mimeToExt(mimeType);
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: 'upload.$ext',
        contentType: MediaType.parse(mimeType),
      ),
    });

    try {
      final response = await _dio.post(
        '/storage/upload',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return data['data']['url'] as String;
        }
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Invalid upload response',
        );
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Upload failed',
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> uploadAvatar(File file) async {
    final ext = file.path.split('.').last.toLowerCase();
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(
        file.path,
        filename: 'avatar.$ext',
      ),
    });

    try {
      final response = await _dio.post(
        '/user/profiles/avatar/upload',
        data: formData,
        onSendProgress: (sent, total) {
          // Optional: expose to progress widget
        },
      );

      // Assume backend returns: { success: true, data: { url: '...' } }
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Upload failed',
      );
    } catch (e) {
      rethrow;
    }
  }
}
