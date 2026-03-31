import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/global/device_helper.dart';
import 'package:eventjar/global/global_values.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/model/auth/login_model.dart';
import 'package:eventjar/storage/storage_service.dart';

class SignInApi {
  static final Dio _dio = DioClient().dio;

  static String getDevicePlatform() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'unknown';
  }

  static Future<LoginResponse> signIn({
    required String email,
    required String password,
  }) async {
    final token = await StorageService.to.getString(storageFcmToken);
    final deviceName = await getDeviceModel();
    try {
      final devicePlatform = getDevicePlatform();
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password, 'fcmToken': token},
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

  static Future<LoginResponse> verify2FA({
    required String tempToken,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/verify-2fa',
        data: {'tempToken': tempToken, 'token': otp},
        options: Options(
          headers: {
            'X-Client-Type': 'mobile',
            'Content-Type': 'application/json',
          },
        ),
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

  static Future<bool> logout() async {
    final fcmToken = await StorageService.to.getString(storageFcmToken);
    final deviceName = await getDeviceModel();
    try {
      final devicePlatform = getDevicePlatform();
      final response = await _dio.post(
        '/auth/logout-mobile',
        data: {'fcmToken': fcmToken},
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
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
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
