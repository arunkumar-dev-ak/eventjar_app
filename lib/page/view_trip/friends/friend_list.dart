import 'package:eventjar/controller/view_trip/controller.dart';
import 'package:eventjar/global/haptic_helper.dart';
import 'package:eventjar/model/budget_track/friend_model.dart';
import 'package:flutter/material.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:get/get.dart';

class FriendsList extends GetView<ViewTripController> {
  const FriendsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final friends = controller.state.friends;

      return Column(
        children: List.generate(
          friends.length,
          (index) => _friendItem(context, friends[index]),
        ),
      );
    });
  }

  // ================= ITEM =================
  Widget _friendItem(BuildContext context, FriendModel f) {
    final isOwe = f.youOwe && !f.isSettled;
    final isReceive = !f.youOwe && !f.isSettled;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(top: 1.hp),
      padding: EdgeInsets.all(4.wp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        border: Border.all(color: AppColors.budgetTabColor, width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: f.isYou
                      ? AppColors.gradientDarkStart.withValues(alpha: 0.15)
                      : (isDark
                            ? AppColors.darkCardElevated
                            : const Color(0xFFE0E0E0)),
                ),
                child: Center(
                  child: Text(
                    f.name[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: f.isYou
                          ? AppColors.gradientDarkStart
                          : AppColors.textSecondary(context),
                    ),
                  ),
                ),
              ),
              if (f.isYou)
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.gradientDarkStart,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "ME",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(width: 3.wp),

          // CENTER CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// NAME
                Text(
                  f.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                    color: AppColors.textPrimary(context),
                  ),
                ),

                SizedBox(height: 0.3.hp),

                /// STATUS TEXT
                _statusText(context, f, isOwe, isReceive),
              ],
            ),
          ),

          // RIGHT ACTION
          _actionButton(context, f),
        ],
      ),
    );
  }

  /// ================= STATUS TEXT =================
  Widget _statusText(
    BuildContext context,
    FriendModel f,
    bool isOwe,
    bool isReceive,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (f.isSettled) {
      return Text(
        "No dues",
        style: TextStyle(
          color: AppColors.textSecondary(context),
          fontSize: 8.5.sp,
        ),
      );
    }

    if (isOwe) {
      return Text(
        "You owe ₹${f.amount.toStringAsFixed(0)}",
        style: TextStyle(
          color: isDark ? Colors.red.shade300 : Colors.red.shade700,
          fontSize: 8.5.sp,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return Text(
      "You receive ₹${f.amount.toStringAsFixed(0)}",
      style: TextStyle(
        color: isDark ? Colors.green.shade300 : Colors.green.shade700,
        fontSize: 8.5.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// ================= ACTION =================
  Widget _actionButton(BuildContext context, FriendModel f) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    /// ✅ SETTLED
    if (f.isSettled) {
      return Icon(
        Icons.check_circle_outline,
        color: isDark ? Colors.green.shade400 : Colors.green.shade600,
        size: 22,
      );
    }

    if (f.youOwe) {
      return InkWell(
        onTap: () => _showSettleUpDialog(context, f),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.5.wp, vertical: 0.8.hp),
          decoration: BoxDecoration(
            gradient: AppColors.buttonGradientFor(context),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "SettleUp",
            style: TextStyle(
              color: Colors.white,
              fontSize: 8.5.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    /// 🔵 YOU RECEIVE → REMIND (SECONDARY CTA)
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.5.wp, vertical: 0.8.hp),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: isDark ? 0.2 : 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "Remind",
          style: TextStyle(
            color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
            fontSize: 8.5.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showSettleUpDialog(BuildContext context, FriendModel f) {
    HapticHelper.medium();
    showDialog(
      context: context,
      builder: (_) => _SettleUpDialog(friend: f),
    );
  }
}

class _SettleUpDialog extends StatefulWidget {
  final FriendModel friend;
  const _SettleUpDialog({required this.friend});

  @override
  State<_SettleUpDialog> createState() => _SettleUpDialogState();
}

class _SettleUpDialogState extends State<_SettleUpDialog> {
  late final TextEditingController _amountController;
  final TextEditingController _notesController = TextEditingController();
  String _paymentMethod = 'UPI';
  final _methods = ['Cash', 'UPI', 'Others'];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.friend.amount.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Settle Up",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.5.hp),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Pay ${widget.friend.name}",
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary(context),
                ),
              ),
            ),
            SizedBox(height: 2.hp),

            // Amount
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
              decoration: InputDecoration(
                labelText: "Amount",
                labelStyle: TextStyle(
                  fontSize: 9.sp,
                  color: AppColors.textSecondary(context),
                ),
                prefixText: "₹ ",
                prefixStyle: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.divider(context)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.gradientDarkStart),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.wp,
                  vertical: 1.5.hp,
                ),
              ),
            ),
            SizedBox(height: 2.hp),

            // Payment Method
            DropdownButtonFormField<String>(
              initialValue: _paymentMethod,
              items: _methods
                  .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _paymentMethod = v);
              },
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.textPrimary(context),
              ),
              decoration: InputDecoration(
                labelText: "Payment Method",
                labelStyle: TextStyle(
                  fontSize: 9.sp,
                  color: AppColors.textSecondary(context),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.divider(context)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.gradientDarkStart),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.wp,
                  vertical: 1.5.hp,
                ),
              ),
            ),
            SizedBox(height: 2.hp),

            // Notes
            TextField(
              controller: _notesController,
              maxLines: 2,
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.textPrimary(context),
              ),
              decoration: InputDecoration(
                labelText: "Notes (optional)",
                labelStyle: TextStyle(
                  fontSize: 9.sp,
                  color: AppColors.textSecondary(context),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.divider(context)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.gradientDarkStart),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.wp,
                  vertical: 1.5.hp,
                ),
              ),
            ),
            SizedBox(height: 3.hp),

            // Submit
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Payment of ₹${_amountController.text} to ${widget.friend.name} recorded',
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gradientDarkStart,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 1.5.hp),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
