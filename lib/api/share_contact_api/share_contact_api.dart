import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';

class ShareContactApi {
  static final Dio _dio = DioClient().dio;
}
