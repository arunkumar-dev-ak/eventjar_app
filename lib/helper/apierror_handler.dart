import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/logger_service.dart';
import 'package:get/get.dart';

class ApiErrorHandler {
  static void handle({
    required dynamic error,
    String title = "Error",
    VoidCallback? onUnauthorized,
  }) {
    LoggerService.loggerInstance.e(error);

    if (error is DioException) {
      final statusCode = error.response?.statusCode;

      // 401
      if (statusCode == 401) {
        onUnauthorized?.call();
        return;
      }

      handleDioError(error, title);
      return;
    }

    if (error is Exception) {
      AppSnackbar.error(title: title, message: error.toString());
      return;
    }

    AppSnackbar.error(
      title: title,
      message: "Something went wrong (${error.runtimeType})",
    );
  }

  static void handleDioError(DioException err, String? title) {
    String errorMessage;

    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.message?.contains('No Internet') == true) {
      errorMessage = "No Internet Connection";
    } else if (err.response?.statusCode == 500 ||
        err.response?.statusCode == 502 ||
        err.response?.statusCode == 503 ||
        err.response?.statusCode == 504) {
      errorMessage = "Server Error. Please try again later.";
    } else {
      final data = err.response?.data;

      if (data is String) {
        errorMessage = data;
      } else if (data is Map) {
        final message = data['message'];

        if (message is String) {
          errorMessage = message;
        } else if (message is Map) {
          final innerMessage = message['message'];

          if (innerMessage is String) {
            errorMessage = innerMessage;
          } else if (innerMessage is List && innerMessage.isNotEmpty) {
            errorMessage = innerMessage.first.toString();
          } else {
            errorMessage = message.values.first.toString();
          }
        } else {
          errorMessage =
              data['error']?.toString() ??
              data['detail']?.toString() ??
              "something_went_wrong".tr;
        }
      } else {
        errorMessage = err.message ?? "something_went_wrong".tr;
      }
    }

    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.unknown ||
        err.response?.statusCode == 500 ||
        err.response?.statusCode == 502 ||
        err.response?.statusCode == 503 ||
        err.response?.statusCode == 504) {
      AppSnackbar.warning(title: title ?? "error".tr, message: errorMessage);
    } else {
      AppSnackbar.error(title: title ?? "error".tr, message: errorMessage);
    }
  }
}
