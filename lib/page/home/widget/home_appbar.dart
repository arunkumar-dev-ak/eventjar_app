import 'package:eventjar/controller/home/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/widget/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ContactAction { addContact, nfc }

class HomeAppBar extends StatelessWidget {
  final HomeController controller = Get.find();

  HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.wp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //logo
          Row(
            children: [
              Image.asset(
                controller.logoPath,
                width: 25,
                height: 25,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 2.wp),
              //header
              GradientText(
                textSize: 13.sp,
                content: controller.appBarTitle,
                gradientStart: AppColors.gradientDarkStart,
                gradientEnd: AppColors.gradientDarkEnd,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Add / NFC menu
              SizedBox(
                height: 40,
                width: 40,
                child: PopupMenuButton<ContactAction>(
                  padding: EdgeInsets.zero,
                  iconSize: 25,
                  // icon: Icon(Icons.add_circle_outline, color: Colors.blue[700]),
                  icon: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(
                        6,
                      ), // square with slight round
                      border: Border.all(color: Colors.blue[700]!, width: 1.5),
                    ),
                    child: Icon(Icons.add, color: Colors.blue[700], size: 22),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: ContactAction.addContact,
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_add_alt_1,
                            color: Colors.blue,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Add Contact',
                            style: TextStyle(color: Colors.grey.shade800),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: ContactAction.nfc,
                      child: Row(
                        children: [
                          Icon(Icons.nfc, color: Colors.green, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'NFC',
                            style: TextStyle(color: Colors.grey.shade800),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (action) {
                    switch (action) {
                      case ContactAction.addContact:
                        controller.navigateToAddContact();
                        break;
                      case ContactAction.nfc:
                        controller.navigateToNfc();
                        break;
                    }
                  },
                ),
              ),

              SizedBox(width: 1.wp),

              // QR button
              SizedBox(
                height: 40,
                width: 40,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 25,
                  icon: Icon(Icons.qr_code_scanner, color: Colors.blue[700]),
                  tooltip: 'QR Scanner',
                  onPressed: controller.navigateToQrPage,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetIcon() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      width: 40,
      height: 40,
      child: Center(
        child: Icon(
          Icons.currency_exchange_rounded,
          size: 22,
          color: Color(
            0xFFD4AF37,
          ), // Classic gold - BEST for blue-green gradient
        ),
      ),
    );
  }
}
