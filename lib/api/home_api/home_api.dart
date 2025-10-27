import 'package:dio/dio.dart';
import 'package:eventjar_app/api/dio_client.dart';
import 'package:eventjar_app/model/home/home_model.dart';

class HomeApi {
  static final Dio _dio = DioClient().dio;

  static Future<EventResponse> getEventList(String endPoint) async {
    final response = await _dio.get(endPoint);
    if (response.statusCode == 200) {
      return EventResponse.fromJson(response.data);
    }
    throw Exception(response.data['message'] ?? "Failed to fetch events");
  }
}
