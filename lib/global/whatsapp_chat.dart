// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppHelper {
  /// 🚀 Send message to WhatsApp with phone number
  ///
  /// [phoneNumber] - Phone number with country code (e.g., "+919876543210")
  /// [message] - Optional message to pre-fill (default: empty)
  /// [context] - BuildContext for error handling (optional)
  static Future<void> sendWhatsAppMessage({
    required String phoneNumber,
    String? message,
    BuildContext? context,
  }) async {
    try {
      // Clean phone number (remove spaces, dashes, etc.)
      String cleanedNumber = _cleanPhoneNumber(phoneNumber);

      // Encode message for URL
      String encodedMessage = message != null
          ? Uri.encodeComponent(message)
          : '';

      // Create WhatsApp URL
      String whatsappUrl = "https://wa.me/$cleanedNumber";

      // Add message if provided
      if (encodedMessage.isNotEmpty) {
        whatsappUrl += "?text=$encodedMessage";
      }

      final Uri uri = Uri.parse(whatsappUrl);

      // Check if WhatsApp can be launched
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // Opens in WhatsApp app
        );
      } else {
        // Fallback: Try opening WhatsApp Business
        await _tryWhatsAppBusiness(cleanedNumber, encodedMessage, context);
      }
    } catch (e) {
      _showErrorDialog(
        context,
        "Could not open WhatsApp. Please check if WhatsApp is installed.",
      );
    }
  }

  /// 🚀 Quick WhatsApp message without pre-filled text
  static Future<void> openWhatsAppChat(
    String phoneNumber, {
    BuildContext? context,
  }) async {
    await sendWhatsAppMessage(phoneNumber: phoneNumber, context: context);
  }

  /// 🚀 WhatsApp message with custom text
  static Future<void> sendWhatsAppMessageWithText({
    required String phoneNumber,
    required String message,
    BuildContext? context,
  }) async {
    await sendWhatsAppMessage(
      phoneNumber: phoneNumber,
      message: message,
      context: context,
    );
  }

  /// 🚀 Business inquiry message template
  static Future<void> sendBusinessInquiry({
    required String phoneNumber,
    required String businessName,
    String? serviceName,
    BuildContext? context,
  }) async {
    String message = "Hi $businessName! I'm interested in";
    if (serviceName != null) {
      message += " your $serviceName service.";
    } else {
      message += " your services.";
    }
    message += " Could you please provide more details?";

    await sendWhatsAppMessage(
      phoneNumber: phoneNumber,
      message: message,
      context: context,
    );
  }

  /// Clean phone number - remove all non-numeric characters except +
  static String _cleanPhoneNumber(String phoneNumber) {
    // Remove all spaces, dashes, parentheses, etc.
    String cleaned = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    // Ensure it starts with + if it doesn't
    if (!cleaned.startsWith('+')) {
      // If it starts with country code without +, add +
      if (cleaned.length > 10) {
        cleaned = '+$cleaned';
      } else {
        // Assume Indian number if no country code
        cleaned = '+91$cleaned';
      }
    }

    return cleaned;
  }

  /// Try WhatsApp Business as fallback
  static Future<void> _tryWhatsAppBusiness(
    String phoneNumber,
    String message,
    BuildContext? context,
  ) async {
    try {
      String businessUrl = "https://api.whatsapp.com/send?phone=$phoneNumber";
      if (message.isNotEmpty) {
        businessUrl += "&text=$message";
      }

      final Uri businessUri = Uri.parse(businessUrl);

      if (await canLaunchUrl(businessUri)) {
        await launchUrl(businessUri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorDialog(context, "WhatsApp is not installed on this device.");
      }
    } catch (e) {
      _showErrorDialog(
        context,
        "Could not open WhatsApp. Please install WhatsApp first.",
      );
    }
  }

  /// Show error dialog
  static void _showErrorDialog(BuildContext? context, String message) {
    if (context != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red),
                SizedBox(width: 8),
                Text("WhatsApp Error"),
              ],
            ),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  /// 🚀 Check if WhatsApp is installed
  static Future<bool> isWhatsAppInstalled() async {
    try {
      final Uri uri = Uri.parse("https://wa.me/1234567890");
      return await canLaunchUrl(uri);
    } catch (e) {
      return false;
    }
  }
}
