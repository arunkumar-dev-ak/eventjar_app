import 'package:eventjar/controller/view_trip/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/widget/form_submit_button.dart';
import 'package:eventjar/model/view_trip/trip_friend_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettleUpDialog extends GetView<ViewTripController> {
  final TripFriendModel friend;
  final PaymentActionType type;

  const SettleUpDialog({super.key, required this.friend, required this.type});

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
            _header(context),
            SizedBox(height: 2.hp),

            _amountDisplay(context),
            SizedBox(height: 2.hp),

            _paymentDropdown(context),
            SizedBox(height: 2.hp),

            _notesField(context),
            SizedBox(height: 3.hp),

            _submitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          type == PaymentActionType.record ? "Record" : 'settle_up'.tr,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(context),
          ),
        ),
        GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.close, color: AppColors.textSecondary(context)),
        ),
      ],
    );
  }

  Widget _paymentDropdown(BuildContext context) {
    return Obx(() {
      return DropdownButtonFormField<String>(
        initialValue: controller.state.paymentMethod.value,
        items: controller.state.paymentMethods
            .map((m) => DropdownMenuItem(value: m, child: Text(m)))
            .toList(),
        onChanged: (v) {
          if (v != null) controller.state.paymentMethod.value = v;
        },
        decoration: _inputDecoration(context, "Payment Method", null),
      );
    });
  }

  Widget _notesField(BuildContext context) {
    return TextField(
      controller: controller.settleNotesController,
      maxLines: 2,
      decoration: _inputDecoration(context, "Notes (optional)", null),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Obx(() {
      final isLoading = controller.state.isSettleupLoading.value;
      final isRecord = type == PaymentActionType.record;

      return SizedBox(
        width: double.infinity,
        child: FormButton(
          text: isLoading
              ? (isRecord ? "Recording..." : "Settling...")
              : (isRecord ? "Record Payment" : 'settle_up'.tr),
          isLoading: isLoading,
          type: FormButtonType.primary,
          icon: isRecord ? Icons.receipt_long : Icons.check_circle,
          onPressed: () {
            Get.focusScope?.unfocus();
            if (isLoading) return;
            controller.submitSettleUp(friend, type);
          },
        ),
      );
    });
  }

  InputDecoration _inputDecoration(
    BuildContext context,
    String label,
    String? prefix,
  ) {
    return InputDecoration(
      labelText: label,
      prefixText: prefix,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _amountDisplay(BuildContext context) {
    final raw = double.tryParse(controller.settleAmountController.text) ?? 0;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 2.hp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'amount'.tr,
            style: TextStyle(
              fontSize: 9.sp,
              color: AppColors.textSecondary(context),
            ),
          ),
          SizedBox(height: 0.5.hp),

          Text(
            "₹ ${raw.toStringAsFixed(0)}",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: type == PaymentActionType.settleUp
                  ? Colors.red
                  : Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
