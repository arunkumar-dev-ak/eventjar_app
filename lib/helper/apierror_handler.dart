import 'package:dio/dio.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/logger_service.dart';

class ApiErrorHandler {
  static void handleError(DioException err, String? title) {
    LoggerService.loggerInstance.e("Error: ${err.runtimeType}, ${err.type}");

    String errorMessage;

    // ✅ 1. NETWORK ERRORS - Use predefined messages (NO title needed)
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.unknown ||
        err.message?.contains('No Internet') == true) {
      errorMessage = "No Internet Connection";
    }
    // ✅ 2. SERVER ERRORS - Use predefined message
    else if (err.response?.statusCode == 500 ||
        err.response?.statusCode == 502 ||
        err.response?.statusCode == 503 ||
        err.response?.statusCode == 504) {
      errorMessage = "Server Error. Please try again later.";
    }
    // ✅ 3. API RESPONSE ERRORS - Extract from response
    else {
      final data = err.response?.data;

      if (data != null) {
        final message = data['message'];

        // Case 1: Simple string
        if (message is String) {
          errorMessage = message;
        }
        // Case 2: Nested message map
        else if (message is Map) {
          final innerMessage = message['message'];

          if (innerMessage is String) {
            errorMessage = innerMessage;
          } else if (innerMessage is List && innerMessage.isNotEmpty) {
            errorMessage = innerMessage.first.toString();
          } else {
            errorMessage = message.values.first.toString();
          }
        }
        // Case 3: Direct data error
        else {
          errorMessage =
              data['error']?.toString() ??
              data['detail']?.toString() ??
              "Something went wrong";
        }
      } else {
        errorMessage = err.message ?? "Something went wrong";
      }
    }

    // ✅ Show snackbar WITHOUT title for network/server errors
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.unknown ||
        err.response?.statusCode == 500 ||
        err.response?.statusCode == 502 ||
        err.response?.statusCode == 503 ||
        err.response?.statusCode == 504) {
      AppSnackbar.warning(message: errorMessage); // ✅ NO title
    } else {
      AppSnackbar.error(title: title ?? "Error", message: errorMessage);
    }
  }
}
