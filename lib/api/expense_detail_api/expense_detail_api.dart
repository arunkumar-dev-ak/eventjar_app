import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/model/expense_detail/expense_detail_model.dart';

class ExpenseDetailApi {
  static final Dio _dio = DioClient().dio;

  static Future<ExpenseParticipantResponseModel> getParticipants({
    required String expenseId,
    required int limit,
    required int offset,
  }) async {
    try {
      final response = await _dio.get(
        '/mobile/budget-track/trip-expense/participants',
        queryParameters: {
          'expenseId': expenseId,
          'limit': limit,
          'offset': offset,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ExpenseParticipantResponseModel.fromJson(response.data);
      }

      throw Exception('Failed to fetch expense participants');
    } catch (e) {
      rethrow;
    }
  }
}
