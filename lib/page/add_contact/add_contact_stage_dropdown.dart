import 'package:eventjar/controller/add_contact/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactStageDropdown extends StatelessWidget {
  final AddContactController controller = Get.find();

  ContactStageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.state.selectedStage.value;

      return GestureDetector(
        onTap: () => _showStageDialog(context),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.8.hp),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.wp),
                decoration: BoxDecoration(
                  color: AppColors.gradientDarkStart.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.flag_rounded,
                  size: 18,
                  color: AppColors.gradientDarkStart,
                ),
              ),
              SizedBox(width: 3.wp),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stage',
                      style: TextStyle(
                        fontSize: 7.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    SizedBox(height: 0.3.hp),
                    Text(
                      selected['value'] ?? 'Select Stage',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showStageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: EdgeInsets.all(4.wp),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.wp),
                    decoration: BoxDecoration(
                      color: AppColors.gradientDarkStart.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.flag_rounded,
                      size: 18,
                      color: AppColors.gradientDarkStart,
                    ),
                  ),
                  SizedBox(width: 3.wp),
                  Text(
                    'Select Stage',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded),
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.grey.shade100),
            // List of stages
            Expanded(child: _buildStageSelection(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildStageSelection(BuildContext context) {
    return Obx(() {
      final stages = controller.state.stages;
      final selectedKey = controller.state.selectedStage.value["key"];

      return ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 1.hp),
        shrinkWrap: true,
        itemCount: stages.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: Colors.grey.shade100,
          indent: 4.wp,
          endIndent: 4.wp,
        ),
        itemBuilder: (_, index) {
          final stage = stages[index];
          final isSelected = stage['key'] == selectedKey;

          return InkWell(
            onTap: () {
              controller.selectStage(stage);
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.5.hp),
              color: isSelected
                  ? AppColors.gradientDarkStart.withValues(alpha: 0.05)
                  : Colors.transparent,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.wp),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.gradientDarkStart.withValues(alpha: 0.15)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getStageIcon(stage['key'] ?? ''),
                      size: 16,
                      color: isSelected
                          ? AppColors.gradientDarkStart
                          : Colors.grey.shade500,
                    ),
                  ),
                  SizedBox(width: 3.wp),
                  Expanded(
                    child: Text(
                      stage['value'] ?? '',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.gradientDarkStart
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle_rounded,
                      size: 20,
                      color: AppColors.gradientDarkStart,
                    ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  IconData _getStageIcon(String key) {
    switch (key.toLowerCase()) {
      case 'new':
        return Icons.fiber_new_rounded;
      case 'contacted':
        return Icons.call_made_rounded;
      case 'qualified':
        return Icons.verified_rounded;
      case 'proposal':
        return Icons.description_rounded;
      case 'negotiation':
        return Icons.handshake_rounded;
      case 'closed':
        return Icons.check_circle_rounded;
      case 'lost':
        return Icons.cancel_rounded;
      default:
        return Icons.flag_rounded;
    }
  }
}
