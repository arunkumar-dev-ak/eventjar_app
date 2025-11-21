import 'package:eventjar/controller/network/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactAnalyticsAddContactCard extends StatelessWidget {
  ContactAnalyticsAddContactCard({super.key});
  final NetworkScreenController controller = Get.find();

  void navigateToAddContact() {
    Get.toNamed(
      RouteName.addContactPage,
    )?.then((_) async => {await controller.fetchContactAnalytics()});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: navigateToAddContact,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 110,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade600.withValues(alpha: 0.7),
              Colors.blue.shade400.withValues(alpha: 0.4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade400.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(4, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(12),
              child: const Icon(
                Icons.person_add,
                size: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                'Add Contact',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                  fontSize: 11.sp,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}

class ContactAnalyticsOverdueCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final int overdueCount;
  final VoidCallback? onTap;

  const ContactAnalyticsOverdueCard({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.overdueCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 110,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.7),
              color.withValues(alpha: 0.4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(4, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(icon, size: 30, color: Colors.white),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                  fontSize: 11.sp,
                ),
              ),
            ),
            Text(
              overdueCount.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
