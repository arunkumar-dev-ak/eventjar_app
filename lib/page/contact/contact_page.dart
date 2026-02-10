import 'dart:ui';

import 'package:eventjar/controller/contact/controller.dart';
import 'package:eventjar/model/contact/contact_analytics_model.dart';
import 'package:eventjar/page/contact/contact_card_page.dart';
import 'package:eventjar/page/contact/filter/contact_search_page.dart';
import 'package:eventjar/page/contact/widget/add_contact_bottom_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global/responsive/responsive.dart';

class ContactPage extends GetView<ContactController> {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Obx(() {
          final selected = controller.state.selectedTab.value;
          final label = selected?.label ?? "Contacts";

          // Dim the color by blending with black at 20%
          final baseColor = selected?.color ?? Colors.blue;
          final color = Color.alphaBlend(
            Colors.black.withValues(alpha: 0.2),
            baseColor,
          );

          final count = _getCountByKey(
            controller.state.analytics.value,
            selected?.key,
          );

          return AppBar(
            backgroundColor: color,
            title: Row(
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                // Wrap count in a badge-like container
                if (count != -1) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: baseColor.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      count.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            centerTitle: false,
            elevation: 0,
            actions: [
              Row(
                children: [
                  _buildActionButton(
                    icon: Icons.add_rounded,
                    onPressed: () => addContactBottomModel(context, controller),
                  ),
                  SizedBox(width: 3.wp),
                  _buildActionButton(
                    icon: Icons.qr_code_scanner_rounded,
                    onPressed: controller.navigateToQrPage,
                  ),
                  SizedBox(width: 2.wp),
                ],
              ),
              // IconButton(
              //   icon: const Icon(Icons.person_add, color: Colors.white),
              //   tooltip: 'Add Contact',
              //   onPressed: () {
              //     controller.navigateToAddContact();
              //   },
              // ),
            ],
          );
        }),
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Buttons row: Add Contact, Import Google, Import Mobile
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Padding(
            //     padding: EdgeInsets.only(top: 8, bottom: 8, left: 14),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: [
            //         ElevatedButton.icon(
            //           icon: const Icon(Icons.account_circle),
            //           label: const Text("Import Google"),
            //           onPressed: () {
            //             // Add your Import from Google action here
            //           },
            //           style: ElevatedButton.styleFrom(
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(10),
            //             ),
            //             padding: const EdgeInsets.symmetric(
            //               vertical: 12,
            //               horizontal: 12,
            //             ),
            //           ),
            //         ),
            //         SizedBox(width: 2.wp),
            //         ElevatedButton.icon(
            //           icon: const Icon(Icons.phone_android),
            //           label: const Text("Import Mobile"),
            //           onPressed: () {
            //             // Add your Import from Mobile action here
            //           },
            //           style: ElevatedButton.styleFrom(
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(10),
            //             ),
            //             padding: const EdgeInsets.symmetric(
            //               vertical: 12,
            //               horizontal: 12,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // SizedBox(height: 1.hp),

            // Search and Contact cards below
            ContactsSearchAndFilters(),
            Expanded(child: ContactCardPage()),
          ],
        ),
      ),
    );
  }
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
          width: 33,
          height: 33,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.4),
              width: 1.3,
            ),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    ),
  );
}

int _getCountByKey(ContactAnalytics? analytics, String? key) {
  if (analytics == null || key == null) {
    return -1;
  }

  switch (key) {
    case 'new':
      return analytics.newCount;
    case 'followup24h':
      return analytics.followup24h;
    case 'followup7d':
      return analytics.followup7d;
    case 'followup30d':
      return analytics.followup30d;
    case 'qualified':
      return analytics.qualified;
    case 'overdue':
      return analytics.overdue;
    case 'totalContacts':
      return analytics.total;
    default:
      return 0;
  }
}

String formatCount(int count) {
  if (count >= 100000) {
    return '${(count / 100000).toStringAsFixed(1)}L+';
  } else if (count >= 1000) {
    return '${(count / 1000).toStringAsFixed(0)}k+';
  }
  return count.toString();
}
