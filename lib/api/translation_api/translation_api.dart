import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/model/language/language_model.dart';
import 'package:eventjar/model/language/translation_response_model.dart';

class TranslationApi {
  static final Dio _dio = DioClient().dio;

  static Future<TranslationResponse> getTranslations(String langCode) async {
    try {
      final response = await _dio.get(
        '/i18n/$langCode/all',
        options: Options(headers: {'X-Platform': 'mobile'}),
      );

      if (response.statusCode == 200) {
        return TranslationResponse.fromJson(response.data);
      }

      throw Exception(
        response.data?['message'] ?? 'Failed to fetch translations',
      );
    } catch (e) {
      rethrow;
    }
  }

  // Implement when API is ready
  static Future<List<LanguageModel>> getLanguages() async {
    try {
      final response = await _dio.get('/mobile/translations/languages');

      if (response.statusCode == 200) {
        return (response.data['languages'] as List)
            .map((e) => LanguageModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw Exception(response.data?['message'] ?? 'Failed to fetch languages');
    } catch (e) {
      rethrow;
    }
  }
}
