import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact/contact_model.dart';

class ContactApi {
  static final Dio _dio = DioClient().dio;

  static Future<ContactResponse> getEventList(String endPoint) async {
    try {
      final response = await _dio.get(endPoint);

      if (response.statusCode == 200) {
        return ContactResponse.fromList(response.data);
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "Something went wrong",
      );
    } catch (e) {
      LoggerService.loggerInstance.e(e);
      rethrow;
    }
  }
}
