import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/model/event_info/event_attendee_model.dart';

class EventInfoApiAttendeeList {
  static final Dio _dio = DioClient().dio;

  static Future<EventAttendeeResponse> getEventAttendeeList(
    String eventId,
  ) async {
    try {
      final response = await _dio.get('/networking/events/$eventId/attendees');
      if (response.statusCode == 200) {
        return EventAttendeeResponse.fromJson(response.data);
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

  static Future<void> sendMeetRequest(dynamic payload, String eventId) async {
    try {
      final response = await _dio.post(
        '/networking/events/$eventId/meeting-requests',
        data: payload,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackbar.success(
          title: "Request Sent",
          message:
              response.data['message'] ?? "Meeting request sent successfully!",
        );
        return;
      }
    } catch (e) {
      rethrow;
    }
  }
}
