import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';

class AddFriendApi {
  static final Dio _dio = DioClient().dio;

  static Future<void> addFriend({required dynamic data}) async {
    try {
      final response = await _dio.post(
        '/mobile/split-track/friends',
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      }
    } catch (e) {
      rethrow;
    }
  }
}
