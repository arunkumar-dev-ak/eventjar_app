import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SingleSelectFilterDropdown<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final Rxn<T> selectedItem;
  final T Function() getDefaultItem;
  final String Function(T) getDisplayValue;
  final T Function(T) getKeyValue;
  final Function(T) onSelected;
  final String? hintText;

  // ✅ Optional customization
  final Color? themeColor;
  final Color? selectedShade1;
  final Color? selectedShade2;
  final Color? selectedShade3;
  final Color? headerColor;
  final Color? selectedDisplayColor;
  final double? borderWidth;
  final double? height;
  final double? selectedTextSize;
  final double? dropDownIconSize;
  final EdgeInsetsGeometry? textFieldPadding;

  const SingleSelectFilterDropdown({
    super.key,
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.getDefaultItem,
    required this.getDisplayValue,
    required this.getKeyValue,
    required this.onSelected,
    this.hintText,
    this.themeColor,
    this.selectedShade1,
    this.selectedShade2,
    this.selectedShade3,
    this.headerColor,
    this.selectedDisplayColor,
    this.borderWidth,
    this.height,
    this.selectedTextSize,
    this.dropDownIconSize,
    this.textFieldPadding,
  });

  @override
  Widget build(BuildContext context) {
    final Color primary = themeColor ?? Colors.blue.shade700;
    final Color headColor = headerColor ?? Colors.blue;
    return Obx(() {
      final T? selected = selectedItem.value;

      final bool isSelected = selected != null;

      final String displayText = selected != null
          ? getDisplayValue(selected)
          : (hintText ?? 'Select option');

      return GestureDetector(
        onTap: () => _showModernDialog(
          context: context,
          headerColor: headColor,
          primary: primary,
          selectedShade1: selectedShade1 ?? Colors.blue.shade50,
          selectedShade2: selectedShade2 ?? Colors.blue.shade100,
          selectedShade3: selectedShade3 ?? Colors.blue.shade200,
        ),
        child: Container(
          height: height,
          padding:
              textFieldPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.cardBg(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border(context), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow(context),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                displayText,
                style: TextStyle(
                  fontSize: selectedTextSize ?? 10.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? selectedDisplayColor ?? primary
                      : AppColors.textSecondary(context),
                ),
              ),

              AnimatedRotation(
                duration: const Duration(milliseconds: 200),
                turns: isSelected ? 0.25 : 0,
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: dropDownIconSize ?? 24,
                  color: isSelected
                      ? selectedDisplayColor ?? primary
                      : AppColors.textHint(context),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showModernDialog({
    required BuildContext context,
    required Color headerColor,
    required Color primary,
    required Color selectedShade1,
    required Color selectedShade2,
    required Color selectedShade3,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Container(
          constraints: BoxConstraints(maxHeight: 60.hp, maxWidth: 90.wp),
          decoration: BoxDecoration(
            color: AppColors.cardBg(context),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Modern Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                decoration: BoxDecoration(
                  color: headerColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 0.7.hp),
                    Obx(() {
                      final selected = selectedItem.value;
                      return selected != null &&
                              getKeyValue(selected) !=
                                  getKeyValue(getDefaultItem())
                          ? Text(
                              getDisplayValue(selected),
                              style: TextStyle(
                                fontSize: 9.sp,
                                color: Colors.white.withValues(alpha: 0.9),
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : const SizedBox();
                    }),
                  ],
                ),
              ),
              SizedBox(height: 1.hp),

              // Items List
              Expanded(
                child: Obx(() {
                  final selected = selectedItem.value;

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final bool isSelectedItem =
                          selected != null &&
                          getKeyValue(item) == getKeyValue(selected);

                      final isDark =
                          Theme.of(context).brightness == Brightness.dark;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isSelectedItem
                              ? (isDark
                                    ? headerColor.withValues(alpha: 0.15)
                                    : selectedShade1)
                              : AppColors.cardBg(context),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelectedItem
                                ? (isDark
                                      ? headerColor.withValues(alpha: 0.5)
                                      : selectedShade3)
                                : AppColors.divider(context),
                            width: 1.5,
                          ),
                          boxShadow: isSelectedItem
                              ? [
                                  BoxShadow(
                                    color: isDark
                                        ? headerColor.withValues(alpha: 0.2)
                                        : selectedShade1,
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              onSelected(item);
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelectedItem
                                          ? headerColor
                                          : AppColors.divider(context),
                                      border: Border.all(
                                        color: isSelectedItem
                                            ? Colors.white
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      isSelectedItem
                                          ? Icons.check
                                          : Icons.radio_button_unchecked,
                                      color: isSelectedItem
                                          ? Colors.white
                                          : AppColors.textHint(context),
                                      size: 16,
                                    ),
                                  ),
                                  SizedBox(width: 3.wp),
                                  Expanded(
                                    child: Text(
                                      getDisplayValue(item),
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: isSelectedItem
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        color: isSelectedItem
                                            ? primary
                                            : AppColors.textPrimary(context),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
