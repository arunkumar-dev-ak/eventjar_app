import 'package:eventjar/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const String storageThemeMode = "myEventJar_themeMode";

class ThemeStore extends GetxController {
  static ThemeStore get to => Get.find<ThemeStore>();

  final _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;

  @override
  void onInit() async {
    super.onInit();
    String? saved = await StorageService.to.getString(storageThemeMode);
    if (saved == "dark") {
      _isDarkMode.value = true;
      Get.changeThemeMode(ThemeMode.dark);
    }
  }

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    if (_isDarkMode.value) {
      Get.changeThemeMode(ThemeMode.dark);
      StorageService.to.setString(storageThemeMode, "dark");
    } else {
      Get.changeThemeMode(ThemeMode.light);
      StorageService.to.setString(storageThemeMode, "light");
    }
  }
}
