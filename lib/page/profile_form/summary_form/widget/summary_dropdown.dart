import 'package:eventjar/controller/profile_form/summary/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExperienceDropdown extends GetView<SummaryFormController> {
  const ExperienceDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Experience",
          style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 1.hp),
        Obx(
          () => InkWell(
            onTap: () => showExperienceDialog(controller),
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
                      controller.state.experienceRange.value.isEmpty
                          ? "Select experience"
                          : controller.state.experienceRange.value,
                      style: TextStyle(fontSize: 9.5.sp, color: Colors.black),
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.black, size: 24),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

void showExperienceDialog(SummaryFormController controller) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(maxHeight: 60.hp),
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
                  "Select Experience",
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
            // Experience List
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: controller.state.experienceRanges
                      .map(
                        (experience) =>
                            _buildExperienceItem(experience, controller),
                      )
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

Widget _buildExperienceItem(
  String experience,
  SummaryFormController controller,
) {
  final isSelected = controller.state.experienceRange.value == experience;
  return InkWell(
    onTap: () {
      controller.state.experienceRange.value = experience;
      Get.back();
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
          Expanded(
            child: Text(
              experience,
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
