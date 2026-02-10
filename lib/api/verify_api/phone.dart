import 'package:dio/dio.dart';

import '../../global/app_snackbar.dart';
import '../dio_client.dart';

class VerifyPhoneApi {
  static final Dio _dio = DioClient().dio;

  static Future<void> sendOtp(String number) async {
    try {
      final response = await _dio.post(
        '/auth/send-phone-otp',
        data: {"phone": number},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackbar.success(
          title: "OTP Successful",
          message: response.data['message'] ?? "OTP send successfully!",
        );
        return;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> verifyOtp(String number, String otp) async {
    try {
      final response = await _dio.post(
        '/auth/verify-phone-otp',
        data: {"phone": number, 'otp': otp},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackbar.success(
          title: "Verify Successful",
          message: response.data['message'] ?? "Verified successfully!",
        );
        return;
      }
    } catch (e) {
      rethrow;
    }
  }
}
