import 'dart:ui';

import 'package:eventjar/controller/contact/controller.dart';
import 'package:eventjar/model/contact/contact_analytics_model.dart';
import 'package:eventjar/page/contact/contact_card_page.dart';
import 'package:eventjar/page/contact/filter/contact_search_page.dart';
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
                    onPressed: () => _showAddMenu(context, controller),
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
          children: [
            // Buttons row: Add Contact, Import Google, Import Mobile
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceAround,
            //       children: [
            //         ElevatedButton.icon(
            //           icon: const Icon(Icons.person_add),
            //           label: const Text("Add Contact"),
            //           onPressed: () {
            //             // Add your Add Contact action here
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

void _showAddMenu(BuildContext context, ContactController controller) {
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
          Divider(
            height: 1,
            indent: 20,
            endIndent: 20,
            color: Colors.grey.shade200,
          ),
          _buildMenuItem(
            icon: Icons.nfc_rounded,
            title: 'NFC',
            subtitle: 'Scan NFC tag to add contact',
            gradientColors: [Colors.green.shade400, Colors.green.shade600],
            onTap: () {
              Navigator.pop(context);
              //controller.navigateToNfc();
              controller.navigateToReceive();
            },
          ),
          Divider(
            height: 1,
            indent: 20,
            endIndent: 20,
            color: Colors.grey.shade200,
          ),
          _buildMenuItem(
            icon: Icons.qr_code_scanner_rounded,
            title: 'QR Scanner',
            subtitle: 'Scan QR code to add contact',
            gradientColors: [Colors.purple.shade400, Colors.purple.shade600],
            onTap: () {
              Navigator.pop(context);
              controller.navigateToQrPage();
            },
          ),
          Divider(
            height: 1,
            indent: 20,
            endIndent: 20,
            color: Colors.grey.shade200,
          ),
          _buildMenuItem(
            icon: Icons.document_scanner,
            title: 'Scan Visiting card',
            subtitle: 'Scan Visiting card to add contact',
            gradientColors: [
              Colors.orangeAccent.shade400,
              Colors.orangeAccent.shade700,
            ],
            onTap: () {
              Navigator.pop(context);
              controller.navigateToScanPage();
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
        fontSize: 10.sp,
        color: Colors.grey.shade800,
      ),
    ),
    subtitle: Text(
      subtitle,
      style: TextStyle(fontSize: 8.sp, color: Colors.grey.shade500),
    ),
    trailing: Icon(
      Icons.arrow_forward_ios_rounded,
      size: 16,
      color: Colors.grey.shade400,
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
