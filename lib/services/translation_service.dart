import 'dart:convert';

import 'package:eventjar/api/translation_api/translation_api.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/language/language_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _cacheKeyPrefix = 'translations_';
const String _versionKeyPrefix = 'translations_version_';
const String _languageListKey = 'cached_language_list';

class TranslationService extends Translations {
  static Map<String, String> _enTranslations = {};

  @override
  Map<String, Map<String, String>> get keys => {
        'en': _enTranslations,
      };

  /// Load English translations from the bundled JSON file.
  /// Must be called before runApp().
  static Future<void> init() async {
    final jsonString = await rootBundle.loadString('lib/lang/english_lang.json');
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    _enTranslations = Map<String, String>.from(data['translations'] as Map);
  }

  // ---------------------------------------------------------------------------
  // Cache: load / save translations
  // ---------------------------------------------------------------------------

  static Future<bool> loadCachedLanguage(String langCode) async {
    if (langCode == 'en') return false;

    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('$_cacheKeyPrefix$langCode');
    if (cached == null) return false;

    try {
      final map = Map<String, String>.from(jsonDecode(cached) as Map);
      Get.addTranslations({langCode: map});
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<void> _saveToCache(
    String langCode,
    Map<String, String> translations,
    String version,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '$_cacheKeyPrefix$langCode',
      jsonEncode(translations),
    );
    await prefs.setString('$_versionKeyPrefix$langCode', version);
  }

  static Future<String> _getCachedVersion(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('$_versionKeyPrefix$langCode') ?? '';
  }

  // ---------------------------------------------------------------------------
  // Fetch translations with version check
  // ---------------------------------------------------------------------------

  static Future<void> fetchAndApply(String langCode) async {
    if (langCode == 'en') return;

    try {
      final cachedVersion = await _getCachedVersion(langCode);

      final response = await TranslationApi.getTranslations(langCode);

      if (response.version == cachedVersion) return;

      Get.addTranslations({langCode: response.translations});
      await _saveToCache(langCode, response.translations, response.version);

      Get.updateLocale(_parseLocale(langCode));
    } catch (e) {
      LoggerService.loggerInstance.e("Translation fetch error ($langCode): $e");
    }
  }

  // ---------------------------------------------------------------------------
  // Fetch available languages list
  // ---------------------------------------------------------------------------

  static Future<List<LanguageModel>?> fetchLanguages() async {
    try {
      final list = await TranslationApi.getLanguages();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _languageListKey,
        jsonEncode(list.map((e) => e.toJson()).toList()),
      );

      return list;
    } catch (e) {
      LoggerService.loggerInstance.e("Language list fetch error: $e");
      return null;
    }
  }

  static Future<List<LanguageModel>?> loadCachedLanguages() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_languageListKey);
    if (cached == null) return null;

    try {
      return (jsonDecode(cached) as List)
          .map((e) => LanguageModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  static Future<void> clearCache(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_cacheKeyPrefix$langCode');
    await prefs.remove('$_versionKeyPrefix$langCode');
  }

  static Locale _parseLocale(String code) {
    if (code.contains('_')) {
      final parts = code.split('_');
      return Locale.fromSubtags(languageCode: parts[0], scriptCode: parts[1]);
    }
    return Locale(code);
  }
}
