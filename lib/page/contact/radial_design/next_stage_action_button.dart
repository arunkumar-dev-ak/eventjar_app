import 'package:eventjar/controller/contact/controller.dart';
import 'package:eventjar/model/contact/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NextStageActionButton extends StatelessWidget {
  final ContactStage currentStage;
  final Contact contact;

  const NextStageActionButton({
    super.key,
    required this.currentStage,
    required this.contact,
  });

  ContactController get _controller => Get.find<ContactController>();

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
    switch (currentStage) {
      case ContactStage.newContact:
        _controller.navigateToThankyouMessage(contact);
        break;
      case ContactStage.followup24h:
      case ContactStage.followup7d:
        _controller.navigateToScheduleMeeting(contact);
        break;
      case ContactStage.followup30d:
        _controller.navigateToQualifyLead(contact);
        break;
      default:
        break;
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Material(
        elevation: 2,
        shadowColor: _color.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              // ✅ DARK gradient background
              colors: [
                _color.withValues(alpha: 0.7),
                _color.withValues(alpha: 0.5),
                _color.withValues(alpha: 0.6),
              ],
              center: Alignment.center,
              radius: 0.8,
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: _color.withValues(alpha: 0.8),
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _color.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: Offset(0, 6),
                spreadRadius: 0,
              ),
              // Subtle inner glow
              BoxShadow(
                color: _color.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: Offset(0, 2),
                spreadRadius: -1,
              ),
            ],
          ),
          child: Icon(
            _icon,
            size: 20,
            color: Colors.white.withValues(alpha: 0.95), // ✅ Crisp white
          ),
        ),
      ),
    );
  }
}
