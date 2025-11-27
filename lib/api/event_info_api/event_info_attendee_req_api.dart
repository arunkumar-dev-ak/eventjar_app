import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:eventjar/model/event_info/event_attendee_meeting_req_model.dart';

class EventInfoApiAttendeeRequestList {
  static final Dio _dio = DioClient().dio;

  static Future<void> respondToRequestMessage(
    String eventId,
    String requestId,
    String status,
  ) async {
    try {
      final response = await _dio.patch(
        '/networking/events/$eventId/meeting-requests/$requestId/respond',
        data: {'status': status},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackbar.success(
          title: "Request updated",
          message:
              response.data['message'] ??
              "Meeting request ${capitalize(status.toLowerCase())} successfully.",
        );
        return;
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

  static Future<EventAttendeeRequestResponse> getAttendeeRequestList(
    String eventId,
  ) async {
    try {
      final response = await _dio.get(
        '/networking/events/$eventId/meeting-requests',
      );
      if (response.statusCode == 200) {
        return EventAttendeeRequestResponse.fromJson(response.data);
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
