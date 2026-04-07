import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/global/device_helper.dart';
import 'package:eventjar/global/global_values.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/auth/login_model.dart';
import 'package:eventjar/storage/storage_service.dart';

class SignUpApi {
  static final Dio _dio = DioClient().dio;
  static final devicePlatform = getDevicePlatform();

  static String getDevicePlatform() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'unknown';
  }

  static Future<LoginResponse> signUp(dynamic value) async {
    final deviceName = await getDeviceModel();
    final fcmToken = await StorageService.to.getString(storageFcmToken);
    try {
      final response = await _dio.post(
        '/auth/register',
        options: Options(
          headers: {
            'X-Client-Platform': 'mobile',
            'Content-Type': 'application/json',
            'X-Device-Platform': devicePlatform,
            'User-Agent': deviceName,
            'X-Device-Id': UserStore.to.deviceId,
            'X-Device-Name': deviceName,
          },
        ),
        data: {...value, "fcmToken": fcmToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginResponse.fromJson(response.data);
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

  static Future<void> googleSignIn(String idToken) async {
    try {
      final deviceName = await getDeviceModel();
      final response = await _dio.post(
        '/auth/mobile/google',
        options: Options(
          headers: {
            'X-Client-Platform': 'mobile',
            'Content-Type': 'application/json',
            'X-Device-Platform': devicePlatform,
            'User-Agent': deviceName,
            'X-Device-Id': UserStore.to.deviceId,
            'X-Device-Name': deviceName,
          },
        ),
        data: {"idToken": idToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.loggerInstance.d("Success Response: ${response.data}");
        // return LoginResponse.fromJson(response.data);
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "Something went wrong",
      );
    } catch (e) {
      LoggerService.loggerInstance.e("Error Response: $e");
      rethrow;
    }
  }
}
