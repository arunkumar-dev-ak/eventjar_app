import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/global/global_values.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/event_info/event_info_model.dart';
import 'package:eventjar/model/my_ticket/ticket_registration_event_model.dart';

class EventInfoApi {
  static final Dio _dio = DioClient().dio;

  static Future<EventInfo> getEventInfo(String eventId) async {
    // LoggerService.loggerInstance.dynamic_d(eventId);
    final response = await _dio.get('/mobile/events/$eventId');
    if (response.statusCode == 200) {
      return EventInfo.fromJson(response.data);
    }
    throw Exception(response.data['message'] ?? "Failed to fetch event info");
  }

  static Future<TicketRegistrationEventModel> getEventByTicketId(
    String ticketId,
  ) async {
    LoggerService.loggerInstance.dynamic_d(ticketId);
    try {
      String url =
          "${backendBaseUrl()}/mobile/tickets/my-registrations/event/$ticketId";

      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final processedData = TicketRegistrationEventModel.fromJson(
          response.data,
        );
        return processedData;
      }

      throw Exception("Failed to load event info");
    } catch (e) {
      rethrow;
    }
  }
}
