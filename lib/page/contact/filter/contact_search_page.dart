import 'package:eventjar/controller/contact/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactsSearchAndFilters extends GetView<ContactController> {
  const ContactsSearchAndFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar with filter icon
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            children: [
              // Expanded Search
              Obx(() {
                return Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      hintText: 'Search contacts',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      suffixIcon: controller.state.searchQuery.value.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                size: 20,
                                color: Colors.grey[600],
                              ),
                              onPressed: () {
                                controller.searchController.clear();
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      ),
                    ),
                    // onChanged: (val) {
                    //   controller.fetchContactsOnSearch();
                    // },
                  ),
                );
              }),
              // SizedBox(width: 10),
              // Filter Icon
              // Material(
              //   color: Colors.white,
              //   borderRadius: BorderRadius.circular(12),
              //   child: InkWell(
              //     borderRadius: BorderRadius.circular(12),
              //     onTap: controller.toggleFilterRow,
              //     child: Container(
              //       height: 2.hp,
              //       width: 2.hp,
              //       alignment: Alignment.center,
              //       child: Icon(Icons.tune, color: Colors.grey),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),

        // Dropdown Row, shown with Obx
        Obx(
          () => controller.state.showFilterRow.value
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 0,
                  ),
                  child: SizedBox(
                    height: 4.hp,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      children: [
                        _DropdownPill(label: 'Tags', icon: Icons.label),
                        SizedBox(width: 8),
                        _DropdownPill(
                          label: 'Stages',
                          icon: Icons.track_changes,
                        ),
                        SizedBox(width: 8),
                        _DropdownPill(label: 'Sort', icon: Icons.sort),
                      ],
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _DropdownPill extends StatelessWidget {
  final String label;
  final IconData icon;
  const _DropdownPill({required this.label, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.blueAccent.shade100),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blue[700]),
          SizedBox(width: 7),
          Text(
            label,
            style: TextStyle(
              color: Colors.blue[900],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 3),
          Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.blue[700]),
        ],
      ),
    );
  }
}
