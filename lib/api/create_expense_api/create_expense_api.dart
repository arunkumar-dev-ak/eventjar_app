import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/budget_track/drop_down_response_model.dart';

class CreateExpenseApi {
  static final Dio _dio = DioClient().dio;

  static Future<DropdownMemberResponseModel> getDropdownMembers({
    required Map<String, dynamic> queryParams,
  }) async {
    try {
      final response = await _dio.get(
        '/mobile/budget-track/dropdown-member-list',
        queryParameters: queryParams,
      );
      return DropdownMemberResponseModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> updateExpense({
    required String expenseId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.put(
        '/mobile/split-track/expenses/$expenseId',
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      }

      throw Exception('Failed to update expense');
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> createExpense({
    required Map<String, dynamic> data,
  }) async {
    LoggerService.loggerInstance.dynamic_d(data);
    try {
      final response = await _dio.post(
        '/mobile/split-track/expenses/from-trip-members',
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      }
    } catch (e) {
      rethrow;
    }
  }
}
