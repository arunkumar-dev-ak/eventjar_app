import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/model/event_info/event_info_model.dart';

class EventInfoApi {
  static final Dio _dio = DioClient().dio;

  static Future<EventInfo> getEventInfo(String eventId) async {
    final response = await _dio.get('/events/$eventId');
    if (response.statusCode == 200) {
      return EventInfo.fromJson(response.data);
    }
    throw Exception(response.data['message'] ?? "Failed to fetch event info");
  }
}
