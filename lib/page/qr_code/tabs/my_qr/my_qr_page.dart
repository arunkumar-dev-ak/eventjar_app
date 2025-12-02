import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQrView extends StatelessWidget {
  const MyQrView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: QrImageView(
        data: "your_user_data_or_id", // Replace dynamically
        size: 200,
      ),
    );
  }
}
