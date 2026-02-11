import 'dart:io';

import 'package:eventjar/global/customized_upgrader/custom_upgrader_gradient_button.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';
import 'package:eventjar/global/app_colors.dart';

class CustomUpgradeAlert extends UpgradeAlert {
  CustomUpgradeAlert({
    super.key,
    super.upgrader,
    super.child,
    super.onIgnore,
    super.onUpdate,
    super.onLater,
    super.showIgnore,
    super.showReleaseNotes,
  });

  @override
  UpgradeAlertState createState() => _CustomUpgradeAlertState();
}

class _CustomUpgradeAlertState extends UpgradeAlertState {
  @override
  void showTheDialog({
    Key? key,
    required BuildContext context,
    required String? title,
    required String message,
    required String? releaseNotes,
    required bool barrierDismissible,
    required UpgraderMessages messages,
  }) {
    widget.upgrader.saveLastAlerted();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: barrierDismissible,
      builder: (context) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            // Main sheet
            Container(
              margin: const EdgeInsets.only(top: 50),
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Update Available 🚀",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 1.hp),
                  Text(
                    "A new version of MyEventJar is ready with improvements, new features and better performance.",
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 2.hp),

                  // UPDATE BUTTON
                  CustomUpgraderGradientButton(
                    text: "Update Now",
                    onTap: () {
                      onUserUpdated(context, !widget.upgrader.blocked());
                    },
                  ),

                  SizedBox(height: 1.hp),

                  // LATER BUTTON
                  SafeArea(
                    child: TextButton(
                      onPressed: () {
                        onUserLater(context, true);
                      },
                      child: Text(
                        "Remind Me Later",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 9.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Floating circle icon
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: AppColors.buttonGradient,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 5),
              ),
              child: Icon(
                Platform.isAndroid ? Icons.android : Icons.apple,
                color: Colors.white,
                size: 42,
              ),
            ),
          ],
        );
      },
    );
  }
}
