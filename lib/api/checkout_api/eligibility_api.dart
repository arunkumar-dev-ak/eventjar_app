import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/model/checkout/eligibility_model.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:get/get.dart';

class CheckoutApi {
  static final Dio _dio = DioClient().dio;

  static Future<TicketEligibilityResponse> checkTicketEligibility({
    required String eventId,
    required String ticketTierId,
  }) async {
    try {
      final response = await _dio.get(
        '/attendee/tickets/eligibility/$eventId/$ticketTierId',
      );

      if (response.statusCode == 200) {
        return TicketEligibilityResponse.fromJson(response.data);
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "Something went wrong",
      );
    } on DioException catch (err) {
      if (err.response?.statusCode == 401) {
        await UserStore.to.clearStore();
        Get.toNamed(RouteName.signInPage);
      }
      rethrow;
    } catch (err) {
      rethrow;
    }
  }
}
