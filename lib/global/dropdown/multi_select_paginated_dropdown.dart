import 'package:eventjar/global/app_colors.dart';
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

  final Function(String) onChanged;
  final VoidCallback onLoadMore;
  final VoidCallback onRefresh;

  final RxBool isLoading;
  final RxBool isLoadMoreLoading;

  /// 🔥 NEW OPTIONALS
  final String? hintText;
  final Color? themeColor;
  final Color? headerColor;
  final Color? selectedShade1;
  final Color? selectedShade2;
  final Color? selectedShade3;

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

    /// 🔥 optional
    this.hintText,
    this.themeColor,
    this.headerColor,
    this.selectedShade1,
    this.selectedShade2,
    this.selectedShade3,
    this.height,
    this.borderWidth,
    this.selectedTextSize,
    this.dropDownIconSize,
  });

  @override
  Widget build(BuildContext context) {
    final primary = themeColor ?? Colors.blue.shade700;
    final headColor = headerColor ?? primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔥 TRIGGER BOX
        GestureDetector(
          onTap: () => _showDialog(context, headColor, primary, isDark),
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

                /// TEXT
                Expanded(
                  child: Obx(() {
                    final hasValue = selectedItemsMap.isNotEmpty;

                    return Text(
                      hasValue
                          ? "${selectedItemsMap.length} selected"
                          : (hintText ?? "Select items"),
                      style: TextStyle(
                        fontSize: selectedTextSize ?? 10.sp,
                        fontWeight: hasValue
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: hasValue
                            ? primary
                            : AppColors.textSecondary(context),
                      ),
                    );
                  }),
                ),

                /// ICON
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: dropDownIconSize ?? 24,
                  color: AppColors.textHint(context),
                ),
              ],
            ),
          ),
        ),

        /// 🔥 CHIPS
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
        child: Container(
          height: 60.hp,
          decoration: BoxDecoration(
            color: AppColors.cardBg(context),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              /// 🔥 HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: headerColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
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

              /// SEARCH
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  onChanged: onChanged,
                  decoration: const InputDecoration(
                    hintText: "Search...",
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),

              /// LIST
              Expanded(
                child: Obx(() {
                  if (isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, index) {
                      final item = items[index];
                      final key = getKeyValue(item);

                      return Obx(() {
                        final selected = selectedItemsMap.containsKey(key);

                        return CheckboxListTile(
                          value: selected,
                          activeColor: primary,
                          title: Text(getDisplayValue(item)),
                          onChanged: (_) {
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

              /// DONE
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Done"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
