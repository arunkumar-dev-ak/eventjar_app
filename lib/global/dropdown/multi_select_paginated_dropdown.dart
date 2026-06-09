import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/haptic_helper.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MultiSelectPaginatedDropdown<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final RxMap<String, T> selectedItemsMap;

  final String Function(T) getDisplayValue;
  final String Function(T) getKeyValue;
  final String Function(T)? getSubtitleValue;
  final Widget Function(T)? getLeadingWidget;
  final Widget Function(T)? getTrailingWidget;

  final Function(String) onChanged;
  final VoidCallback onLoadMore;
  final VoidCallback onRefresh;

  final RxBool isLoading;
  final RxBool isLoadMoreLoading;
  final Color? selectedDisplayColor;

  final String? hintText;
  final Color? themeColor;
  final Color? headerColor;
  final Color? selectedShade1;

  final double? height;
  final double? borderWidth;
  final double? selectedTextSize;
  final double? dropDownIconSize;

  const MultiSelectPaginatedDropdown({
    super.key,
    required this.title,
    required this.items,
    required this.selectedItemsMap,
    required this.getDisplayValue,
    required this.getKeyValue,
    required this.onChanged,
    required this.onLoadMore,
    required this.onRefresh,
    required this.isLoading,
    required this.isLoadMoreLoading,
    this.getSubtitleValue,
    this.getLeadingWidget,
    this.getTrailingWidget,
    this.hintText,
    this.themeColor,
    this.headerColor,
    this.selectedShade1,
    this.height,
    this.borderWidth,
    this.selectedTextSize,
    this.dropDownIconSize,
    this.selectedDisplayColor,
  });

  @override
  Widget build(BuildContext context) {
    final primary = themeColor ?? Colors.blue.shade700;
    final headColor = headerColor ?? primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            HapticHelper.light();
            _showDialog(context, headColor, primary, isDark);
          },
          child: Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.cardBg(context),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.border(context),
                width: borderWidth ?? 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow(context),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.group, color: AppColors.textSecondary(context)),
                const SizedBox(width: 10),
                Expanded(
                  child: Obx(() {
                    final hasValue = selectedItemsMap.isNotEmpty;

                    return Text(
                      hasValue
                          ? "${selectedItemsMap.length} selected"
                          : (hintText ?? 'select_items'.tr),
                      style: TextStyle(
                        fontSize: selectedTextSize ?? 10.sp,
                        fontWeight: hasValue
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: hasValue
                            ? selectedDisplayColor ?? primary
                            : AppColors.textSecondary(context),
                      ),
                    );
                  }),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: dropDownIconSize ?? 24,
                  color: AppColors.textHint(context),
                ),
              ],
            ),
          ),
        ),

        /// CHIPS
        Obx(() {
          if (selectedItemsMap.isEmpty) return const SizedBox();

          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              children: selectedItemsMap.values.map((item) {
                final key = getKeyValue(item);

                return Chip(
                  label: Text(getDisplayValue(item)),
                  backgroundColor: isDark
                      ? headColor.withValues(alpha: 0.2)
                      : (selectedShade1 ?? Colors.blue.shade50),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => selectedItemsMap.remove(key),
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }

  void _showDialog(
    BuildContext context,
    Color headerColor,
    Color primary,
    bool isDark,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (_) => Dialog(
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
              /// HEADER
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
                    Obx(() {
                      if (selectedItemsMap.isEmpty) return const SizedBox();
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "${selectedItemsMap.length} selected",
                          style: TextStyle(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              /// SEARCH
              Padding(
                padding: EdgeInsets.fromLTRB(24, 1.5.hp, 24, 1.hp),
                child: TextField(
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    hintText: 'search_ellipsis'.tr,
                    hintStyle: TextStyle(
                      fontSize: 9.5.sp,
                      color: AppColors.textHint(context),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 18,
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
                  ),
                ),
              ),

              /// LIST
              Expanded(
                child: Obx(() {
                  if (isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(color: primary),
                    );
                  }

                  if (items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 40,
                            color: AppColors.iconMuted(context),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'no_friends_found'.tr,
                            style: TextStyle(
                              color: AppColors.textSecondary(context),
                              fontSize: 9.5.sp,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    itemCount: items.length,
                    itemBuilder: (_, index) {
                      final item = items[index];
                      final key = getKeyValue(item);

                      return Obx(() {
                        final selected = selectedItemsMap.containsKey(key);

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: selected
                                ? (isDark
                                      ? headerColor.withValues(alpha: 0.15)
                                      : selectedShade1 ?? Colors.blue.shade50)
                                : AppColors.cardBg(context),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: selected
                                  ? (isDark
                                        ? headerColor.withValues(alpha: 0.5)
                                        : headerColor.withValues(alpha: 0.3))
                                  : AppColors.divider(context),
                              width: 1.5,
                            ),
                            boxShadow: selected
                                ? [
                                    BoxShadow(
                                      color: isDark
                                          ? headerColor.withValues(alpha: 0.2)
                                          : (selectedShade1 ??
                                                Colors.blue.shade50),
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
                                if (selected) {
                                  selectedItemsMap.remove(key);
                                } else {
                                  selectedItemsMap[key] = item;
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: selected
                                            ? headerColor
                                            : AppColors.divider(context),
                                        border: Border.all(
                                          color: selected
                                              ? Colors.white
                                              : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      child: Icon(
                                        selected
                                            ? Icons.check
                                            : Icons.check_box_outline_blank,
                                        color: selected
                                            ? Colors.white
                                            : AppColors.textHint(context),
                                        size: 16,
                                      ),
                                    ),
                                    SizedBox(width: 3.wp),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getDisplayValue(item),
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              fontWeight: selected
                                                  ? FontWeight.w600
                                                  : FontWeight.w500,
                                              color: selected
                                                  ? primary
                                                  : AppColors.textPrimary(
                                                      context,
                                                    ),
                                            ),
                                          ),
                                          if (getSubtitleValue != null &&
                                              getTrailingWidget == null)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 2,
                                              ),
                                              child: Text(
                                                getSubtitleValue!(item),
                                                style: TextStyle(
                                                  fontSize: 8.5.sp,
                                                  color:
                                                      AppColors.textSecondary(
                                                        context,
                                                      ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    if (getTrailingWidget != null)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: getTrailingWidget!(item),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  );
                }),
              ),

              /// CLOSE BUTTON
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
                      'done'.tr,
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
      ),
    );
  }
}
