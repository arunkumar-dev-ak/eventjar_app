import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/contact/contact_model.dart';
import 'package:flutter/material.dart';

class ContactCardProfileTags extends StatelessWidget {
  final Contact contact;
  const ContactCardProfileTags({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Prevent overflow
      children: [
        // Compact EventJar Badge
        _buildCompactBadge(
          bgColor: contact.isEventJarUser ?? false
              ? Colors.green[600]!
              : Colors.blue[800]!,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                contact.isEventJarUser ?? false
                    ? Icons.check_circle
                    : Icons.info,
                color: Colors.white,
                size: 10.sp, // Smaller icon
              ),
              SizedBox(width: 1.wp), // Reduced spacing
              Text(
                contact.isEventJarUser ?? false
                    ? 'On EventJar'
                    : 'Not in EventJar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 7.sp, // Smaller text
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // Overdue Badge (Text instead of dot)
        // if (contact.isOverdue) ...[SizedBox(width: 4), _buildOverdueBadge()],
      ],
    );
  }

  Widget _buildCompactBadge({required Color bgColor, required Widget child}) {
    return Container(
      margin: EdgeInsets.zero, // No margin
      padding: EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 3,
      ), // Smaller padding
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12), // More rounded
      ),
      child: child,
    );
  }

  Widget buildOverdueBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade400, Colors.red.shade500],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule, size: 10.sp, color: Colors.white),
          SizedBox(width: 1.wp),
          Text(
            'Overdue',
            style: TextStyle(
              color: Colors.white,
              fontSize: 7.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}
