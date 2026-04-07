import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/global/device_helper.dart';
import 'package:eventjar/global/global_values.dart';
import 'package:eventjar/global/store/user_store.dart' show UserStore;
import 'package:eventjar/model/auth/login_model.dart';
import 'package:eventjar/storage/storage_service.dart';

class AuthProcessignApi {
  static final Dio _dio = DioClient().dio;

  static String getDevicePlatform() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'unknown';
  }

  static Future<LoginResponse> googleSignIn({
    required String idToken,
    String? phone,
  }) async {
    try {
      final devicePlatform = getDevicePlatform();
      final token = await StorageService.to.getString(storageFcmToken);
      final deviceName = await getDeviceModel();
      final response = await _dio.post(
        '/auth/mobile/google',
        data: {
          'idToken': idToken,
          'fcmToken': token,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
        },
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
        var result = LoginResponse.fromJson(response.data);
        return result;
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

  static Future<LoginResponse> linkedInSignIn({
    String? code,
    String? cacheKey,
    String? phone,
  }) async {
    try {
      final devicePlatform = getDevicePlatform();
      final token = await StorageService.to.getString(storageFcmToken);
      final deviceName = await getDeviceModel();

      final response = await _dio.post(
        '/auth/mobile/linkedin',
        data: {
          if (code != null) 'code': code,
          if (cacheKey != null) 'cacheKey': cacheKey,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
          'fcmToken': token,
        },
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

      return LoginResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
