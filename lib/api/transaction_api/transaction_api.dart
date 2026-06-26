import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/model/transaction/transaction_model.dart';

class TransactionApi {
  static final Dio _dio = DioClient().dio;

  static Future<TransactionResponse> getTransactions({
    required Map<String, dynamic> queryParams,
  }) async {
    try {
      final response = await _dio.get(
        '/mobile/budget-track/transactions',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TransactionResponse.fromJson(response.data);
      }

      throw Exception('Failed to fetch transactions');
    } catch (e) {
      rethrow;
    }
  }
}
