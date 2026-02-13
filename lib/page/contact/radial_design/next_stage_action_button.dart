import 'package:eventjar/controller/contact/controller.dart';
import 'package:eventjar/global/app_toast.dart';
import 'package:eventjar/model/contact/contact_model.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NextStageActionButton extends GetView<ContactController> {
  final ContactStage currentStage;
  final MobileContact contact;

  const NextStageActionButton({
    super.key,
    required this.currentStage,
    required this.contact,
  });

  IconData get _icon {
    switch (currentStage) {
      case ContactStage.newContact:
        return Icons.send;
      case ContactStage.followup24h:
      case ContactStage.followup7d:
        return Icons.schedule;
      case ContactStage.followup30d:
        return Icons.verified_user;
      default:
        return Icons.arrow_forward;
    }
  }

  Color get _color {
    switch (currentStage) {
      case ContactStage.newContact:
        return Colors.blue;
      case ContactStage.followup24h:
      case ContactStage.followup7d:
        return Colors.cyan;
      case ContactStage.followup30d:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _handleTap() {
    // Stop pulse → BIG pulse → restart
    controller.heartbeatController.stop();
    controller.heartbeatController.forward().then((_) {
      controller.heartbeatController.repeat(reverse: true);
    });

    switch (currentStage) {
      case ContactStage.newContact:
        controller.navigateToThankyouMessage(contact);
        break;
      case ContactStage.followup24h:
      case ContactStage.followup7d:
        controller.navigateToScheduleMeeting(contact);
        break;
      case ContactStage.followup30d:
        controller.navigateToQualifyLead(contact);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasActiveMeeting = contact.activeMeeting != null;

    return GestureDetector(
      onTap: () {
        if (hasActiveMeeting) {
          AppToast.warning('Complete meeting to move to next stage');
          return;
        }

        _handleTap();
      },
      child: AnimatedBuilder(
        animation: controller.heartbeatController,
        builder: (context, child) {
          return Transform.scale(
            scale: hasActiveMeeting ? 1 : controller.pulseAnimation.value,
            child: Opacity(
              opacity: hasActiveMeeting ? 0.5 : 1,
              child: Material(
                elevation: hasActiveMeeting
                    ? 2
                    : 4 * controller.glowAnimation.value,
                shadowColor: _color.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: hasActiveMeeting
                          ? [Colors.grey.shade400, Colors.grey.shade300]
                          : [
                              _color.withValues(alpha: 0.8),
                              _color.withValues(alpha: 0.4),
                            ],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: hasActiveMeeting
                          ? Colors.grey
                          : _color.withValues(alpha: 1.0),
                      width: 2.5,
                    ),
                    boxShadow: hasActiveMeeting
                        ? []
                        : [
                            BoxShadow(
                              color: _color.withValues(
                                alpha: controller.glowAnimation.value,
                              ),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(_icon, size: 20, color: Colors.white),

                      // 🔒 Lock icon overlay
                      if (hasActiveMeeting)
                        Positioned(
                          bottom: -2,
                          right: -2,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lock,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
