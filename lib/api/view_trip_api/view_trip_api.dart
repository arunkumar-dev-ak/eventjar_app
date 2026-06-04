import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/model/view_trip/dropdown_friend_model.dart';
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

  //expense
  static Future<void> createExpense({
    required Map<String, dynamic> payload,
  }) async {
    try {
      // await _dio.post('/mobile/budget-track/expense', data: payload);
      print("API Payload Received: $payload");
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> deleteExpense(String id) async {
    try {
      final response = await _dio.delete('/mobile/split-track/expenses/$id');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<DropdownFriendResponseModel> getDropdownFriends({
    required String tripId,
    String search = '',
    int offset = 0,
    int limit = 15,
  }) async {
    try {
      final response = await _dio.get(
        '/mobile/budget-track/dropdown-friend-list',
        queryParameters: {
          'tripId': tripId,
          if (search.isNotEmpty) 'search': search,
          'offset': offset,
          'limit': limit,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DropdownFriendResponseModel.fromJson(response.data);
      }

      throw Exception('Failed to fetch Friens List');
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> addMemberToTrip({
    required String tripId,
    required String friendId,
  }) async {
    try {
      final response = await _dio.post(
        '/mobile/split-track/trips/$tripId/members',
        data: {'friendId': friendId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      }

      throw Exception('Failed to add member to trip');
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> deleteMemberToTrip({
    required String tripId,
    required String memberId,
  }) async {
    try {
      final response = await _dio.delete(
        '/mobile/split-track/trips/$tripId/members/$memberId',
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      }

      throw Exception('Failed to Remove Member');
    } catch (e) {
      rethrow;
    }
  }
}
