import 'package:eventjar/logger_service.dart';
import 'package:play_install_referrer/play_install_referrer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReferrerService {
  static const _key = "referrer_checked";

  static Future<String?> getInviteTokenIfAny() async {
    final prefs = await SharedPreferences.getInstance();

    final alreadyChecked = prefs.getBool(_key) ?? false;
    if (alreadyChecked) return null;

    try {
      final referrerDetails = await PlayInstallReferrer.installReferrer;
      final referrer = referrerDetails.installReferrer;

      if (referrer == null || referrer.isEmpty) {
        await prefs.setBool(_key, true);
        return null;
      }

      Uri uri;
      try {
        uri = Uri.parse("?$referrer");
      } catch (_) {
        await prefs.setBool(_key, true);
        return null;
      }

      final token = uri.queryParameters['invite_token'];

      await prefs.setBool(_key, true);

      if (token == null || token.isEmpty) return null;

      return token;
    } catch (e) {
      LoggerService.loggerInstance.e(e);
    }

    await prefs.setBool(_key, true);
    return null;
  }
}
