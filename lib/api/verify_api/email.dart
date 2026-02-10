import 'package:dio/dio.dart';

import '../../global/app_snackbar.dart';
import '../dio_client.dart';

class VerifyEmailApi {
  static final Dio _dio = DioClient().dio;

  static Future<void> resendVerify() async {
    try {
      final response = await _dio.post('/auth/resend-verification-email');

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackbar.success(
          title: "Mailed Successful",
          message: response.data['message'] ?? "Email send successfully!",
        );
        return;
      }
    } catch (e) {
      rethrow;
    }
  }
}
