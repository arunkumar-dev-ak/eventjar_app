import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/my_ticket/mobile_ticket.dart';
import 'package:eventjar/model/my_ticket/my_ticket_model.dart';

class MyTicketsApi {
  static final Dio _dio = DioClient().dio;

  static Future<MyRegistrationsResponse> getMyRegistrations({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      LoggerService.loggerInstance.dynamic_d("$page, $limit");
      final response = await _dio.get(
        '/attendee/tickets/my-registrations',
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200) {
        return MyRegistrationsResponse.fromJson(response.data);
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

  static Future<MobileTicketResponse> getMyTickets(String url) async {
    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        return MobileTicketResponse.fromJson(response.data);
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
