import 'package:eventjar/controller/create_expense/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class CreateExpensePage extends GetView<CreateExpenseController> {
  const CreateExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.appBarTitle,
          style: TextStyle(color: AppColors.textPrimary(context)),
        ),
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimary(context)),
        elevation: 4,
        backgroundColor: AppColors.cardBg(context),
        shadowColor: Colors.black.withValues(alpha: 0.5),
      ),
      body: Text("Hi"),
    );
  }
}
