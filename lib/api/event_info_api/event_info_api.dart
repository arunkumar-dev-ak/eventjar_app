import 'package:dio/dio.dart';
import 'package:eventjar_app/api/dio_client.dart';
import 'package:eventjar_app/model/event_info/event_info_model.dart';

class EventInfoApi {
  static final Dio _dio = DioClient().dio;

  static Future<EventInfoResponse> getEventInfo(String eventId) async {
    final response = await _dio.get('/events/$eventId');
    if (response.statusCode == 200) {
      return EventInfoResponse.fromJson(response.data);
    }
    throw Exception(response.data['message'] ?? "Failed to fetch event info");
  }
}
