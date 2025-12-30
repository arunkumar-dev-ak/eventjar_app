import 'dart:ui';
import 'package:eventjar/controller/home/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ContactAction { addContact, nfc }

class HomeAppBar extends StatelessWidget {
  final HomeController controller = Get.find();

  HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.wp, vertical: 2.wp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo and Title with modern styling
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gradientDarkStart.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Image.asset(
                  controller.logoPath,
                  width: 24,
                  height: 24,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 3.wp),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        AppColors.gradientDarkStart,
                        AppColors.gradientDarkEnd,
                      ],
                    ).createShader(bounds),
                    child: Text(
                      controller.appBarTitle,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Text(
                    'Discover Events',
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: Colors.white.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Action buttons with glassmorphism effect
          Row(
            children: [
              _buildActionButton(
                icon: Icons.add_rounded,
                onPressed: () => _showAddMenu(context),
              ),
              SizedBox(width: 3.wp),
              _buildActionButton(
                icon: Icons.qr_code_scanner_rounded,
                onPressed: controller.navigateToQrPage,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }

  void _showAddMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: EdgeInsets.all(4.wp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.hp),
            _buildMenuItem(
              icon: Icons.person_add_alt_1_rounded,
              title: 'Add Contact',
              subtitle: 'Add a new contact manually',
              gradientColors: [Colors.blue.shade400, Colors.blue.shade600],
              onTap: () {
                Navigator.pop(context);
                controller.navigateToAddContact();
              },
            ),
            Divider(height: 1, indent: 20, endIndent: 20, color: Colors.grey.shade200),
            _buildMenuItem(
              icon: Icons.nfc_rounded,
              title: 'NFC',
              subtitle: 'Scan NFC tag to add contact',
              gradientColors: [Colors.green.shade400, Colors.green.shade600],
              onTap: () {
                Navigator.pop(context);
                controller.navigateToNfc();
              },
            ),
            Divider(height: 1, indent: 20, endIndent: 20, color: Colors.grey.shade200),
            _buildMenuItem(
              icon: Icons.qr_code_scanner_rounded,
              title: 'Scanner',
              subtitle: 'Scan QR code to add contact',
              gradientColors: [Colors.purple.shade400, Colors.purple.shade600],
              onTap: () {
                Navigator.pop(context);
                controller.navigateToQrPage();
              },
            ),
            SizedBox(height: 3.hp),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 5.wp, vertical: 1.hp),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 11.sp,
          color: Colors.grey.shade800,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 9.sp,
          color: Colors.grey.shade500,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: Colors.grey.shade400,
      ),
    );
  }
}
