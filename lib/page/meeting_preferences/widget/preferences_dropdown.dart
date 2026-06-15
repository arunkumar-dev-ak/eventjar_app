import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreferencesDropdown extends StatelessWidget {
  final String label;
  final RxString selectedValue;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const PreferencesDropdown({
    super.key,
    required this.label,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 8.5.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary(context),
          ),
        ),
        SizedBox(height: 1.hp),
        Obx(
          () => Container(
            padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 0.5.hp),
            decoration: BoxDecoration(
              color: AppColors.cardBg(context),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border(context)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedValue.value,
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.iconMuted(context),
                ),
                dropdownColor: AppColors.cardBg(context),
                style: TextStyle(
                  fontSize: 8.5.sp,
                  color: AppColors.textPrimary(context),
                ),
                items: items.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) onChanged(value);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
