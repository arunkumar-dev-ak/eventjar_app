import 'package:eventjar/controller/checkout/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/checkout/widget/checkout_event_card.dart';
import 'package:eventjar/page/checkout/widget/checkout_order_summary.dart';
import 'package:eventjar/page/checkout/widget/checkout_promo_section.dart';
import 'package:eventjar/page/checkout/widget/checkout_ticket_section.dart';
import 'package:eventjar/page/checkout/widget/bottom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutPage extends GetView<CheckoutController> {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),

      appBar: AppBar(
        title: Text(
          "checkout".tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13.sp,
            color: AppColors.textPrimary(context),
          ),
        ),
        backgroundColor: AppColors.cardBg(context),
        elevation: 0.5,
        iconTheme: IconThemeData(color: AppColors.textPrimary(context)),
      ),

      body: Obx(() {
        final eventInfo = controller.state.eventInfo.value;

        if (eventInfo == null) {
          return Center(child: Text('no_event_available'.tr));
        }

        return Column(
          children: [
            const PremiumBadgeStatusBanner(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 2.hp),
                child: GestureDetector(
                  onTap: () => Get.focusScope?.unfocus(),
                  child: Column(
                    children: [
                      SizedBox(height: 2.hp),
                      CheckoutEventCard(eventInfo: eventInfo),
                      SizedBox(height: 2.hp),
                      CheckoutTicketSection(eventInfo: eventInfo),
                      SizedBox(height: 2.hp),
                      CheckoutPromoSection(),
                      SizedBox(height: 2.hp),
                      CheckoutOrderSummary(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),

      bottomNavigationBar: SafeArea(child: const CheckoutBottomBar()),
    );
  }
}
