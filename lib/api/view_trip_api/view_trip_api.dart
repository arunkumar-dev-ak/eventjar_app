import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/model/view_trip/trip_expense_model.dart';
import 'package:eventjar/model/view_trip/trip_friend_model.dart';

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

  static Future<TripFriendResponse> getTripFriends({
    required Map<String, dynamic> queryParams,
  }) async {
    try {
      final response = await _dio.get(
        '/mobile/budget-track/trip-friend',
        queryParameters: queryParams,
      );

      return TripFriendResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> settleBalance({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.post(
        '/split-track/settlements/balance',
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackbar.success(
          title: "Success",
          message:
              response.data['message'] ?? "Settlement completed successfully",
        );
        return;
      }
    } catch (e) {
      rethrow;
    }
  }
}
