import 'dart:convert';
import 'dart:typed_data';

import 'package:nfc_manager/ndef_record.dart';

class NfcContactModel {
  final String name;
  final String phone;
  final String email;
  final String note;

  NfcContactModel({
    required this.name,
    required this.phone,
    this.email = '',
    this.note = '',
  });

  /// Convert contact to vCard format string
  String toVCard() {
    final buffer = StringBuffer();
    buffer.writeln('BEGIN:VCARD');
    buffer.writeln('VERSION:3.0');
    buffer.writeln('FN:$name');
    if (phone.isNotEmpty) {
      buffer.writeln('TEL:$phone');
    }
    if (email.isNotEmpty) {
      buffer.writeln('EMAIL:$email');
    }
    if (note.isNotEmpty) {
      buffer.writeln('NOTE:$note');
    }
    buffer.writeln('END:VCARD');
    return buffer.toString();
  }

  /// Parse contact from vCard format string
  static NfcContactModel? fromVCard(String vCardString) {
    String name = '';
    String phone = '';
    String email = '';
    String note = '';

    final lines = vCardString.split(RegExp(r'\r?\n'));
    for (final line in lines) {
      if (line.startsWith('FN:')) {
        name = line.substring(3).trim();
      } else if (line.startsWith('TEL:') || line.startsWith('TEL;')) {
        // Handle TEL:+123 or TEL;TYPE=CELL:+123
        final colonIndex = line.indexOf(':');
        if (colonIndex != -1) {
          phone = line.substring(colonIndex + 1).trim();
        }
      } else if (line.startsWith('EMAIL:') || line.startsWith('EMAIL;')) {
        final colonIndex = line.indexOf(':');
        if (colonIndex != -1) {
          email = line.substring(colonIndex + 1).trim();
        }
      } else if (line.startsWith('NOTE:')) {
        note = line.substring(5).trim();
      } else if (line.startsWith('N:')) {
        // Fallback: parse N field if FN is empty
        // N format: LastName;FirstName;MiddleName;Prefix;Suffix
        if (name.isEmpty) {
          final parts = line.substring(2).split(';');
          final lastName = parts.isNotEmpty ? parts[0].trim() : '';
          final firstName = parts.length > 1 ? parts[1].trim() : '';
          name = '$firstName $lastName'.trim();
        }
      }
    }

    if (name.isEmpty && phone.isEmpty) {
      return null;
    }

    return NfcContactModel(
      name: name.isNotEmpty ? name : 'Unknown',
      phone: phone,
      email: email,
      note: note,
    );
  }

  /// Create NDEF record from contact
  NdefRecord toNdefRecord() {
    final vCard = toVCard();
    final payload = utf8.encode(vCard);

    return NdefRecord(
      typeNameFormat: TypeNameFormat.media,
      type: Uint8List.fromList(utf8.encode('text/vcard')),
      identifier: Uint8List(0),
      payload: Uint8List.fromList(payload),
    );
  }

  /// Parse contact from NDEF message
  static NfcContactModel? fromNdefMessage(NdefMessage message) {
    for (final record in message.records) {
      // Check for vCard MIME type
      final typeString = utf8.decode(record.type);
      if (record.typeNameFormat == TypeNameFormat.media &&
          (typeString.toLowerCase() == 'text/vcard' ||
              typeString.toLowerCase() == 'text/x-vcard')) {
        final payload = utf8.decode(record.payload);
        return fromVCard(payload);
      }

      // Also try to parse as text record (some cards use this)
      if (record.typeNameFormat == TypeNameFormat.wellKnown) {
        final typeStr = utf8.decode(record.type);
        if (typeStr == 'T') {
          // Text record: first byte is language code length
          final languageCodeLength = record.payload[0];
          final textPayload = utf8.decode(
            record.payload.sublist(1 + languageCodeLength),
          );
          // Check if it looks like a vCard
          if (textPayload.contains('BEGIN:VCARD')) {
            return fromVCard(textPayload);
          }
        }
      }
    }
    return null;
  }

  @override
  String toString() {
    return 'Contact(name: $name, phone: $phone, email: $email, note: $note)';
  }
}
