import 'package:eventjar/controller/profile_form/business_info/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OperatingRegionsDropdown extends GetView<BusinessInfoFormController> {
  const OperatingRegionsDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () => showOperatingRegionsDialog(controller),
        child: Container(
          padding: EdgeInsets.all(3.wp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  controller.state.selectedOperatingRegions.isEmpty
                      ? "Select Operating Regions"
                      : "${controller.state.selectedOperatingRegions.length} region${controller.state.selectedOperatingRegions.length != 1 ? 's' : ''} selected",
                  style: TextStyle(fontSize: 9.5.sp, color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: controller.state.selectedOperatingRegions.isEmpty
                    ? Colors.grey.shade400
                    : Colors.green.shade700,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showOperatingRegionsDialog(BusinessInfoFormController controller) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(maxHeight: 70.hp),
        padding: EdgeInsets.all(4.wp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dialog Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Operating Regions",
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: 2.hp),
            // Regions List
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: controller.operatingRegions
                      .map((region) => _buildRegionItem(region, controller))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildRegionItem(String region, BusinessInfoFormController controller) {
  final isSelected = controller.state.selectedOperatingRegions.contains(region);
  return InkWell(
    onTap: () {
      if (isSelected) {
        controller.state.selectedOperatingRegions.remove(region);
      } else {
        controller.state.selectedOperatingRegions.add(region);
      }
    },
    child: Container(
      margin: EdgeInsets.only(bottom: 2.hp),
      padding: EdgeInsets.all(3.5.wp),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.green.shade400 : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Checkbox Indicator
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? Colors.green.shade600
                    : Colors.grey.shade400,
                width: 2,
              ),
              color: isSelected ? Colors.green.shade600 : Colors.transparent,
            ),
            child: isSelected
                ? Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
          SizedBox(width: 3.wp),
          // Region Text
          Expanded(
            child: Text(
              region,
              style: TextStyle(
                fontSize: 9.5.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.green.shade900 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
