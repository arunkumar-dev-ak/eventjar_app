import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:eventjar/model/event_info/event_info_model.dart';
import 'package:flutter/material.dart';

Widget buildOrganizerProfile(Organizer organizer) {
  return Container(
    padding: const EdgeInsets.all(2),
    decoration: BoxDecoration(
      gradient: AppColors.buttonGradient,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: AppColors.gradientDarkStart.withValues(alpha: 0.2),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Container(
      padding: EdgeInsets.all(4.wp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _OrganizerAvatar(organizer: organizer),
          SizedBox(width: 4.wp),
          _OrganizerDetails(organizer: organizer),
        ],
      ),
    ),
  );
}

// Organizer Avatar
class _OrganizerAvatar extends StatelessWidget {
  final Organizer organizer;
  const _OrganizerAvatar({required this.organizer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        gradient: AppColors.buttonGradient,
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        radius: 35,
        backgroundColor: Colors.white,
        backgroundImage:
            (organizer.avatarUrl != null && organizer.avatarUrl!.isNotEmpty)
            ? NetworkImage(getFileUrl(organizer.avatarUrl!))
            : null,
        child: (organizer.avatarUrl == null || organizer.avatarUrl!.isEmpty)
            ? Text(
                organizer.name.isNotEmpty ? organizer.name[0] : "O",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gradientDarkStart,
                ),
              )
            : null,
      ),
    );
  }
}

// Organizer Details (Name, Email, Role Badge)
class _OrganizerDetails extends StatelessWidget {
  final Organizer organizer;
  const _OrganizerDetails({required this.organizer});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildName(),
          if (_hasEmail) ...[SizedBox(height: 0.5.hp), _buildEmail()],
          SizedBox(height: 1.hp),
          _buildRoleBadge(),
        ],
      ),
    );
  }

  bool get _hasEmail => organizer.email != null && organizer.email!.isNotEmpty;

  Widget _buildName() => Text(
    organizer.name,
    style: TextStyle(
      fontSize: 9.sp,
      fontWeight: FontWeight.w600,
      color: Colors.grey.shade800,
    ),
  );

  Widget _buildEmail() => Row(
    children: [
      Icon(Icons.email, size: 12, color: Colors.grey[600]),
      SizedBox(width: 1.wp),
      Expanded(
        child: Text(
          organizer.email!,
          style: TextStyle(fontSize: 7.5.sp, color: Colors.grey[600]),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );

  Widget _buildRoleBadge() => Container(
    padding: EdgeInsets.symmetric(horizontal: 2.5.wp, vertical: 0.6.hp),
    decoration: BoxDecoration(
      gradient: AppColors.buttonGradient,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: AppColors.gradientDarkStart.withValues(alpha: 0.3),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.verified, color: Colors.white, size: 12),
        SizedBox(width: 1.wp),
        Text(
          organizer.role ?? "Organizer",
          style: TextStyle(
            color: Colors.white,
            fontSize: 7.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
