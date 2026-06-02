import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/haptic_helper.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

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
                          : (hintText ?? "Select items"),
                      style: TextStyle(
                        fontSize: selectedTextSize ?? 10.sp,
                        fontWeight:
                            hasValue ? FontWeight.w600 : FontWeight.w500,
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
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Material(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: 60.hp,
            child: Column(
              children: [
                /// HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: headerColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Obx(() {
                        if (selectedItemsMap.isEmpty) return const SizedBox();
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${selectedItemsMap.length}",
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
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
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                  child: TextField(
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      hintText: "Search...",
                      hintStyle: TextStyle(
                        color: AppColors.textHint(context),
                        fontSize: 10.sp,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.textHint(context),
                      ),
                      filled: true,
                      fillColor: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),

                /// LIST
                Expanded(
                  child: Obx(() {
                    if (isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (items.isEmpty) {
                      return Center(
                        child: Text(
                          "No friends found",
                          style: TextStyle(
                            color: AppColors.textSecondary(context),
                            fontSize: 10.sp,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: AppColors.border(context).withValues(alpha: 0.3),
                      ),
                      itemBuilder: (_, index) {
                        final item = items[index];
                        final key = getKeyValue(item);

                        return Obx(() {
                          final selected = selectedItemsMap.containsKey(key);

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 2,
                            ),
                            leading: getLeadingWidget != null
                                ? getLeadingWidget!(item)
                                : null,
                            title: Text(
                              getDisplayValue(item),
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                            subtitle: getSubtitleValue != null
                                ? Text(
                                    getSubtitleValue!(item),
                                    style: TextStyle(
                                      fontSize: 8.5.sp,
                                      color: AppColors.textSecondary(context),
                                    ),
                                  )
                                : null,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (getTrailingWidget != null)
                                  getTrailingWidget!(item),
                                Checkbox(
                                  value: selected,
                                  activeColor: primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  onChanged: (_) {
                                    HapticHelper.selection();
                                    if (selected) {
                                      selectedItemsMap.remove(key);
                                    } else {
                                      selectedItemsMap[key] = item;
                                    }
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
                              HapticHelper.selection();
                              if (selected) {
                                selectedItemsMap.remove(key);
                              } else {
                                selectedItemsMap[key] = item;
                              }
                            },
                          );
                        });
                      },
                    );
                  }),
                ),

                /// DONE BUTTON
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Done",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
