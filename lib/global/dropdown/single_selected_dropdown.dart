import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SingleSelectFilterDropdown<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final Rx<T>? selectedItem;
  final T Function() getDefaultItem;
  final String Function(T) getDisplayValue;
  final T Function(T) getKeyValue;
  final Function(T) onSelected;
  final String? hintText;

  // ✅ All styling as props
  final EdgeInsets dialogPadding;
  final double dialogBorderRadius;
  final EdgeInsets dialogInsetPadding;
  final double dialogMaxHeightFactor;
  final Color dialogBackgroundColor;
  final double titleFontSize;
  final FontWeight titleFontWeight;
  final Color titleTextColor;
  final double dividerThickness;
  final Color dividerColor;
  final EdgeInsets listPadding;
  final EdgeInsets buttonPadding;
  final double buttonBorderRadius;
  final Color buttonBackgroundColor;
  final double buttonTextSize;
  final EdgeInsets dropdownPadding;
  final double dropdownBorderRadius;
  final double dropdownBorderWidth;
  final Color dropdownBorderColor;
  final double dropdownTextSize;
  final Color dropdownIconColor;
  final Color selectedCheckColor;

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

    // Dialog styling
    this.dialogPadding = const EdgeInsets.all(16),
    this.dialogBorderRadius = 16,
    this.dialogInsetPadding = const EdgeInsets.symmetric(
      horizontal: 40,
      vertical: 24,
    ),
    this.dialogMaxHeightFactor = 0.5,
    this.dialogBackgroundColor = Colors.white,

    // Title styling
    this.titleFontSize = 18,
    this.titleFontWeight = FontWeight.bold,
    this.titleTextColor = Colors.blue,

    // Divider
    this.dividerThickness = 1,
    this.dividerColor = Colors.grey,

    // List
    this.listPadding = const EdgeInsets.only(top: 8),

    // Buttons
    this.buttonPadding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 8,
    ),
    this.buttonBorderRadius = 12,
    this.buttonBackgroundColor = Colors.blue,
    this.buttonTextSize = 16,

    // Dropdown container
    this.dropdownPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 14,
    ),
    this.dropdownBorderRadius = 12,
    this.dropdownBorderWidth = 1.5,
    this.dropdownBorderColor = Colors.grey,
    this.dropdownTextSize = 16,
    this.dropdownIconColor = Colors.black87,
    this.selectedCheckColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = selectedItem?.value;
      final displayText =
          selected != null &&
              getKeyValue(selected) != getKeyValue(getDefaultItem())
          ? getDisplayValue(selected)
          : hintText ?? 'All Status';
      final isValueSelected = displayText != 'hintText';

      return GestureDetector(
        onTap: () => _showFilterDialog(context),
        child: Container(
          padding: dropdownPadding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(dropdownBorderRadius),
            border: Border.all(
              color: isValueSelected ? titleTextColor : dropdownBorderColor,
              width: dropdownBorderWidth,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                displayText,
                style: TextStyle(
                  fontSize: dropdownTextSize,
                  color: isValueSelected ? titleTextColor : Colors.black,
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: isValueSelected ? titleTextColor : dropdownIconColor,
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dialogBorderRadius),
        ),
        insetPadding: dialogInsetPadding,
        child: Container(
          constraints: BoxConstraints(
            maxHeight:
                MediaQuery.of(context).size.height * dialogMaxHeightFactor,
          ),
          decoration: BoxDecoration(
            color: dialogBackgroundColor,
            borderRadius: BorderRadius.circular(dialogBorderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          padding: dialogPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Container(
                padding: EdgeInsets.only(
                  top: dialogPadding.top * 0.5,
                  bottom: 16,
                  left: dialogPadding.horizontal,
                  right: dialogPadding.horizontal,
                ),
                child: Obx(() {
                  final selected = selectedItem?.value;
                  final isDefault =
                      selected == null ||
                      getKeyValue(selected) == getKeyValue(getDefaultItem());

                  String headerTitle = isDefault
                      ? title
                      : getDisplayValue(selected);

                  return Column(
                    children: [
                      Text(
                        headerTitle,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: titleFontWeight,
                          color: titleTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                }),
              ),
              Divider(color: dividerColor, thickness: dividerThickness),

              // ✅ New Card List (No Dividers)
              Expanded(child: _buildFilterList(context)),

              const SizedBox(height: 8),

              // Cancel button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: buttonPadding,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(buttonBorderRadius),
                    ),
                    backgroundColor: buttonBackgroundColor.withValues(
                      alpha: 0.1,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: buttonTextSize),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterList(BuildContext context) {
    // Extract constants before Obx
    // final safeSelectedCheckColor = selectedCheckColor;
    final safeTitleTextColor = titleTextColor;

    return Obx(() {
      final selected = selectedItem?.value;
      final selectedKey = selected != null ? getKeyValue(selected) : null;

      return ListView.builder(
        padding: listPadding,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = getKeyValue(item) == selectedKey;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            decoration: BoxDecoration(
              // ✅ Selected theme background
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        safeTitleTextColor.withValues(alpha: 0.12),
                        safeTitleTextColor.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? safeTitleTextColor.withValues(alpha: 0.3)
                    : Colors.transparent,
                width: isSelected ? 1.5 : 0,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: safeTitleTextColor.withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      // Leading Circle Icon
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(
                                  colors: [
                                    safeTitleTextColor.withValues(alpha: 0.25),
                                    safeTitleTextColor.withValues(alpha: 0.15),
                                  ],
                                )
                              : null,
                          color: isSelected ? null : Colors.grey.shade100,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? safeTitleTextColor.withValues(alpha: 0.4)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? Icon(
                                Icons.radio_button_checked_outlined,
                                color: safeTitleTextColor,
                                size: 24,
                              )
                            : Icon(
                                Icons.radio_button_unchecked_outlined,
                                color: Colors.grey.shade500,
                                size: 24,
                              ),
                      ),
                      const SizedBox(width: 16),

                      // Title with weight change
                      Expanded(
                        child: Text(
                          getDisplayValue(item),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: isSelected
                                ? safeTitleTextColor
                                : Colors.grey.shade800,
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
    });
  }
}
