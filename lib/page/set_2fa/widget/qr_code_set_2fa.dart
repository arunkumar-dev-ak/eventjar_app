import 'dart:convert';
import 'dart:typed_data';

import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

class QrCodeCard extends StatelessWidget {
  final String qrCode;

  const QrCodeCard({super.key, required this.qrCode});

  Uint8List getQrImageBytes(String base64String) {
    final base64Data = base64String.split(',').last;
    return base64Decode(base64Data);
  }

  @override
  Widget build(BuildContext context) {
    final bytes = getQrImageBytes(qrCode);

    return Container(
      padding: EdgeInsets.all(3.wp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Image.memory(bytes, width: 45.wp, height: 45.wp),
    );
  }
}
