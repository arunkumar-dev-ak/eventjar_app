import 'dart:io';
import 'package:eventjar/model/contact/nfc_contact_model.dart';
import 'package:eventjar/model/contact/qr_contact_model.dart';
import 'package:flutter/foundation.dart';
import 'package:nfc_manager/ndef_record.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager_ndef/nfc_manager_ndef.dart';

enum NfcStatus { available, notAvailable, disabled, unknown }

class NfcService {
  static final NfcService _instance = NfcService._internal();
  factory NfcService() => _instance;
  NfcService._internal();

  bool _isSessionActive = false;

  /// Check if NFC is available on this device
  Future<bool> isNfcAvailable() async {
    final availability = await NfcManager.instance.checkAvailability();
    return availability == NfcAvailability.enabled;
  }

  /// Get detailed NFC status
  Future<NfcStatus> getNfcStatus() async {
    try {
      final availability = await NfcManager.instance
          .checkAvailability()
          .timeout(
            const Duration(seconds: 3),
            onTimeout: () => NfcAvailability.unsupported,
          );

      if (availability == NfcAvailability.enabled) {
        return NfcStatus.available;
      } else {
        // notSupported, disabled, restricted, etc.
        return NfcStatus.notAvailable;
      }
    } catch (e) {
      debugPrint('Error checking NFC status: $e');
      return NfcStatus.notAvailable;
    }
  }

  /// Start NFC session to read contacts
  /// Returns the contact when an NFC tag is read, or null if parsing fails
  Future<void> startReadSession({
    required Function(NfcContactModel contact) onContactReceived,
    required Function(String error) onError,
    Function()? onSessionStarted,
  }) async {
    if (_isSessionActive) {
      await stopSession();
    }

    try {
      _isSessionActive = true;
      onSessionStarted?.call();

      await NfcManager.instance.startSession(
        pollingOptions: {
          NfcPollingOption.iso14443,
          // add others if you need them:
          // NfcPollingOption.iso15693,
          // NfcPollingOption.iso18092,
        },
        onDiscovered: (NfcTag tag) async {
          try {
            final ndef = Ndef.from(tag); // from nfc_manager_ndef
            if (ndef == null) {
              onError('This NFC tag does not contain readable data');
              return;
            }

            final message = await ndef.read();
            //need to do the optional condituon
            final contact = NfcContactModel.fromNdefMessage(message!);

            if (contact != null) {
              onContactReceived(contact);
            } else {
              onError('Could not parse contact information from this tag');
            }
          } catch (e) {
            onError('Error reading NFC tag: $e');
          }
        },
        onSessionErrorIos: (error) async {
          _isSessionActive = false;
          onError(error.message);
        },
      );
    } catch (e) {
      _isSessionActive = false;
      onError('Failed to start NFC session: $e');
    }
  }

  Future<void> startWriteSession({
    required NfcContactModel contact,
    required Function() onWriteSuccess,
    required Function(String error) onError,
    Function()? onSessionStarted,
  }) async {
    if (_isSessionActive) {
      await stopSession();
    }

    // iOS cannot write to NFC tags
    if (Platform.isIOS) {
      onError(
        'iOS does not support writing to NFC tags. Use an Android device to write contacts to NFC cards.',
      );
      return;
    }

    try {
      _isSessionActive = true;
      onSessionStarted?.call();

      await NfcManager.instance.startSession(
        pollingOptions: {
          NfcPollingOption.iso14443,
          // add more if your tags need it:
          // NfcPollingOption.iso15693,
          // NfcPollingOption.iso18092,
        },
        onDiscovered: (NfcTag tag) async {
          try {
            final ndef = Ndef.from(tag); // from nfc_manager_ndef
            if (ndef == null) {
              onError('This NFC tag does not support NDEF format');
              return;
            }

            if (!ndef.isWritable) {
              onError('This NFC tag is read-only');
              return;
            }

            final message = NdefMessage(records: [contact.toNdefRecord()]);
            final messageSize = message.byteLength;

            if (messageSize > ndef.maxSize) {
              onError(
                'Contact data is too large for this NFC tag ($messageSize bytes, max ${ndef.maxSize} bytes)',
              );
              return;
            }

            await ndef.write(message: message);
            onWriteSuccess();
          } catch (e) {
            onError('Error writing to NFC tag: $e');
          }
        },
        onSessionErrorIos: (error) async {
          _isSessionActive = false;
          onError(error.message);
        },
      );
    } catch (e) {
      _isSessionActive = false;
      onError('Failed to start NFC write session: $e');
    }
  }

  /// Stop active NFC session
  Future<void> stopSession() async {
    if (_isSessionActive) {
      try {
        await NfcManager.instance.stopSession();
      } catch (e) {
        debugPrint('Error stopping NFC session: $e');
      }
      _isSessionActive = false;
    }
  }

  /// Check if a session is currently active
  bool get isSessionActive => _isSessionActive;
}
