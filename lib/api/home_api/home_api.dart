import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/model/home/home_model.dart';

class HomeApi {
  static final Dio _dio = DioClient().dio;

  static Future<EventResponse> getEventList(String endPoint) async {
    try {
      final response = await _dio.get(endPoint);

      if (response.statusCode == 200) {
        return EventResponse.fromJson(response.data);
      }

      throw Exception(response.data?['message'] ?? 'Failed to fetch events');
    } catch (e) {
      rethrow;
    }
  }

  static Future<CategoryList> getCategoryListInfo() async {
    try {
      final response = await _dio.get('/mobile/events/category-list');

      if (response.statusCode == 200) {
        return CategoryList.fromJson(response.data);
      }

      throw Exception(
        response.data?['message'] ?? 'Failed to fetch categories',
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<ProfileInfo> getUserProfileHome() async {
    try {
      final response = await _dio.get('/mobile/dashboard/profile');

      if (response.statusCode == 200) {
        return ProfileInfo.fromJson(response.data);
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
