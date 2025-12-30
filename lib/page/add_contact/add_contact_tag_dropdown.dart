import 'package:eventjar/controller/add_contact/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MultiSelectTagsInput extends StatelessWidget {
  final AddContactController controller = Get.find();

  MultiSelectTagsInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tag Input Field
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                margin: EdgeInsets.only(left: 12),
                padding: EdgeInsets.all(2.wp),
                decoration: BoxDecoration(
                  color: AppColors.gradientDarkStart.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.label_rounded,
                  size: 18,
                  color: AppColors.gradientDarkStart,
                ),
              ),
              // Text Field
              Expanded(
                child: TextField(
                  controller: controller.tagController,
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: Colors.grey.shade800,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Add a tag...',
                    hintStyle: TextStyle(
                      fontSize: 8.sp,
                      color: Colors.grey.shade400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                  onSubmitted: (val) {
                    if (val.trim().isNotEmpty) {
                      controller.addTag(val.trim());
                      controller.tagController.clear();
                    }
                  },
                ),
              ),
              // Add Button
              GestureDetector(
                onTap: () {
                  final newTag = controller.tagController.text.trim();
                  if (newTag.isNotEmpty) {
                    controller.addTag(newTag);
                    controller.tagController.clear();
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(right: 8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.gradientDarkStart,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Selected Tags
        Obx(() {
          final tags = controller.state.selectedTags;
          if (tags.isEmpty) {
            return Padding(
              padding: EdgeInsets.only(top: 1.hp),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 14,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(width: 1.5.wp),
                  Text(
                    'Press enter or tap + to add tags',
                    style: TextStyle(
                      fontSize: 7.sp,
                      color: Colors.grey.shade400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.only(top: 1.5.hp),
            child: Wrap(
              spacing: 2.wp,
              runSpacing: 1.hp,
              children: tags.map((tag) => _buildTagChip(tag)).toList(),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTagChip(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 0.8.hp),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.gradientDarkStart.withValues(alpha: 0.15),
            AppColors.gradientDarkEnd.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.gradientDarkStart.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.label_rounded,
            size: 14,
            color: AppColors.gradientDarkStart,
          ),
          SizedBox(width: 1.5.wp),
          Flexible(
            child: Text(
              tag,
              style: TextStyle(
                color: AppColors.gradientDarkStart,
                fontSize: 8.sp,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(width: 1.5.wp),
          GestureDetector(
            onTap: () => controller.state.selectedTags.remove(tag),
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.gradientDarkStart.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close_rounded,
                size: 12,
                color: AppColors.gradientDarkStart,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
