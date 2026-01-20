import 'package:eventjar/controller/contact/controller.dart';
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
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: controller.heartbeatController,
        builder: (context, child) {
          return Transform.scale(
            scale: controller.pulseAnimation.value,
            child: Material(
              elevation: 4 * controller.glowAnimation.value,
              shadowColor: _color.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      _color.withValues(alpha: 0.8),
                      _color.withValues(alpha: 0.4),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _color.withValues(alpha: 1.0),
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _color.withValues(
                        alpha: controller.glowAnimation.value,
                      ),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(_icon, size: 20, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
