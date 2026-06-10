import 'dart:ui';

import 'package:eventjar/global/global_values.dart';
import 'package:eventjar/model/language/language_model.dart';
import 'package:eventjar/services/translation_service.dart';
import 'package:eventjar/storage/storage_service.dart';
import 'package:get/get.dart';

class LanguageStore extends GetxController {
  static LanguageStore get to => Get.find<LanguageStore>();

  final _selectedLanguageCode = 'en'.obs;
  String get selectedLanguageCode => _selectedLanguageCode.value;

  final _isLanguageSelected = false.obs;
  bool get isLanguageSelected => _isLanguageSelected.value;

  final isLoadingLanguages = false.obs;

  late final Future<void> initCompleted;

  static const _defaultLanguages = [
    LanguageModel(code: 'en', name: 'English', nativeName: 'English'),
  ];

  final languages = <LanguageModel>[..._defaultLanguages].obs;

  @override
  void onInit() {
    super.onInit();
    initCompleted = _init();
  }

  Future<void> _init() async {
    // 1. Restore saved language code
    final saved = await StorageService.to.getString(storageLanguageCode);
    var hadCache = false;
    if (saved != null) {
      _selectedLanguageCode.value = saved;
      hadCache = await TranslationService.loadCachedLanguage(saved);
      Get.updateLocale(locale);
    }
    final selected = await StorageService.to.getString(storageLanguageSelected);
    _isLanguageSelected.value = selected == 'true';

    if (saved != null && saved != 'en') {
      final success = await TranslationService.fetchAndApply(saved);
      if (!success && !hadCache) {
        await _fallbackToEnglish();
      }
    }

    // 2. Load cached language list, then refresh from API
    final cached = await TranslationService.loadCachedLanguages();
    if (cached != null && cached.isNotEmpty) {
      _applyLanguageList(cached);
    }
    await _fetchLanguageList();
  }

  Future<void> setLanguage(String code) async {
    _selectedLanguageCode.value = code;
    _isLanguageSelected.value = true;
    await StorageService.to.setString(storageLanguageCode, code);
    await StorageService.to.setString(storageLanguageSelected, 'true');

    if (code == 'en') {
      Get.updateLocale(const Locale('en'));
      return;
    }

    // Load from cache first (instant UI switch)
    final hadCache = await TranslationService.loadCachedLanguage(code);
    if (hadCache) {
      Get.updateLocale(locale);
    }

    // Fetch latest translations; fallback to English if fetch fails
    final success = await TranslationService.fetchAndApply(code);
    if (success) {
      Get.updateLocale(locale);
    } else if (!hadCache) {
      await _fallbackToEnglish();
    }
  }

  Future<void> _fallbackToEnglish() async {
    _selectedLanguageCode.value = 'en';
    await StorageService.to.setString(storageLanguageCode, 'en');
    Get.updateLocale(const Locale('en'));
  }

  Future<void> _fetchLanguageList() async {
    isLoadingLanguages.value = true;
    final apiLangs = await TranslationService.fetchLanguages();
    if (apiLangs != null) {
      _applyLanguageList(apiLangs);
    }
    isLoadingLanguages.value = false;
  }

  void _applyLanguageList(List<LanguageModel> langList) {
    if (!langList.any((l) => l.code == 'en')) {
      langList.insert(
        0,
        const LanguageModel(code: 'en', name: 'English', nativeName: 'English'),
      );
    }

    languages.value = langList;
  }

  /// Refresh language list manually (e.g. pull-to-refresh on settings page)
  Future<void> refreshLanguages() async {
    await _fetchLanguageList();
  }

  String get selectedLanguageName {
    final lang = languages.firstWhereOrNull(
      (l) => l.code == _selectedLanguageCode.value,
    );
    return lang?.name ?? 'English';
  }

  String get selectedLanguageNativeName {
    final lang = languages.firstWhereOrNull(
      (l) => l.code == _selectedLanguageCode.value,
    );
    return lang?.nativeName ?? 'English';
  }

  Locale get locale {
    final code = _selectedLanguageCode.value;
    if (code.contains('_')) {
      final parts = code.split('_');
      return Locale.fromSubtags(languageCode: parts[0], scriptCode: parts[1]);
    }
    return Locale(code);
  }
}
