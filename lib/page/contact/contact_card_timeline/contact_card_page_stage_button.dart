import 'package:eventjar/controller/contact/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/contact/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactCardPageStageActionButton extends StatelessWidget {
  final ContactStage currentStage;
  final Function(ContactStage)? onStageTransition;
  final Contact contact;
  final ContactController controller = Get.find();

  ContactCardPageStageActionButton({
    super.key,
    required this.currentStage,
    required this.contact,
    this.onStageTransition,
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

  String get _label {
    switch (currentStage) {
      case ContactStage.newContact:
        return "Message";
      case ContactStage.followup24h:
        return "Schedule";
      case ContactStage.followup7d:
        return "Schedule";
      case ContactStage.followup30d:
        return "Qualify";
      default:
        return "Next";
    }
  }

  void _showTransitionDialog() {
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
    return Column(
      children: [
        SizedBox(height: 8),
        GestureDetector(
          onTap: _showTransitionDialog,
          child: Material(
            elevation: 4,
            shadowColor: _color.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.wp, vertical: 0.5.hp),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _color.withValues(alpha: 0.2),
                    _color.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _color.withValues(alpha: 0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _color.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_icon, size: 13.sp, color: _color),
                  SizedBox(width: 6),
                  Text(
                    _label,
                    style: TextStyle(
                      color: _color,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Container(width: 2, height: 12, color: _color.withValues(alpha: 0.4)),
      ],
    );
  }
}
