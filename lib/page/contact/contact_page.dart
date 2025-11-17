import 'package:eventjar/controller/contact/controller.dart';
import 'package:eventjar/page/contact/contact_card_page.dart';
import 'package:eventjar/page/contact/contact_search_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactPage extends GetView<ContactController> {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the selected tab data from controller

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Obx(() {
          final selected = controller.state.selectedTab.value;
          final label = selected?.label ?? "Contacts";

          // Dim the color by blending with black at 25%
          final baseColor = selected?.color ?? Colors.blue;
          final color = Color.alphaBlend(
            Colors.black.withValues(alpha: 0.2),
            baseColor,
          );

          final count = selected?.count ?? 0;

          // Format count helper
          String formatCount(int count) {
            if (count >= 100000) {
              return '${(count / 100000).toStringAsFixed(1)}L+';
            } else if (count >= 1000) {
              return '${(count / 1000).toStringAsFixed(0)}k+';
            }
            return count.toString();
          }

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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    formatCount(count),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            centerTitle: false,
            elevation: 0,
          );
        }),
      ),
      body: Column(
        children: [
          // Buttons row: Add Contact, Import Google, Import Mobile
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.person_add),
                    label: const Text("Add Contact"),
                    onPressed: () {
                      // Add your Add Contact action here
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.account_circle),
                    label: const Text("Import Google"),
                    onPressed: () {
                      // Add your Import from Google action here
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.phone_android),
                    label: const Text("Import Mobile"),
                    onPressed: () {
                      // Add your Import from Mobile action here
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search and Contact cards below
          ContactsSearchAndFilters(),
          Expanded(child: ContactCardPage()),
        ],
      ),
    );
  }
}
