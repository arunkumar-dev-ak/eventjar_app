import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SecretBox extends StatelessWidget {
  final String secret;

  const SecretBox({super.key, required this.secret});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 1.5.hp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade50,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              secret,
              style: TextStyle(fontSize: 9.sp, fontFamily: 'monospace'),
            ),
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: secret));
              // Get.snackbar("Copied", "Secret copied");
            },
            child: Icon(Icons.copy, size: 16.sp),
          ),
        ],
      ),
    );
  }
}
