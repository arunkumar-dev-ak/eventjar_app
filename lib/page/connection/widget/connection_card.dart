import 'package:eventjar/controller/connection/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/connection/connection_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectionCard extends GetView<ConnectionController> {
  final ConnectionRequest request;
  final bool isSentTab;
  final Function(String, String) onAccept;
  final Function(String, String) onReject;
  final Function(String) onCancel;

  const ConnectionCard({
    super.key,
    required this.request,
    required this.isSentTab,
    required this.onAccept,
    required this.onReject,
    required this.onCancel,
  });

  String get otherUserName =>
      isSentTab ? request.toUserName : request.fromUserName;
  String get otherUserUsername =>
      isSentTab ? request.toUserUsername : request.fromUserUsername;
  String get otherUserEmail =>
      isSentTab ? request.toUserEmail : request.fromUserEmail;
  String? get otherUserPosition =>
      isSentTab ? request.toUserPosition : request.fromUserPosition;
  String? get otherUserCompany =>
      isSentTab ? request.toUserCompany : request.fromUserCompany;
  List<UserBadge> get otherUserBadges =>
      isSentTab ? request.toUserBadges : request.fromUserBadges;
  int get otherUserTotalBadges =>
      isSentTab ? request.toUserTotalBadges : request.fromUserTotalBadges;

  String get initials =>
      otherUserName.split(' ').map((n) => n[0]).take(2).join().toUpperCase();

  Color get statusColor {
    switch (request.status) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'declined':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.navigateToEventPage(request.eventId);
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // header
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Initials Circle
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.gradientDarkStart,
                          Colors.blue.shade600,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.wp),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name & Username
                        Text(
                          otherUserName,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Position & Company
                        if (otherUserPosition != null ||
                            otherUserCompany != null)
                          Padding(
                            padding: EdgeInsets.only(top: 0.1.hp),
                            child: Text(
                              '${otherUserPosition ?? ''}${otherUserPosition != null && otherUserCompany != null ? ' at ' : ''}${otherUserCompany ?? ''}',
                              style: TextStyle(
                                fontSize: 8.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        // Badges Count
                        if (otherUserTotalBadges > 0)
                          Padding(
                            padding: EdgeInsets.only(top: 0.1.hp),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber[700],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$otherUserTotalBadges badges',
                                  style: TextStyle(
                                    fontSize: 7.5.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.hp),

              // Event & Time
              Row(
                children: [
                  Icon(Icons.event, size: 18, color: Colors.grey[600]),
                  SizedBox(width: 2.wp),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.eventTitle,
                          style: TextStyle(
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${request.preferredTime} • ${request.duration} min',
                          style: TextStyle(
                            fontSize: 8.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.hp),

              // Message
              if (request.message.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    request.message,
                    style: TextStyle(fontSize: 8.5.sp, color: Colors.grey[800]),
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              SizedBox(height: 1.hp),

              // Status + Actions (Bottom Row)
              Row(
                children: [
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      request.status.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 8.sp,
                      ),
                    ),
                  ),
                  const Spacer(),

                  // Action Buttons (conditional)
                  Obx(() {
                    final isLoading =
                        controller.state.buttonLoading[request.id] == true;

                    if (request.status != 'pending') return const SizedBox();

                    if (isSentTab) {
                      // 🔹 SENT TAB (Withdraw)
                      return SizedBox(
                        height: 3.5.hp,
                        child: ElevatedButton.icon(
                          onPressed: isLoading
                              ? null
                              : () => onCancel(request.id),
                          icon: isLoading
                              ? SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                )
                              : Icon(Icons.cancel_outlined, size: 10.sp),
                          label: Text(
                            isLoading ? 'Withdrawing...' : 'Withdraw',
                            style: TextStyle(fontSize: 8.5.sp),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isLoading
                                ? Colors
                                      .grey
                                      .shade500 // dimmed
                                : Colors.grey.shade600,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            elevation: 0,
                          ),
                        ),
                      );
                    }

                    // 🔹 RECEIVED TAB (Accept / Decline)
                    return Row(
                      children: [
                        SizedBox(
                          height: 3.5.hp,
                          child: ElevatedButton.icon(
                            onPressed: isLoading
                                ? null
                                : () => onAccept(request.id, request.eventId),
                            icon: isLoading
                                ? SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.check, size: 16),
                            label: Text(
                              isLoading ? 'Accepting...' : 'Accept',
                              style: TextStyle(fontSize: 8.5.sp),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isLoading
                                  ? Colors
                                        .green
                                        .shade300 // dim
                                  : Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                        SizedBox(width: 2.wp),
                        SizedBox(
                          height: 3.5.hp,
                          child: ElevatedButton.icon(
                            onPressed: isLoading
                                ? null
                                : () => onReject(request.id, request.eventId),
                            icon: const Icon(Icons.close, size: 16),
                            label: Text(
                              'Decline',
                              style: TextStyle(fontSize: 8.5.sp),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isLoading
                                  ? Colors
                                        .red
                                        .shade300 // dim
                                  : Colors.red.shade600,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
