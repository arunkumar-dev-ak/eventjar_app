import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';

class SentReceivedApi {
  static final Dio _dio = DioClient().dio;
}
