import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import '../../model/user_profile/bio_profile.dart';

class BioProfileApi {
  static final Dio _dio = DioClient().dio;

  static Future<BioProfile> getBioProfile(String userName) async {
    try {
      final response = await _dio.get('/user/profiles/public/$userName');

      if (response.statusCode == 200) {
        return BioProfile.fromJson(response.data);
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

  static Future<bool> uploadMeeting(dynamic formData, String userName) async {
    try {
      final response = await _dio.post(
        '/user/profiles/public/$userName/schedule-meeting',
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
