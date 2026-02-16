import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/global/whatsapp_chat.dart';
import 'package:flutter/material.dart';

class EventJarInviteBadge extends StatelessWidget {
  final bool onEventJar;
  final String? phone;
  final String name;
  final BuildContext parentContext;

  const EventJarInviteBadge({
    super.key,
    required this.onEventJar,
    required this.phone,
    required this.name,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    final invitedUserName = UserStore.to.profile['name'] ?? "Someone";
    return GestureDetector(
      onTap: onEventJar
          ? null
          : () {
              inviteToEventJarOnWhatsApp(
                phone: phone,
                name: name,
                invitedUserName: invitedUserName,
                context: parentContext,
              );
            },

      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.5.wp, vertical: 0.6.hp),
        decoration: BoxDecoration(
          color: onEventJar
              ? Colors.green.withValues(alpha: 0.08)
              : Colors.blue.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: onEventJar ? Colors.green : Colors.blue,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              onEventJar ? Icons.check_circle : Icons.add,
              size: 12,
              color: onEventJar ? Colors.green : Colors.blue,
            ),
            SizedBox(width: 1.wp),

            Flexible(
              child: Text(
                onEventJar ? 'On EventJar' : 'Invite to MyEventJar',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 6.5.sp,
                  fontWeight: FontWeight.w600,
                  color: onEventJar ? Colors.green : Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void inviteToEventJarOnWhatsApp({
  required String? phone,
  required String name,
  required String invitedUserName,
  required BuildContext context,
}) {
  final String cleanedPhone = phone ?? '';
  if (cleanedPhone.isEmpty) return;

  final String message =
      '''
✨ You're Invited to Join *MyEventJar*!

Hi *$name*,

*$invitedUserName* has invited you to experience *MyEventJar* — a powerful platform built for smart event discovery and meaningful professional networking.

With MyEventJar, you can:

• Discover high-quality events tailored to your interests  
• Connect with professionals, founders, and industry leaders  
• Host and promote your own events effortlessly  
• Build genuine business relationships that matter  
• Unlock exclusive networking opportunities  

🚀 Take your networking to the next level.

Get started now:
https://myeventjar.com/getapp
''';

  WhatsAppHelper.sendWhatsAppMessageWithText(
    phoneNumber: cleanedPhone,
    message: message,
    context: context,
  );
}
