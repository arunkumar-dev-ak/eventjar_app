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
  final double? borderWidth;
  final double? height;
  final double? selectedTextSize;
  final double? dropDownIconSize;
  final EdgeInsetsGeometry? textFieldPadding;

  // 🔧 Pagination & search
  final Function(String) onChanged;
  final Function() onClickedLoadMore;
  final RxBool onLoadMoreLoading; // ObxBool, use .value
  final RxBool onDropdownListLoading; // ObxBool, use .value
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
    this.textFieldPadding,
    required this.onChanged,
    required this.onClickedLoadMore,
    required this.onDropdownListLoading,
    required this.onLoadMoreLoading,
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade400, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
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
                  color: isSelected ? primary : Colors.grey.shade600,
                ),
              ),
              AnimatedRotation(
                duration: const Duration(milliseconds: 200),
                turns: isSelected ? 0.25 : 0,
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: dropDownIconSize ?? 24,
                  color: isSelected ? primary : Colors.grey.shade500,
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
    final RxString searchText = ''.obs;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600, maxWidth: 400),
          decoration: BoxDecoration(
            color: Colors.white,
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
              // Modern Header with Refresh
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.refresh,
                            size: 18,
                            color: Colors.white,
                          ),
                          onPressed: onRefresh,
                          tooltip: 'Refresh',
                        ),
                      ],
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

              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search $title...',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: headerColor),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 18,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  onChanged: (value) {
                    searchText.value = value;
                    onChanged(value);
                  },
                ),
              ),
              SizedBox(height: 1.hp),

              // Fixed-height container for list + Load More
              SizedBox(
                height: 350,
                child: Column(
                  children: [
                    // Scrollable list area
                    Expanded(
                      child: Obx(() {
                        final bool isListLoading = onDropdownListLoading.value;
                        final T? selected = selectedItem.value;
                        final List<T> filteredItems = items.isEmpty
                            ? []
                            : items;
                        final bool isLoadMoreLoading = onLoadMoreLoading.value;

                        // Empty state
                        if (filteredItems.isEmpty) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isListLoading
                                    ? Icons.hourglass_empty
                                    : Icons.search_off,
                                size: 40,
                                color: Colors.grey.shade400,
                              ),
                              SizedBox(height: 8),
                              Text(
                                isListLoading
                                    ? 'Loading...'
                                    : items.isEmpty
                                    ? 'No Data loaded'
                                    : 'No matches found',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          );
                        }

                        return Stack(
                          children: [
                            // List
                            ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              itemCount: filteredItems.length + 1,
                              itemBuilder: (context, index) {
                                if (index >= filteredItems.length) {
                                  if (isLoadMoreLoading) {
                                    return Center(
                                      child: SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: primary,
                                        ),
                                      ),
                                    );
                                  }
                                  return GestureDetector(
                                    onTap: onClickedLoadMore,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        16,
                                        8,
                                        16,
                                        16,
                                      ),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Load More',
                                            style: TextStyle(
                                              fontSize: 8.sp,
                                              fontWeight: FontWeight.w500,
                                              color: primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                final T item = filteredItems[index];
                                final bool isSelectedItem =
                                    selected != null &&
                                    getKeyValue(item) == getKeyValue(selected);

                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: isSelectedItem
                                        ? selectedShade1
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelectedItem
                                          ? selectedShade3
                                          : Colors.grey.shade100,
                                      width: 1.5,
                                    ),
                                    boxShadow: isSelectedItem
                                        ? [
                                            BoxShadow(
                                              color: selectedShade1,
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
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: isSelectedItem
                                                    ? headerColor
                                                    : Colors.grey.shade200,
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
                                                    : Icons
                                                          .radio_button_unchecked,
                                                color: isSelectedItem
                                                    ? Colors.white
                                                    : Colors.grey.shade500,
                                                size: 14,
                                              ),
                                            ),
                                            SizedBox(width: 2.5.wp),
                                            Expanded(
                                              child: Text(
                                                getDisplayValue(item),
                                                style: TextStyle(
                                                  fontSize: 11.sp,
                                                  fontWeight: isSelectedItem
                                                      ? FontWeight.w600
                                                      : FontWeight.w500,
                                                  color: isSelectedItem
                                                      ? primary
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
                            ),

                            // Full-list overlay loader
                            if (isListLoading)
                              Positioned.fill(
                                child: Container(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                    color: primary,
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
