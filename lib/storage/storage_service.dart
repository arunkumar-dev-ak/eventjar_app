import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find<StorageService>();

  late final FlutterSecureStorage _storage;

  Future<StorageService> init() async {
    _storage = const FlutterSecureStorage();
    return this;
  }

  Future<void> setString(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (_) {
      // Swallow plugin-attachment race / keystore errors so a single
      // storage failure can't crash the app at startup.
    }
  }

  Future<String?> getString(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteString(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (_) {}
  }
}
