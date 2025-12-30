import 'package:eventjar/controller/profile_form/networking/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonMultiSelectDropdown extends GetView<NetworkingFormController> {
  final String title;
  final String subtitle;
  final RxList<String> selectedItems;
  final List<String> allItems;
  final String fieldKey; // For tracking changes

  const CommonMultiSelectDropdown({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selectedItems,
    required this.allItems,
    required this.fieldKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 0.5.hp),
        Text(
          subtitle,
          style: TextStyle(fontSize: 8.5.sp, color: Colors.grey.shade600),
        ),
        SizedBox(height: 1.5.hp),
        Obx(
          () => Wrap(
            spacing: 2.wp,
            runSpacing: 1.5.hp,
            children: allItems.map((item) => _buildBadge(item)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String item) {
    final isSelected = selectedItems.contains(item);
    return GestureDetector(
      onTap: () {
        if (isSelected) {
          selectedItems.remove(item);
        } else {
          selectedItems.add(item);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 0.8.hp),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade500 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.green.shade600 : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Text(
          item,
          style: TextStyle(
            fontSize: 8.5.sp,
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
