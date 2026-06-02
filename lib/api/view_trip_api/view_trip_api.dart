import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/model/view_trip/trip_expense_model.dart';

class ViewTripApi {
  static final Dio _dio = DioClient().dio;

  static Future<TripExpenseResponse> getTripExpenses({
    required Map<String, dynamic> queryParams,
  }) async {
    try {
      final response = await _dio.get(
        '/mobile/budget-track/trip-expense',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TripExpenseResponse.fromJson(response.data);
      }

      throw Exception('Failed to fetch Trip Expenses');
    } catch (e) {
      rethrow;
    }
  }
}
