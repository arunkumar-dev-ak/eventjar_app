import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/global/app_snackbar.dart';

class AddFriendApi {
  static final Dio _dio = DioClient().dio;

  static Future<void> addFriend({required dynamic data}) async {
    try {
      final response = await _dio.post(
        '/mobile/split-track/friends',
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackbar.success(
          title: "Invitation Sent",
          message:
              response.data['message'] ?? "Friend invitation sent successfully",
        );

        return;
      }
    } catch (e) {
      rethrow;
    }
  }
}
