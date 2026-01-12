import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/model/checkout/promo_code_model.dart';
import 'package:eventjar/model/checkout/tikcet_payment_model.dart';

class TicketBookingApi {
  static final Dio _dio = DioClient().dio;

  static Future<void> createFreeEventRegistration(dynamic options) async {
    try {
      final response = await _dio.post(
        '/attendee/tickets/register',
        data: options,
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

  // In booking_api.dart
  static Future<Map<String, dynamic>> verifyPaymentAndCreateTickets(
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await _dio.post('/payments/verify', data: payload);
      return {'success': true, 'data': response.data};
    } catch (e) {
      rethrow;
    }
  }

  static Future<PromoCodeValidationResponse> validatePromoCode({
    required String code,
    required String eventId,
    required String userId,
    required double subtotal,
  }) async {
    try {
      final response = await _dio.post(
        '/promo-codes/validate',
        data: {
          'code': code,
          'event_id': eventId,
          'user_id': userId,
          'subtotal': subtotal,
        },
      );

      return PromoCodeValidationResponse.fromJson(response.data);
    } on DioException catch (err) {
      final message =
          err.response?.data?['message'] ?? 'Failed to validate promo code';

      return PromoCodeValidationResponse(
        valid: false,
        message: message,
        discountAmount: 0,
      );
    }
  }
}
