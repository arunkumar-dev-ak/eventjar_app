import 'package:eventjar/model/notification/email_providers.dart';
import 'package:flutter/material.dart';

Widget emailNotificationSetupCard(EmailProvider provider) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text(provider.setupInstructions),
  );
}
