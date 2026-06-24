import 'package:eventjar/controller/expense_detail/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditExpenseNameDialog extends GetView<ExpenseDetailController> {
  final TextEditingController nameController;
  final RxString currentText;
  final Future<bool> Function(String newName) onSave;

  EditExpenseNameDialog({
    super.key,
    required this.nameController,
    required this.currentText,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('edit_expense_name'.tr),
      content: TextField(
        controller: nameController,
        autofocus: true,
        onChanged: (val) => currentText.value = val,
        decoration: InputDecoration(
          hintText: 'expense_name'.tr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      actions: [
        Obx(
          () => TextButton(
            onPressed: controller.state.isEditLoading.value
                ? null
                : () => Get.back(),
            child: Text('cancel'.tr),
          ),
        ),
        Obx(() {
          final text = currentText.value.trim();
          final isValid = text.isNotEmpty;
          final loading = controller.state.isEditLoading.value;

          return FilledButton(
            // Disable button if empty OR currently loading
            onPressed: (isValid && !loading)
                ? () async {
                    controller.state.isEditLoading.value = true;

                    final success = await onSave(text);

                    if (success) {
                      //closing popup
                      Navigator.pop(Get.context!);
                    }
                    controller.state.isEditLoading.value = false;
                  }
                : null,
            child: loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text('save'.tr),
          );
        }),
      ],
    );
  }
}
