import 'package:eventjar/controller/checkout/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/checkout/checkout_header.dart';
import 'package:eventjar/page/checkout/checkout_price_summary.dart';
import 'package:eventjar/page/checkout/checkout_submit_button.dart';
import 'package:eventjar/page/checkout/checkout_terms_text.dart';
import 'package:eventjar/page/checkout/checkout_ticket/checkout_ticket_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutPage extends GetView<CheckoutController> {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: Obx(() {
        final eventInfo = controller.state.eventInfo.value;

        if (eventInfo == null) {
          return _buildEmptyState();
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 2.hp),

              // Progress Steps
              _buildProgressSteps(),
              SizedBox(height: 2.5.hp),

              // Event Information Card
              buildCheckoutEventInfo(eventInfo, context),
              SizedBox(height: 2.hp),

              // Ticket Details Card
              buildCheckoutPageTicketDetailsCard(eventInfo),
              SizedBox(height: 2.hp),

              // Price Summary Section
              buildCheckoutPriceSummarySection(),
              SizedBox(height: 2.5.hp),

              // Continue Button
              buildCheckoutContinueButton(),
              SizedBox(height: 1.5.hp),

              // Terms and Conditions
              buildCheckoutTermsText(),
              SizedBox(height: 4.hp),
            ],
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: AppColors.appBarGradient,
        ),
      ),
      leading: Padding(
        padding: EdgeInsets.all(1.wp),
        child: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
      title: Text(
        "Checkout",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12.sp,
          color: Colors.white,
        ),
      ),
      centerTitle: false,
    );
  }

  Widget _buildProgressSteps() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.wp),
      padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.5.hp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildProgressStep(1, "Select", Icons.confirmation_number_outlined, true),
          _buildProgressLine(true),
          _buildProgressStep(2, "Review", Icons.receipt_long_outlined, true),
          _buildProgressLine(false),
          _buildProgressStep(3, "Pay", Icons.payment_rounded, false),
        ],
      ),
    );
  }

  Widget _buildProgressStep(int step, String label, IconData icon, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: isActive
                ? LinearGradient(
                    colors: [AppColors.gradientDarkStart, AppColors.gradientDarkEnd],
                  )
                : null,
            color: isActive ? null : Colors.grey.shade200,
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.gradientDarkStart.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            size: 18,
            color: isActive ? Colors.white : Colors.grey.shade400,
          ),
        ),
        SizedBox(height: 0.8.hp),
        Text(
          label,
          style: TextStyle(
            fontSize: 7.sp,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? AppColors.gradientDarkStart : Colors.grey.shade400,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 3,
        margin: EdgeInsets.only(bottom: 2.hp),
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  colors: [AppColors.gradientDarkStart, AppColors.gradientDarkEnd],
                )
              : null,
          color: isActive ? null : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(6.wp),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_busy_rounded,
              size: 48,
              color: Colors.grey.shade400,
            ),
          ),
          SizedBox(height: 2.hp),
          Text(
            "No event information available",
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.hp),
          TextButton.icon(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_rounded, size: 18),
            label: Text("Go Back"),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.gradientDarkStart,
            ),
          ),
        ],
      ),
    );
  }
}
