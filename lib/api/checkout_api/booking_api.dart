import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/model/checkout/tikcet_payment_model.dart';

class TicketBookingApi {
  static final Dio _dio = DioClient().dio;

  static Future<void> registerTicket({
    required String eventId,
    required String ticketTierId,
    // int quantity = 1,
  }) async {
    try {
      final response = await _dio.post(
        '/attendee/tickets/register',
        data: {
          'eventId': eventId,
          'ticketTierId': ticketTierId,
          // 'quantity': quantity,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackbar.success(
          title: "Registration Successful",
          message:
              response.data['message'] ?? "Ticket registered successfully!",
        );
        return;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<TicketPaymentModel> createTicketPayment(dynamic options) async {
    try {
      final response = await _dio.post('/payments/create', data: options);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TicketPaymentModel.fromJson(response.data);
      }
      throw Exception('Failed to create ticket payment');
    } catch (e) {
      rethrow;
    }
  }
}
