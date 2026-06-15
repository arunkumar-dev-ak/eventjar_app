import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimezoneSearchDropdown extends StatefulWidget {
  final String label;
  final RxString selectedValue;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const TimezoneSearchDropdown({
    super.key,
    required this.label,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  @override
  State<TimezoneSearchDropdown> createState() => _TimezoneSearchDropdownState();
}

class _TimezoneSearchDropdownState extends State<TimezoneSearchDropdown> {
  final _searchController = TextEditingController();
  final _filteredItems = <String>[].obs;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _filteredItems.value = widget.items;
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      _filteredItems.value = widget.items;
    } else {
      final q = query.toLowerCase();
      _filteredItems.value =
          widget.items.where((tz) => tz.toLowerCase().contains(q)).toList();
    }
  }

  void _showPicker() {
    _searchController.clear();
    _filteredItems.value = widget.items;
    setState(() => _isOpen = true);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBg(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textHint(context),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4.wp),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'search_timezone'.tr,
                      hintStyle: TextStyle(
                        fontSize: 8.5.sp,
                        color: AppColors.textHint(context),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.textHint(context),
                      ),
                      filled: true,
                      fillColor: AppColors.inputBg(context),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 3.wp,
                        vertical: 1.5.hp,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 8.5.sp,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    final items = _filteredItems;
                    if (items.isEmpty) {
                      return Center(
                        child: Text(
                          'no_results_found'.tr,
                          style: TextStyle(
                            fontSize: 8.5.sp,
                            color: AppColors.textHint(context),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final tz = items[index];
                        final isSelected =
                            tz == widget.selectedValue.value;
                        return ListTile(
                          title: Text(
                            tz.replaceAll('_', ' '),
                            style: TextStyle(
                              fontSize: 8.5.sp,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppColors.gradientDarkStart
                                  : AppColors.textPrimary(context),
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_circle,
                                  color: AppColors.gradientDarkStart,
                                  size: 20,
                                )
                              : null,
                          onTap: () {
                            widget.onChanged(tz);
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  }),
                ),
              ],
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() => _isOpen = false);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 8.5.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary(context),
          ),
        ),
        SizedBox(height: 1.hp),
        Obx(
          () => GestureDetector(
            onTap: _showPicker,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 3.wp,
                vertical: 1.5.hp,
              ),
              decoration: BoxDecoration(
                color: AppColors.cardBg(context),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border(context)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.selectedValue.value.replaceAll('_', ' '),
                      style: TextStyle(
                        fontSize: 8.5.sp,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                  Icon(
                    _isOpen
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.iconMuted(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
