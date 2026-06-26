import 'package:eventjar/controller/transaction/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionDateSelector extends GetView<TransactionController> {
  const TransactionDateSelector({super.key});

  static Color accentColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? const Color(0xFF3A7BD5)
        : AppColors.gradientDarkStart;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.wp),
      padding: EdgeInsets.symmetric(vertical: 1.5.hp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow(context),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MonthYearHeader(),
          SizedBox(height: 1.hp),
          _DateScroller(),
        ],
      ),
    );
  }
}

class _MonthYearHeader extends GetView<TransactionController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.wp),
      child: Obx(() {
        final month = controller.state.displayedMonth.value;
        final year = controller.state.displayedYear.value;
        final displayDate = DateTime(year, month);
        final label = DateFormat('MMMM yyyy').format(displayDate);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: controller.previousMonth,
              child: Icon(
                Icons.chevron_left_rounded,
                color: AppColors.textPrimary(context),
                size: 16.sp,
              ),
            ),
            GestureDetector(
              onTap: () => _showMonthYearPicker(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  SizedBox(width: 1.wp),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: TransactionDateSelector.accentColor(context),
                    size: 12.sp,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: controller.nextMonth,
              child: Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textPrimary(context),
                size: 16.sp,
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showMonthYearPicker(BuildContext context) {
    final currentMonth = controller.state.displayedMonth.value;
    final currentYear = controller.state.displayedYear.value;
    var tempMonth = currentMonth;
    var tempYear = currentYear;
    var showYearGrid = false;

    final accent = TransactionDateSelector.accentColor(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBg(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.wp, vertical: 2.hp),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10.wp,
                    height: 0.5.hp,
                    decoration: BoxDecoration(
                      color: AppColors.border(context),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 2.hp),
                  // Year row — tap year text to toggle year grid
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (tempYear > 2025) {
                            setState(() => tempYear--);
                          }
                        },
                        child: Icon(
                          Icons.chevron_left_rounded,
                          color: tempYear > 2025
                              ? accent
                              : AppColors.border(context),
                          size: 16.sp,
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            setState(() => showYearGrid = !showYearGrid),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              tempYear.toString(),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                            SizedBox(width: 1.wp),
                            Icon(
                              showYearGrid
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: accent,
                              size: 12.sp,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => tempYear++),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: accent,
                          size: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.hp),

                  // Year grid or Month grid
                  if (showYearGrid) ...[
                    _buildYearGrid(
                      context,
                      tempYear,
                      accent,
                      (year) => setState(() {
                        tempYear = year;
                        showYearGrid = false;
                      }),
                    ),
                  ] else ...[
                    _buildMonthGrid(context, tempMonth, accent, (month) {
                      setState(() => tempMonth = month);
                    }),
                  ],

                  SizedBox(height: 2.hp),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.setMonthYear(tempMonth, tempYear);
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 1.5.hp),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'done'.tr,
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 1.hp),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMonthGrid(
    BuildContext context,
    int selectedMonth,
    Color accent,
    ValueChanged<int> onSelect,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 2.2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 12,
      itemBuilder: (_, i) {
        final m = i + 1;
        final isSelected = m == selectedMonth;
        final monthName = DateFormat('MMM').format(DateTime(2000, m));
        return GestureDetector(
          onTap: () => onSelect(m),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? accent : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? null
                  : Border.all(
                      color: AppColors.border(context),
                      width: 0.8,
                    ),
            ),
            child: Text(
              monthName,
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? Colors.white
                    : AppColors.textPrimary(context),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildYearGrid(
    BuildContext context,
    int selectedYear,
    Color accent,
    ValueChanged<int> onSelect,
  ) {
    final now = DateTime.now().year;
    final yearCount = now - 2025 + 1;
    final years = List.generate(yearCount, (i) => 2025 + i);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 2.2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: years.length,
      itemBuilder: (_, i) {
        final year = years[i];
        final isSelected = year == selectedYear;
        return GestureDetector(
          onTap: () => onSelect(year),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? accent : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? null
                  : Border.all(
                      color: AppColors.border(context),
                      width: 0.8,
                    ),
            ),
            child: Text(
              year.toString(),
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? Colors.white
                    : AppColors.textPrimary(context),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DateScroller extends GetView<TransactionController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final month = controller.state.displayedMonth.value;
      final year = controller.state.displayedYear.value;
      final selected = controller.state.selectedDate.value;

      final daysInMonth = DateUtils.getDaysInMonth(year, month);
      final dates = List.generate(
        daysInMonth,
        (i) => DateTime(year, month, i + 1),
      );

      final today = DateTime.now();
      final initialIndex = (selected.year == year && selected.month == month)
          ? selected.day - 1
          : (today.year == year && today.month == month)
              ? today.day - 1
              : 0;

      final itemWidth = 12.5.wp;
      final screenWidth = Get.width;
      final initialOffset =
          (initialIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

      final scrollController = ScrollController(
        initialScrollOffset: initialOffset.clamp(
          0.0,
          ((daysInMonth * itemWidth) - screenWidth).clamp(0.0, double.infinity),
        ),
      );

      return SizedBox(
        height: 9.hp,
        child: ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 2.wp),
          itemCount: dates.length,
          itemBuilder: (_, i) {
            final date = dates[i];
            final isSelected = date.year == selected.year &&
                date.month == selected.month &&
                date.day == selected.day;
            return _DateItem(
              date: date,
              isSelected: isSelected,
              onTap: () => controller.state.selectedDate.value = date,
              width: itemWidth,
            );
          },
        ),
      );
    });
  }
}

class _DateItem extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;
  final double width;

  const _DateItem({
    required this.date,
    required this.isSelected,
    required this.onTap,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final dayName = DateFormat('E').format(date);
    final dayNumber = date.day.toString();
    final selectedBg = TransactionDateSelector.accentColor(context);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(horizontal: 2.wp, vertical: 1.hp),
            decoration: BoxDecoration(
              color: isSelected ? selectedBg : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  dayName,
                  style: TextStyle(
                    fontSize: 7.sp,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : AppColors.textSecondary(context),
                  ),
                ),
                SizedBox(height: 0.5.hp),
                Text(
                  dayNumber,
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : AppColors.textPrimary(context),
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
