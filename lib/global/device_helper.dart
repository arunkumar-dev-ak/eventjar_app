import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:eventjar/logger_service.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceIdHelper {
  static const String _deviceIdKey = 'device_id';
  static final Uuid _uuid = Uuid();

  static Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();

    String? savedId = prefs.getString(_deviceIdKey);
    if (savedId != null) return savedId;

    // ✅ Simple random UUID v4 - Globally unique, no namespace needed
    final deviceId = _uuid.v4();

    LoggerService.loggerInstance.dynamic_d(deviceId);

    await prefs.setString(_deviceIdKey, deviceId);
    return deviceId;
  }
}

Future<String> getDeviceModel() async {
  final deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    return '${androidInfo.model} (Android)';
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    return '${iosInfo.utsname.machine} (IOS)';
  }

  return 'MyEventJar Mobile App';
}
