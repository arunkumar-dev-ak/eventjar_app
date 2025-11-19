import 'package:eventjar/controller/contact/controller.dart';
import 'package:eventjar/model/contact/contact_analytics_model.dart';
import 'package:eventjar/page/contact/contact_card_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            ),
            centerTitle: false,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.person_add, color: Colors.white),
                tooltip: 'Add Contact',
                onPressed: () {
                  controller.navigateToAddContact();
                },
              ),
            ],
          );
        }),
      ),

      body: Column(
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
          // ContactsSearchAndFilters(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.fetchContacts();
              },
              child: ContactCardPage(),
            ),
          ),
        ],
      ),
    );
  }
}

int _getCountByKey(ContactAnalytics? analytics, String? key) {
  if (analytics == null || key == null) {
    return 0;
  }

  switch (key) {
    case 'new':
      return analytics.newCount;
    case 'followup_24h':
      return analytics.followup24h;
    case 'followup_7d':
      return analytics.followup7d;
    case 'followup_30d':
      return analytics.followup30d;
    case 'qualified':
      return analytics.qualified;
    case 'overdue':
      return analytics.overdue;
    case 'total':
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
