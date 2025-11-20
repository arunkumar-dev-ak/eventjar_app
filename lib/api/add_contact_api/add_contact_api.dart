import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/logger_service.dart';

class AddContactApi {
  static final Dio _dio = DioClient().dio;

  static Future<void> registerTicket({dynamic data}) async {
    try {
      final response = await _dio.post('/contacts', data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackbar.success(
          title: "Contact Added",
          message: response.data['message'] ?? "Contact added successfully!",
        );
        return;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> updateContact({dynamic data, required String id}) async {
    try {
      final response = await _dio.put('/contacts/$id', data: data);

      LoggerService.loggerInstance.dynamic_d(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackbar.success(
          title: "Contact Updated",
          message: "Contact Updated successfully!",
        );
        return;
      }
    } catch (e) {
      rethrow;
    }
  }
}
