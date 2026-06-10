import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:eventjar/model/contact/qr_contact_model.dart';

class EncryptionService {
  static final _key = encrypt.Key.fromUtf8(
    'QRContactApp2024SecureKey1234567', // 32 chars
  );

  static final _encrypter = encrypt.Encrypter(
    encrypt.AES(_key, mode: encrypt.AESMode.cbc),
  );

  /// Encrypt JSON → Base64(iv + cipher)
  static String encryptJson(Map<String, dynamic> data) {
    final iv = encrypt.IV.fromSecureRandom(16);

    // final filteredData = {
    //   'name': data['name'],
    //   'phoneNumber': data['phoneNumber'],
    //   'email': data['email'],
    // };

    final filteredData = QrContactModel.fromJson({
      'name': data['name'],
      'phoneParsed': data['phoneParsed'],
      'email': data['email'],
    });

    final jsonString = jsonEncode(filteredData);

    final encrypted = _encrypter.encrypt(jsonString, iv: iv);

    // Combine IV + CipherText
    final payload = {'iv': iv.base64, 'data': encrypted.base64};

    return base64Encode(utf8.encode(jsonEncode(payload)));
  }

  /// Decrypt QR payload → JSON
  static Map<String, dynamic>? decryptJson(String qrText) {
    try {
      final decoded = utf8.decode(base64Decode(qrText));
      final payload = jsonDecode(decoded);

      final iv = encrypt.IV.fromBase64(payload['iv']);
      final encrypted = encrypt.Encrypted.fromBase64(payload['data']);

      final decrypted = _encrypter.decrypt(encrypted, iv: iv);

      return jsonDecode(decrypted);
    } catch (_) {
      return null;
    }
  }
}
