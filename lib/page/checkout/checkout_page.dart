import 'package:eventjar/controller/checkout/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/checkout/checkout_header.dart';
import 'package:eventjar/page/checkout/checkout_price_summary.dart';
import 'package:eventjar/page/checkout/checkout_submit_button.dart';
import 'package:eventjar/page/checkout/checkout_terms_text.dart';
import 'package:eventjar/page/checkout/checkout_ticket_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutPage extends GetView<CheckoutController> {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors.appBarGradient),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        final eventInfo = controller.state.eventInfo.value;

        if (eventInfo == null) {
          return const Center(child: Text("No event information available"));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // Event Information Card
              buildCheckoutEventInfo(eventInfo, context),
              SizedBox(height: 2.hp),

              // Ticket Details Card (with warning inside if applicable)
              buildCheckoutPageTicketDetailsCard(eventInfo),
              SizedBox(height: 2.hp),

              // Price Summary Section (Blue gradient)
              buildCheckoutPriceSummarySection(),
              SizedBox(height: 2.hp),

              // Continue Button
              buildCheckoutContinueButton(),
              SizedBox(height: 1.hp),

              // Terms and Conditions
              buildCheckoutTermsText(),
              SizedBox(height: 3.hp),
            ],
          ),
        );
      }),
    );
  }
}
