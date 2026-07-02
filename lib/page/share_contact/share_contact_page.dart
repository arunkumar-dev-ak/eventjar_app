import 'package:eventjar/controller/share_contact/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class ShareContactPage extends GetView<ShareContactController> {
  const ShareContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.budgetScaffoldBgColor,

      // ---------------- APP BAR ----------------
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          controller.appBarTitle,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15.sp,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appBarGradientFor(context),
          ),
        ),
        centerTitle: false,
      ),

      // ---------------- BODY ----------------
      body: Text("in share contact page"),
    );
  }
}
