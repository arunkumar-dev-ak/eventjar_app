import 'package:dio/dio.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/logger_service.dart';

class ApiErrorHandler {
  static void handleError(DioException err, String title) {
    LoggerService.loggerInstance.dynamic_d("Error is");
    LoggerService.loggerInstance.e(err.response?.data);

    final data = err.response?.data;
    String errorMessage = "Something went wrong";

    if (data != null) {
      final message = data['message'];

      // Case 1: message is a simple string
      if (message is String) {
        errorMessage = message;
      }
      // Case 2: message is a map
      else if (message is Map) {
        final innerMessage = message['message'];

        // Case 2a: inner message is a simple string
        if (innerMessage is String) {
          errorMessage = innerMessage;
        }
        // Case 2b: inner message is a list → take first item
        else if (innerMessage is List && innerMessage.isNotEmpty) {
          final first = innerMessage.first;

          if (first is String) {
            errorMessage = first;
          }
        }
      }
    }

    AppSnackbar.error(title: title, message: errorMessage);
  }
}
