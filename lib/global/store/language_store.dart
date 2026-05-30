import 'package:eventjar/storage/storage_service.dart';
import 'package:get/get.dart';

const String storageLanguageCode = "myEventJar_languageCode";
const String storageLanguageSelected = "myEventJar_languageSelected";

class LanguageModel {
  final String code;
  final String name;
  final String nativeName;

  const LanguageModel({
    required this.code,
    required this.name,
    required this.nativeName,
  });
}

class LanguageStore extends GetxController {
  static LanguageStore get to => Get.find<LanguageStore>();

  final _selectedLanguageCode = 'en'.obs;
  String get selectedLanguageCode => _selectedLanguageCode.value;

  final _isLanguageSelected = false.obs;
  bool get isLanguageSelected => _isLanguageSelected.value;

  final languages = <LanguageModel>[
    const LanguageModel(code: 'en', name: 'English', nativeName: 'English'),
    const LanguageModel(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी'),
    const LanguageModel(code: 'fr', name: 'French', nativeName: 'Français'),
  ].obs;

  @override
  void onInit() async {
    super.onInit();
    final saved = await StorageService.to.getString(storageLanguageCode);
    if (saved != null) {
      _selectedLanguageCode.value = saved;
    }
    final selected = await StorageService.to.getString(storageLanguageSelected);
    _isLanguageSelected.value = selected == 'true';
  }

  Future<void> setLanguage(String code) async {
    _selectedLanguageCode.value = code;
    _isLanguageSelected.value = true;
    await StorageService.to.setString(storageLanguageCode, code);
    await StorageService.to.setString(storageLanguageSelected, 'true');
  }

  void addLanguages(List<LanguageModel> apiLanguages) {
    for (final lang in apiLanguages) {
      if (!languages.any((l) => l.code == lang.code)) {
        languages.add(lang);
      }
    }
  }

  String get selectedLanguageName {
    final lang = languages.firstWhereOrNull(
      (l) => l.code == _selectedLanguageCode.value,
    );
    return lang?.name ?? 'English';
  }
}
