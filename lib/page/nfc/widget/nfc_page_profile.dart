import 'package:eventjar/controller/nfc/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/contact/nfc_contact_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NfcProfilePageHeader extends GetView<NfcController> {
  const NfcProfilePageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final profile = controller.state.profile.value;
      final hasProfile = profile != null;

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 3.hp),
        child: hasProfile
            ? _ProfileInfo(profile: profile)
            : const _SetupProfilePrompt(),
      );
    });
  }
}

class _ProfileInfo extends StatelessWidget {
  final NfcContactModel profile;

  const _ProfileInfo({required this.profile});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NfcController>();

    return Container(
      padding: EdgeInsets.all(4.wp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.lightBlue,
          width: 1.0,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Profile avatar
          CircleAvatar(
            radius: 23.sp,
            backgroundColor: Colors.blueAccent.withValues(alpha: 0.2),
            child: Text(
              controller.getInitials(profile.name),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ),
          SizedBox(width: 2.wp),

          // Profile details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  profile.name,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.4.hp),
                Row(
                  children: [
                    Icon(
                      Icons.phone_rounded,
                      size: 8.sp,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 1.wp),
                    Expanded(
                      child: Text(
                        profile.phone,
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (profile.email.isNotEmpty) ...[
                  SizedBox(height: 0.5.hp),
                  Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 8.sp,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          profile.email,
                          style: TextStyle(
                            fontSize: 8.sp,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SetupProfilePrompt extends StatelessWidget {
  const _SetupProfilePrompt();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NfcController>();

    return GestureDetector(
      onTap: controller.navigateTologin,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueAccent.withValues(alpha: 0.08),
              Colors.indigo.withValues(alpha: 0.04),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Colors.blueAccent.withValues(alpha: 0.25),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Setup icon
            Container(
              padding: EdgeInsets.all(2.wp),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withValues(alpha: 0.18),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blueAccent.withValues(alpha: 0.4),
                  width: 2.5,
                ),
              ),
              child: Icon(
                Icons.person_add_outlined,
                size: 20.sp,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(width: 20),

            // Text content
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Set up your profile',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey[900],
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: 0.5.hp),
                  Text(
                    'Create your contact details to write to NFC cards',
                    style: TextStyle(
                      fontSize: 7.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Setup button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blueAccent, Color(0xFF1976D2)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                'Get Started',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
