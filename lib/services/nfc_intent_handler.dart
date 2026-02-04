import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:eventjar/model/contact/nfc_contact_model.dart';

class NfcIntentHandler with WidgetsBindingObserver {
  static const MethodChannel _channel =
      MethodChannel('com.myeventjar.eventjar_app/nfc');
  static final NfcIntentHandler _instance = NfcIntentHandler._internal();

  factory NfcIntentHandler() => _instance;
  NfcIntentHandler._internal();

  bool _isInitialized = false;

  // Store pending NFC intent data to process after splash screen
  Map<dynamic, dynamic>? _pendingIntentData;
  bool _isAppReady = false;
  bool _isProcessingIntent = false;

  /// Initialize the NFC intent handler
  Future<void> init() async {
    if (_isInitialized) return;

    // Set up method call handler to receive callbacks from native
    _channel.setMethodCallHandler(_handleMethodCall);

    // Register lifecycle observer to check for pending intents on resume
    WidgetsBinding.instance.addObserver(this);

    _isInitialized = true;

    // Check if app was launched via NFC intent and store it
    await _checkAndStoreInitialIntent();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isAppReady) {
      // Check for pending NFC intents when app resumes
      _checkForPendingIntent();
    }
  }

  /// Check native side for any pending NFC intent
  Future<void> _checkForPendingIntent() async {
    if (_isProcessingIntent) return;

    try {
      final Map<dynamic, dynamic>? intentData =
          await _channel.invokeMethod('getNfcIntent');
      if (intentData != null && intentData['payload'] != null) {
        debugPrint('NfcIntentHandler: Found pending intent on resume');
        _navigateForNfcIntent(intentData);
      }
    } catch (e) {
      debugPrint('NfcIntentHandler: Error checking pending intent: $e');
    }
  }

  /// Check if the app was launched with an NFC intent and store it
  Future<void> _checkAndStoreInitialIntent() async {
    try {
      final Map<dynamic, dynamic>? intentData =
          await _channel.invokeMethod('getNfcIntent');
      if (intentData != null && intentData['payload'] != null) {
        _pendingIntentData = intentData;
      }
    } catch (e) {
      debugPrint('NfcIntentHandler: Error checking initial intent: $e');
    }
  }

  /// Call this after splash screen completes and user is on dashboard
  /// This will process any pending NFC intent
  void onAppReady() {
    _isAppReady = true;
    _processPendingIntent();
  }

  /// Process any pending NFC intent
  void _processPendingIntent() {
    if (_pendingIntentData != null) {
      final intentData = _pendingIntentData;
      _pendingIntentData = null; // Clear pending data
      _navigateForNfcIntent(intentData!);
    }
  }

  /// Check if there's a pending NFC intent
  bool get hasPendingIntent => _pendingIntentData != null;

  /// Handle method calls from native side
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    debugPrint('NfcIntentHandler: Received method call: ${call.method}');
    switch (call.method) {
      case 'onNfcIntent':
        if (call.arguments != null) {
          final Map<dynamic, dynamic> intentData =
              call.arguments as Map<dynamic, dynamic>;
          debugPrint('NfcIntentHandler: Received NFC intent data: $intentData');
          _handleNewNfcIntent(intentData);
        }
        break;
    }
  }

  /// Handle new NFC intent (when app is already running)
  void _handleNewNfcIntent(Map<dynamic, dynamic> intentData) {
    debugPrint('NfcIntentHandler: isAppReady=$_isAppReady');
    if (_isAppReady) {
      // App is ready, navigate immediately
      _navigateForNfcIntent(intentData);
    } else {
      // App not ready yet, store as pending
      _pendingIntentData = intentData;
    }
  }

  /// Navigate based on NFC intent data
  void _navigateForNfcIntent(Map<dynamic, dynamic> intentData) {
    if (_isProcessingIntent) {
      debugPrint('NfcIntentHandler: Already processing an intent, skipping');
      return;
    }

    _isProcessingIntent = true;
    final String? payload = intentData['payload'];
    final String? mimeType = intentData['mimeType'];
    debugPrint(
        'NfcIntentHandler: Navigating with payload=$payload, mimeType=$mimeType');

    // Small delay to ensure navigation works properly
    Future.delayed(const Duration(milliseconds: 300), () {
      _isProcessingIntent = false;

      if (payload != null) {
        // Try to parse as vCard
        debugPrint('NfcIntentHandler: Raw payload: $payload');
        final contact = NfcContactModel.fromVCard(payload);
        debugPrint(
            'NfcIntentHandler: Parsed contact: name=${contact?.name}, phone=${contact?.phoneParsed?.phoneNumber}, email=${contact?.email}');
        if (contact != null) {
          debugPrint('NfcIntentHandler: Navigating to add contact page');
          Get.toNamed(
            RouteName.addContactPage,
            arguments: contact,
          );
        } else if (mimeType?.contains('vcard') ?? false) {
          // vCard mime type but couldn't parse - still try add contact
          Get.toNamed(RouteName.nfcReadPage);
        } else {
          // For other NFC tags, navigate to NFC read page
          Get.toNamed(RouteName.nfcReadPage);
        }
      } else {
        // No payload, navigate to NFC read page
        Get.toNamed(RouteName.nfcReadPage);
      }
    });
  }
}
