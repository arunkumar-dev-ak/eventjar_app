import 'package:eventjar/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const String storageThemeMode = "myEventJar_themeMode";

class ThemeStore extends GetxController {
  static ThemeStore get to => Get.find<ThemeStore>();

  final _themeMode = ThemeMode.system.obs;
  ThemeMode get themeMode => _themeMode.value;
  bool get isDarkMode => _themeMode.value == ThemeMode.dark;

  @override
  void onInit() async {
    super.onInit();
    String? saved = await StorageService.to.getString(storageThemeMode);
    if (saved == "dark") {
      _themeMode.value = ThemeMode.dark;
      Get.changeThemeMode(ThemeMode.dark);
    } else if (saved == "light") {
      _themeMode.value = ThemeMode.light;
      Get.changeThemeMode(ThemeMode.light);
    } else {
      _themeMode.value = ThemeMode.system;
      Get.changeThemeMode(ThemeMode.system);
    }
  }

  void toggleTheme() {
    if (_themeMode.value == ThemeMode.dark) {
      _setTheme(ThemeMode.light);
    } else {
      _setTheme(ThemeMode.dark);
    }
  }

  void cycleTheme() {
    switch (_themeMode.value) {
      case ThemeMode.light:
        _setTheme(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        _setTheme(ThemeMode.system);
        break;
      case ThemeMode.system:
        _setTheme(ThemeMode.light);
        break;
    }
  }

  void setThemeMode(ThemeMode mode) => _setTheme(mode);

  void _setTheme(ThemeMode mode) {
    _themeMode.value = mode;
    Get.changeThemeMode(mode);
    StorageService.to.setString(storageThemeMode, mode.name);
  }
}
