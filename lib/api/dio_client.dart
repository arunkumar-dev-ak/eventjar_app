import 'package:dio/dio.dart';
import 'package:eventjar/global/global_values.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/auth/refresh_token_model.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  late Dio dio;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: backendBaseUrl(),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'X-Client-Platform': 'mobile',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        // ✅ Add Authorization header to every request
        onRequest: (options, handler) async {
          final token = UserStore.to.accessToken;
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },

        // ✅ TOKEN REFRESH LOGIC
        onError: (DioException e, ErrorInterceptorHandler handler) async {
          if (e.requestOptions.path == '/auth/refresh-token') {
            return handler.next(e);
          }

          LoggerService.loggerInstance.dynamic_d(
            'e.requestOptions.path ${e.response?.statusCode}',
          );

          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.sendTimeout ||
              e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.unknown) {
            LoggerService.loggerInstance.e("🌐 NO INTERNET: ${e.message}");
            return handler.reject(
              DioException(
                requestOptions: e.requestOptions,
                error: 'No Internet Connection',
                type: DioExceptionType.connectionError,
                message: 'No Internet Connection',
              ),
            );
          }

          if (e.response?.statusCode == 401) {
            final refreshToken = UserStore.to.refreshToken;

            LoggerService.loggerInstance.dynamic_d(
              'previous refreshToken is $refreshToken',
            );

            if (refreshToken.isEmpty) {
              return handler.next(e);
            }

            try {
              // ✅ Refresh token call
              final refreshResponse = await dio.post(
                '/auth/refresh-token',
                options: Options(
                  headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Client-Platform': 'mobile',
                    'X-Device-Id': UserStore.to.deviceId,
                    'X-Client-Type': 'mobile',
                  },
                ),
                data: {'refreshToken': refreshToken},
              );

              if (refreshResponse.statusCode == 200 ||
                  refreshResponse.statusCode == 201) {
                final loginResponse = RefreshTokenResponse.fromJson(
                  refreshResponse.data,
                );

                LoggerService.loggerInstance.dynamic_d(
                  'handling set local data',
                );

                await UserStore.to.handleSetLocalDataForRefreshToken(
                  loginResponse,
                );

                final newAccessToken = loginResponse.accessToken;

                LoggerService.loggerInstance.dynamic_d(
                  'newAccessToken is $newAccessToken',
                );

                final options = e.requestOptions.copyWith(
                  headers: {
                    ...e.requestOptions.headers,
                    'Authorization': 'Bearer $newAccessToken',
                  },
                );

                final response = await dio.request(
                  options.path,
                  data: options.data,
                  queryParameters: options.queryParameters,
                  options: Options(
                    method: options.method,
                    headers: options.headers,
                  ),
                );

                return handler.resolve(response);
              }
            } catch (refreshError) {
              LoggerService.loggerInstance.e(
                'Token refresh failed: $refreshError',
              );
            }
          }

          if (e.response?.statusCode == 500 ||
              e.response?.statusCode == 503 ||
              e.response?.statusCode == 502) {
            LoggerService.loggerInstance.e(
              "🛑 Server Error: ${e.response?.statusCode}",
            );

            return handler.reject(
              DioException(
                requestOptions: e.requestOptions,
                error: 'Server Error. Please try again later.',
                type: DioExceptionType.badResponse,
                response: e.response,
                message: 'Server Error (${e.response?.statusCode})',
              ),
            );
          }

          // ✅ 5. Pass all other errors through
          LoggerService.loggerInstance.dynamic_d(
            '❌ API Error: ${e.response?.statusCode} - ${e.message}',
          );

          return handler.next(e);
        },
      ),
    );
  }
}
