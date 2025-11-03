import 'package:dio/dio.dart';
import 'package:eventjar_app/global/global_values.dart';
import 'package:eventjar_app/global/store/user_store.dart';
import 'package:eventjar_app/routes/route_name.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;

  late Dio dio;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: url(),
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = UserStore.to.accessToken;

          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            UserStore.to.clearStore();
            Get.toNamed(RouteName.signInPage);
          }
          return handler.next(e);
        },
      ),
    );
  }
}
