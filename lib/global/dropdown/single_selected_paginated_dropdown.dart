import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/haptic_helper.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SingleSelectPaginatedFilterDropdown<T> extends StatelessWidget {
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
  final IconData? dropdownIcon;
  final EdgeInsetsGeometry? textFieldPadding;

  // 🔧 Pagination & search
  final Function(String) onChanged;
  final Function() onClickedLoadMore;
  final RxBool onLoadMoreLoading;
  final RxBool onDropdownListLoading;
  final RxBool? hasMore;
  final Function() onRefresh;

  const SingleSelectPaginatedFilterDropdown({
    super.key,
    required this.onRefresh,
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
    this.borderWidth,
    this.height,
    this.selectedTextSize,
    this.dropDownIconSize,
    this.dropdownIcon,
    this.selectedDisplayColor,
    this.textFieldPadding,
    required this.onChanged,
    required this.onClickedLoadMore,
    required this.onDropdownListLoading,
    required this.onLoadMoreLoading,
    this.hasMore,
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
        onTap: () {
          HapticHelper.light();
          _showModernDialog(
            context: context,
            headerColor: headColor,
            primary: primary,
            selectedShade1: selectedShade1 ?? Colors.blue.shade50,
            selectedShade2: selectedShade2 ?? Colors.blue.shade100,
            selectedShade3: selectedShade3 ?? Colors.blue.shade200,
          );
        },
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
                      ? (selectedDisplayColor ?? primary)
                      : AppColors.textSecondary(context),
                ),
              ),
              AnimatedRotation(
                duration: const Duration(milliseconds: 200),
                turns: isSelected ? 0.25 : 0,
                child: Icon(
                  dropdownIcon ?? Icons.keyboard_arrow_down_rounded,
                  size: dropDownIconSize ?? 24,
                  color: isSelected ? primary : AppColors.textHint(context),
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
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Container(
            constraints: BoxConstraints(maxHeight: 70.hp, maxWidth: 90.wp),
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
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 24, 16, 16),
                  decoration: BoxDecoration(
                    color: headerColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: IconButton(
                          icon: const Icon(
                            Icons.refresh,
                            size: 18,
                            color: Colors.white,
                          ),
                          onPressed: onRefresh,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),

                // Search bar
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 1.5.hp, 24, 1.hp),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search $title...',
                      hintStyle: TextStyle(
                        fontSize: 9.5.sp,
                        color: AppColors.textHint(context),
                      ),
                      filled: true,
                      fillColor: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: AppColors.border(context)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: AppColors.border(context)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: headerColor, width: 1.5),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 18,
                        color: AppColors.textHint(context),
                      ),
                    ),
                    onChanged: (value) => onChanged(value),
                  ),
                ),

                // List
                Expanded(
                  child: Obx(() {
                    final bool isListLoading = onDropdownListLoading.value;
                    final T? selected = selectedItem.value;
                    final List<T> filteredItems = items;
                    final bool isLoadMoreLoading = onLoadMoreLoading.value;
                    final bool showLoadMore = hasMore?.value ?? true;

                    if (filteredItems.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isListLoading
                                  ? Icons.hourglass_empty
                                  : Icons.search_off,
                              size: 40,
                              color: AppColors.iconMuted(context),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isListLoading
                                  ? 'Loading...'
                                  : 'No matches found',
                              style: TextStyle(
                                color: AppColors.textSecondary(context),
                                fontSize: 9.5.sp,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Stack(
                      children: [
                        ListView.builder(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                          itemCount: filteredItems.length +
                              (showLoadMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= filteredItems.length) {
                              if (isLoadMoreLoading) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: primary,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return GestureDetector(
                                onTap: onClickedLoadMore,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: primary.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Text(
                                    'Load More',
                                    style: TextStyle(
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w600,
                                      color: primary,
                                    ),
                                  ),
                                ),
                              );
                            }

                            final T item = filteredItems[index];
                            final bool isSelectedItem = selected != null &&
                                getKeyValue(item) == getKeyValue(selected);

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
                                              ? headerColor.withValues(
                                                  alpha: 0.2)
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
                                    HapticHelper.selection();
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
                                                  : AppColors.textPrimary(
                                                      context),
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
                        ),
                        if (isListLoading)
                          Positioned.fill(
                            child: Container(
                              color:
                                  AppColors.cardBg(context).withValues(alpha: 0.8),
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(color: primary),
                            ),
                          ),
                      ],
                    );
                  }),
                ),

                // Close button
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 0, 24, 2.hp),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(color: AppColors.border(context)),
                        ),
                      ),
                      child: Text(
                        'Close',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
