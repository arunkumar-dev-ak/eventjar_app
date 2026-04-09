import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:eventjar/global/global_values.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/storage/storage_service.dart';

String generateCodeVerifier() {
  const chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
  final rand = Random.secure();
  return List.generate(64, (_) => chars[rand.nextInt(chars.length)]).join();
}

Future<String> generateCodeChallenge() async {
  String verifier = generateCodeVerifier();

  final bytes = utf8.encode(verifier);
  final digest = sha256.convert(bytes);

  final codeChallenge = base64UrlEncode(digest.bytes).replaceAll('=', '');

  await StorageService.to.setString(pkceCodeVerifier, verifier);
  LoggerService.loggerInstance.dynamic_d(
    await StorageService.to.getString(pkceCodeVerifier),
  );
  return codeChallenge;
}
