import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  static const String _prefix = 'eventjar';
  static final _key = encrypt.Key.fromUtf8(
    'QRContactApp2024SecureKey1234567',
  ); // 32 chars
  static final _iv = encrypt.IV.fromUtf8(
    'QRContactIV12345',
  ); // 16 chars fixed IV
  static final _encrypter = encrypt.Encrypter(encrypt.AES(_key));

  // Encrypt plain text using AES-256
  static String encryptText(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  // Decrypt AES-256 encrypted text
  static String decrypt(String encryptedText) {
    try {
      final encrypted = encrypt.Encrypted.fromBase64(encryptedText);
      return _encrypter.decrypt(encrypted, iv: _iv);
    } catch (e) {
      return encryptedText;
    }
  }

  // Generate a unique 15-character alphanumeric code
  static String _generateCode(Map<String, dynamic> data) {
    final jsonString = jsonEncode(data);
    // Create a hash-like code from the data
    final bytes = utf8.encode(jsonString);
    int hash = 0;
    for (var byte in bytes) {
      hash = ((hash << 5) - hash + byte) & 0xFFFFFFFF;
    }

    // Convert to alphanumeric (base36)
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String code = '';
    int value = hash.abs();

    // Generate first 7 chars from hash
    for (int i = 0; i < 7; i++) {
      code += chars[value % 36];
      value ~/= 36;
      if (value == 0) value = hash.abs() + i;
    }

    // Generate remaining 8 chars from timestamp for uniqueness
    int timestamp = DateTime.now().microsecondsSinceEpoch;
    for (int i = 0; i < 8; i++) {
      code += chars[timestamp % 36];
      timestamp ~/= 36;
    }

    return code;
  }

  // Local cache to store encrypted data mappings
  static final Map<String, Map<String, dynamic>> _dataStore = {};

  /// Encrypt JSON data and return eventjar + 15 char code
  static String encryptJson(Map<String, dynamic> data) {
    final code = _generateCode(data);
    final fullCode = '$_prefix$code';

    // Store the data mapping
    _dataStore[fullCode] = data;

    return fullCode;
  }

  // Decrypt eventjar code back to JSON data
  static Map<String, dynamic>? decryptJson(String encryptedText) {
    try {
      // Check if it's our format (starts with eventjar)
      if (encryptedText.startsWith(_prefix)) {
        // Look up in data store
        if (_dataStore.containsKey(encryptedText)) {
          return _dataStore[encryptedText];
        }
        return null;
      }

      // Fallback: try AES decryption for backward compatibility
      final decrypted = decrypt(encryptedText);
      return jsonDecode(decrypted) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  // Store data for a given code (used when scanning from external source)
  static void storeData(String code, Map<String, dynamic> data) {
    _dataStore[code] = data;
  }

  // Check if code exists in store
  static bool hasCode(String code) {
    return _dataStore.containsKey(code);
  }
}
